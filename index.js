const db = require('./db')
require('dotenv').config()
const Web3 = require('web3')
const moment = require('moment')
const _ = require('lodash')

const {
  pairABI,
  dexRouterABI
} = require('./utils')

// WEB3 CONFIG
let web3 = new Web3(process.env.RPC_URL)

// Display output
let TABLE_OUTPUT = []

async function checkPair(args, exchange, datetime) {
  const {
    pairId,
    inputTokenSymbol,
    inputTokenDecimals,
    inputTokenAddress,
    outputTokenSymbol,
    outputTokenDecimals,
    outputTokenAddress,
    pairAddress,
    inputAmount
  } = args
  const {
    dexId,
    dexName,
    dexRouterAddress
  } = exchange

  let pairReserves0
  let pairReserves1
  let dexRouterContract
  let pairContract
  let pairReserves

  // Exhange init
  web3 = new Web3(process.env.RPC_URL)
  dexRouterContract = new web3.eth.Contract(JSON.parse(dexRouterABI), dexRouterAddress)
  pairContract = new web3.eth.Contract(JSON.parse(pairABI), pairAddress)
  pairReserves = await pairContract.methods.getReserves().call()

  // Binance Smart Chain RPC Chain
  if (dexName === 'pancakeSwap') {
    const NODE_URL = process.env.NODE_URL
    const provider = new Web3.providers.HttpProvider(NODE_URL)
    web3 = new Web3(provider)
    dexRouterContract = new web3.eth.Contract(JSON.parse(dexRouterABI), dexRouterAddress)
    pairContract = new web3.eth.Contract(JSON.parse(pairABI), pairAddress)
    pairReserves = await pairContract.methods.getReserves().call()
  }

  if (inputTokenDecimals == 18 && outputTokenDecimals == 18){
    pairReserves0 = pairReserves._reserve0;
    pairReserves1 = pairReserves._reserve1;
  }
  else if (inputTokenSymbol == 'USDC' || inputTokenSymbol == 'USDT'){
     // input USDC & USDT Have 6 Decimals
     pairReserves0 = (BigInt(Number(pairReserves._reserve0 )* 1000000000000)).toString();
     pairReserves1 = pairReserves._reserve1;
  }
  else if (outputTokenSymbol == 'USDC' || outputTokenSymbol == 'USDT'){
     // output USDC and USDT Have 6 Decimals
     pairReserves0 = pairReserves._reserve0;
     pairReserves1 = (BigInt(Number(pairReserves._reserve1 )* 1000000000000)).toString();
  }
  else if (inputTokenSymbol == 'USDC' && outputTokenSymbol == 'USDT' || outputTokenSymbol == 'USDC' && inputTokenSymbol == 'USDT'){
    // output USDC and USDT Have 6 Decimals
    pairReserves0 = (BigInt(Number(pairReserves._reserve0 )* 1000000000000)).toString();
    pairReserves1 = (BigInt(Number(pairReserves._reserve1 )* 1000000000000)).toString();
  }
  else if (inputTokenSymbol == 'WBTC'){
     pairReserves0 = (BigInt(Number(pairReserves._reserve0 )* 10000000000)).toString();
     pairReserves1 = pairReserves._reserve1;
  }
  else if (outputTokenSymbol == 'WBTC'){
     pairReserves0 = pairReserves._reserve0;
     pairReserves1 = (BigInt(Number(pairReserves._reserve1 )* 10000000000)).toString();
  }

  const getPairRateO = await dexRouterContract.methods.getAmountOut(inputAmount, pairReserves1, pairReserves0).call()
  const getPairRate1 = await dexRouterContract.methods.getAmountOut(inputAmount, pairReserves0, pairReserves1).call()

  let directionOne = `${inputTokenSymbol}/${outputTokenSymbol}`
  let directionTwo = `${outputTokenSymbol}/${inputTokenSymbol}`

  let sql = `
    -- insert getPairRateO
    INSERT INTO RATES (exchange_id, pair_id, direction, rate, datetime) VALUES (${dexId}, ${pairId}, '${directionOne}', ${web3.utils.fromWei(getPairRateO, 'Ether')}, '${datetime}');

    -- insert getPairRate1
    INSERT INTO RATES (exchange_id, pair_id, direction, rate, datetime) VALUES (${dexId}, ${pairId}, '${directionTwo}', ${web3.utils.fromWei(getPairRate1, 'Ether')}, '${datetime}');
  `
  db.query(sql)

  // Output our data to the TABLE_OUTPUT
  TABLE_OUTPUT.push(
    {
      'exchange': dexName,
      'direction': directionOne,
      'inputAmount': web3.utils.fromWei(inputAmount, 'Ether'),
      'rate': web3.utils.fromWei(getPairRate1, 'Ether'),
      'datetime': datetime,
    },
    {
      'exchange': dexName,
      'direction': directionTwo,
      'inputAmount': web3.utils.fromWei(inputAmount, 'Ether'),
      'rate': web3.utils.fromWei(getPairRateO, 'Ether'),
      'datetime': datetime,
    }
  )
}

let priceMonitor
let monitoringPrice = false
let datetime = moment().utc().format()

async function monitorPrice() {
  if (monitoringPrice) {
    return
  }

  let sql = `
    SELECT
      e.id AS dexid,
      p.id AS pair_id,
      e.name,
      e.router_address,
      p.input_token_symbol,
      p.input_token_decimals,
      p.input_token_address,
      p.output_token_symbol,
      p.output_token_decimals,
      p.output_token_address,
      p.pair_address,
      input_amount
    FROM
      pairs p
    INNER JOIN exchanges e on p.exchange_id = e.id where e.is_active = true;
  `

  const pairsExchange = await db.query(sql)
  monitoringPrice = true
  datetime = moment().utc().format()

  try {
    // Iterate over our pairs and fetch
    pairsExchange?.map((data) => {
      const {
        amount,
        token
      } = data.input_amount

      checkPair(
        {
          pairId: data.pair_id,
          inputTokenSymbol: data.input_token_symbol,
          inputTokenDecimals: data.input_token_decimals,
          inputTokenAddress: data.input_token_address,
          outputTokenSymbol: data.output_token_symbol,
          outputTokenDecimals: data.output_token_decimals,
          outputTokenAddress: data.output_token_address,
          pairAddress: data.pair_address,
          inputAmount: web3.utils.toWei(String(amount), String(token)),
        },
        {
          dexId: data.dexid,
          dexName: data.name,
          dexRouterAddress: data.router_address,
        },
        datetime
      )
    })
  } catch (error) {
    console.error(error)
    monitoringPrice = false
    clearInterval(priceMonitor)
    returns
  }

  // Lets keep our prices table light, lets delete any old prices older than N minutes
  const minutesAgo = moment().utc().subtract(1, 'minutes')
  sql = `DELETE FROM RATES WHERE datetime < '${minutesAgo.format()}';`
  // db.query(sql)

  // Make sure the exchange/input_token is always in the same order
  TABLE_OUTPUT = _.orderBy(TABLE_OUTPUT, ['exchange'], ['inputToken'])

  // I think we are delayed here one by iteration due to checkPair being an aysnc function
  // Console table out our TABLE_OUTPUT and then reset it
  console.log(`${datetime}`)
  console.table(TABLE_OUTPUT)

  // Clear out the TABLE_OUTPUT
  TABLE_OUTPUT = []

  // Set to false
  monitoringPrice = false
}

// Check markets every n seconds
const POLLING_INTERVAL = process.env.POLLING_INTERVAL || 15000 // 15 Seconds
priceMonitor = setInterval(async () => {
  await monitorPrice()
}, POLLING_INTERVAL)
