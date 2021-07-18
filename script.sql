create table savedprices
(
    no          bigint generated always as identity (maxvalue 10000000000000000)
        constraint savedprices_pkey
            primary key,
    inputtoken  varchar,
    outputtoken varchar,
    inputamount varchar,
    uniswapv2   varchar,
    sushiswap   varchar,
    timestamp   varchar
);

alter table savedprices
    owner to postgres;

create table checkpair
(
    no                   bigint generated always as identity (maxvalue 10000000000000000)
        constraint checkpair_pkey
            primary key,
    inputtokensymbol     varchar,
    inputtokenaddress    varchar,
    outputtokensymbol    varchar,
    outputtokenaddress   varchar,
    uniswappairaddress   varchar,
    sushiswappairaddress varchar
);

alter table checkpair
    owner to postgres;
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DAI', '0x6b175474e89094c44da98b954eedeac495271d0f', '0xa478c2975ab1ea89e8196811f51a7b7ade33eb11', '0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'USDC', '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', '0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc', '0x397FF1542f962076d0BFE58eA045FfA2d347ACa0');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'USDT', '0xdac17f958d2ee523a2206206994597c13d831ec7', '0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852', '0x06da0fd433C1A5d7a4faa01111c044910A184553');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'UNI', '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0xd3d2e2692501a5c9ca623199d38826e513033a17', '0xDafd66636E2561b0284EDdE37e42d192F2844D40');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'AVVE', '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9', '0xdfc14d2af169b0d36c4eff567ada9b2e0cae044f', '0xD75EA151a61d06868E31F8988D28DFE5E9df57B4');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'WETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'WBTC', '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599', '0xbb2b8038a1640196fbe3e38816f3e67cba72d940', '0xCEfF51756c56CeFFCA006cD410B03FFC46dd3a58');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MATIC', '0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0', '0x819f3450da6f110ba6ea52195b3beafa246062de', '0x7f8F7Dd53D1F3ac1052565e3ff451D7fE666a311');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'LINK', '0x514910771af9ca656af840dff83e8264ecf986ca', '0xa2107fa5b38d9bbd2c461d6edf11b11a50f6b974', '0xC40D16476380e4037e6b1A2594cAF6a6cc8Da967');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DOGE', '0x35a532d376ffd9a705d0bb319532837337a398e7', '0xc3d7aa944105d3fafe07fc1822102449c916a8d0', '0x60Bce13608701789Ab9c8Faa9B82dE115Ea8744d');
INSERT INTO checkpair ( inputtokensymbol, inputtokenaddress, outputtokensymbol, outputtokenaddress, uniswappairaddress, sushiswappairaddress) VALUES ( 'ETH', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MKR', '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2', '0xc2adda861f89bbb333c90c492cb837741916a225', '0xBa13afEcda9beB75De5c56BbAF696b880a5A50dD');


