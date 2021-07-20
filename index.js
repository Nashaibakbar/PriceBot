
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
  const {pairId, inputTokenSymbol,inputTokenDecimals, inputTokenAddress, outputTokenSymbol,outputTokenDecimals, outputTokenAddress,pairAddress,inputAmount } = args
  const {dexId,dexName,dexRouterAddress} = exchange;

  let pairReserves0; 
    let pairReserves1;
    let dexRouterContract;
    let pairContract;
    let pairReserves;


    // Exhange init 
    if(dexName.toLowerCase() === "pancakeswap"){
      // Binance Smart Chain RPC Chain
      const NODE_URL = process.env.NODE_URL;
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
priceMonitor = setInterval(async () => { await monitorPrice() }, POLLING_INTERVAL)