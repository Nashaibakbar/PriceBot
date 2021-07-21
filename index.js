
const db = require("./db");
require('dotenv').config()
const express = require('express')
const bodyParser = require('body-parser')
const http = require('http')
const Web3 = require('web3')
const HDWalletProvider = require('@truffle/hdwallet-provider')
const moment = require('moment-timezone')
const numeral = require('numeral')
const _ = require('lodash')
const axios = require('axios')
const { pairABI,dexRouterABI} = require('./utils');

// SERVER CONFIG
const PORT = process.env.PORT || 5000
const app = express();
const server = http.createServer(app).listen(PORT, () => console.log(`Listening on ${ PORT }`))

// WEB3 CONFIG
let web3 = new Web3(process.env.RPC_URL)

async function checkPair(args,exchange) {
<<<<<<< HEAD
  const { inputTokenSymbol,inputTokenDecimals, inputTokenAddress, outputTokenSymbol,outputTokenDecimals, outputTokenAddress,pairAddress,inputAmount } = args
  const {dexName,dexRouterAddress} = exchange;
    
    let pairReserves0; 
=======
  const {pairId, inputTokenSymbol,inputTokenDecimals, inputTokenAddress, outputTokenSymbol,outputTokenDecimals, outputTokenAddress,pairAddress,inputAmount } = args
  const {dexId,dexName,dexRouterAddress} = exchange;

  let pairReserves0; 
>>>>>>> aasim_branch
    let pairReserves1;
    let dexRouterContract;
    let pairContract;
    let pairReserves;


    // Exhange init 
<<<<<<< HEAD
    if(dexName == "PancakeSwap" || dexName == "pancakeswap"){
      // Binance Smart Chain RPC Chain
      const NODE_URL = "https://speedy-nodes-nyc.moralis.io/bb5205b84accc06e25cb64ca/bsc/mainnet";
=======
    if(dexName.toLowerCase() === "pancakeswap"){
      // Binance Smart Chain RPC Chain
      const NODE_URL = process.env.NODE_URL;
>>>>>>> aasim_branch
      const provider = new Web3.providers.HttpProvider(NODE_URL);
      web3 = new Web3(provider);
      dexRouterContract  = new web3.eth.Contract(JSON.parse(dexRouterABI),dexRouterAddress);
      pairContract = new web3.eth.Contract(JSON.parse(pairABI),pairAddress);
      pairReserves = await pairContract.methods.getReserves().call();
    }
    else
    {
      web3 = new Web3(process.env.RPC_URL);
     dexRouterContract  = new web3.eth.Contract(JSON.parse(dexRouterABI),dexRouterAddress);
     pairContract = new web3.eth.Contract(JSON.parse(pairABI),pairAddress);
     pairReserves = await pairContract.methods.getReserves().call();
    }
   
  

    if(inputTokenDecimals == 18 && outputTokenDecimals == 18){
     pairReserves0 = pairReserves._reserve0;
     pairReserves1 = pairReserves._reserve1;
    } 
    else if (inputTokenSymbol == "USDC" || outputTokenSymbol == "USDC"){
      // USDC On EtherScan Have 6 Decimals
      pairReserves0 = (BigInt(Number(pairReserves._reserve0 )* 1000000000000)).toString();
      pairReserves1 = pairReserves._reserve1;
    }
    else if (inputTokenSymbol == "USDT" || outputTokenSymbol == "USDT"){
      // USDT On EtherScan Have 6 Decimals
      pairReserves0 = pairReserves._reserve0;
      pairReserves1 = (BigInt(Number(pairReserves._reserve1 )* 1000000000000)).toString();
    }
    else if (inputTokenSymbol == "WBTC" || outputTokenSymbol == "WBTC"){
      pairReserves0 = (BigInt(Number(pairReserves._reserve0 )* 10000000000)).toString();
      pairReserves1 = pairReserves._reserve1;
    }
    
    const getPairPriceO = await dexRouterContract.methods.getAmountOut(inputAmount,pairReserves1,pairReserves0).call();
    const getPairPrice1 = await dexRouterContract.methods.getAmountOut(inputAmount,pairReserves0,pairReserves1).call();
   
    ++i;
    console.table([{
      'No:': i,
      'Exchange': dexName,
      'Input Token': inputTokenSymbol,
      'Output Token': outputTokenSymbol,
      'Input Amount': web3.utils.fromWei(inputAmount, 'Ether'),
      'Price': web3.utils.fromWei(getPairPriceO, 'Ether'),
      'Timestamp': moment().tz('America/Chicago').format(),
    }])
    db.query(`insert into prices (exchangeid,pairid,price,timestamp) values (${dexId}, ${pairId},${web3.utils.fromWei(getPairPriceO, 'Ether')},'${moment().tz('America/Chicago').format()}')`);

    ++i;
    console.table([{
      'No:': i,
      'Exchange': dexName,
      'Input Token': outputTokenSymbol,
      'Output Token': inputTokenSymbol,
      'Input Amount': web3.utils.fromWei(inputAmount, 'Ether'),
      'Price': web3.utils.fromWei(getPairPrice1, 'Ether'),
      'Timestamp': moment().tz('America/Chicago').format(),
    }])
    db.query(`insert into prices (exchangeid,pairid,price,timestamp) values (${dexId}, ${pairId},${web3.utils.fromWei(getPairPrice1, 'Ether')},'${moment().tz('America/Chicago').format()}')`);
  }


let priceMonitor
let monitoringPrice = false
let i =0;


async function monitorPrice() {
  if(monitoringPrice) {
    return
  }

  console.log("Checking prices...")
  const  pairsnexhange= await db.query('select e.id AS "dexid",p.id AS "pairid", e.name,e.routeraddress,p.inputtokensymbol,p.inputtokendecimals,p.inputtokenaddress,p.outputtokensymbol,p.outputtokendecimals,p.outputtokenaddress,p.pairaddress,inputamount from pairs p inner join exchanges e on p.exchangeid=e.id where e.isactive=true');
  monitoringPrice = true

  try {
<<<<<<< HEAD

    // BNB/BUSD
    await checkPair({
      inputTokenSymbol: 'BNB',
      inputTokenDecimals: 18,
      inputTokenAddress: '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c',
      outputTokenSymbol: 'BUSD',
      outputTokenDecimals: 18,
      outputTokenAddress: '0xe9e7cea3dedca5984780bafc599bd69add087d56',
      pairAddress: '0x1B96B92314C44b159149f7E0303511fB2Fc4774f',
      inputAmount: web3.utils.toWei('1', 'ETHER'),
    },
    {
      dexName: 'PancakeSwap',
      dexRouterAddress: '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F',
    })    
    

    // 1. ETH-DAI Pair
    await checkPair({
      inputTokenSymbol: 'ETH',
      inputTokenDecimals: 18,
      inputTokenAddress: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2',
      outputTokenSymbol: 'DAI',
      outputTokenDecimals: 18,
      outputTokenAddress: '0x6b175474e89094c44da98b954eedeac495271d0f',
      pairAddress: '0xa478c2975ab1ea89e8196811f51a7b7ade33eb11',
      inputAmount: web3.utils.toWei('1', 'ETHER'), }
    ,{
      dexName: 'UniSwap',
      dexRouterAddress: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
     })

    await checkPair({
      inputTokenSymbol: 'ETH',
      inputTokenDecimals: 18,
      inputTokenAddress: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2',
      outputTokenSymbol: 'DAI',
      outputTokenDecimals: 18,
      outputTokenAddress: '0x6b175474e89094c44da98b954eedeac495271d0f',
      pairAddress: '0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f',
      inputAmount: web3.utils.toWei('1', 'ETHER'),
     
    }
    ,{
      dexName: 'SushiSwap',
      dexRouterAddress: '0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F',
      })

   //  3.ETH-USDT Pair
    await checkPair({
      inputTokenSymbol: 'ETH',
      inputTokenDecimals: 18,
      inputTokenAddress: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2',
      outputTokenSymbol: 'USDT',
      inputTokenDecimals: 6,
      outputTokenAddress: '0xdac17f958d2ee523a2206206994597c13d831ec7',
      pairAddress: '0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852',
      inputAmount: web3.utils.toWei('1', 'ETHER'),
     
    },{
      dexName: 'UniSwap',
      dexRouterAddress: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
    })
=======
pairsnexhange?.map((data) => {
  const {amount,token}=data.inputamount
    checkPair({
      pairId:data.pairid,
      inputTokenSymbol: data.inputtokensymbol,
      inputTokenDecimals: data.inputtokendecimals,
      inputTokenAddress: data.inputtokenaddress,
      outputTokenSymbol: data.outputtokensymbol,
      outputTokenDecimals: data.outputtokendecimals,
      outputTokenAddress: data.outputtokenaddress,
      pairAddress: data.pairaddress,
      inputAmount: web3.utils.toWei(String(amount),String(token)), },
      {
        dexId: data.dexid,
        dexName: data.name,
        dexRouterAddress: data.routeraddress,
      })})  


>>>>>>> aasim_branch

  } catch (error) {
    console.error(error)
    monitoringPrice = false
    clearInterval(priceMonitor)
    returns
  }

  monitoringPrice = false
  i=0;
}

// Check markets every n seconds
const POLLING_INTERVAL = process.env.POLLING_INTERVAL || 10000 // 3 Seconds
<<<<<<< HEAD
priceMonitor = setInterval(async () => { await monitorPrice() }, POLLING_INTERVAL)
=======
priceMonitor = setInterval(async () => { await monitorPrice() }, POLLING_INTERVAL)
>>>>>>> aasim_branch
