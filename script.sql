CREATE TABLE public.exchanges(
 id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
 name character varying COLLATE pg_catalog."default",
 router_address character varying COLLATE pg_catalog."default",
 is_active boolean,
 CONSTRAINT dex_pkey PRIMARY KEY (id)
);

INSERT INTO
  public.exchanges(name, router_address, is_active)
VALUES
  ('uniSwap', '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D', true),
  ('sushiSwap', '0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F', true);


CREATE TABLE public.pairs(
  id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
  exchange_id integer,
  input_token_symbol character varying COLLATE pg_catalog."default",
  input_token_decimals character varying COLLATE pg_catalog."default",
  input_token_address character varying COLLATE pg_catalog."default",
  output_token_symbol character varying COLLATE pg_catalog."default",
  output_token_decimals character varying COLLATE pg_catalog."default",
  output_token_address character varying COLLATE pg_catalog."default",
  pair_address character varying COLLATE pg_catalog."default",
  input_amount json,
  CONSTRAINT pairs_pkey PRIMARY KEY (id),
  CONSTRAINT pairs_fkey FOREIGN KEY (exchange_id)
    REFERENCES public.exchanges (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID
);


INSERT INTO
  public.pairs(exchange_id, input_token_symbol, input_token_decimals, input_token_address, output_token_symbol, output_token_decimals, output_token_address, pair_address, input_amount)
VALUES
  -- exchange_id 1 == uniSwap, 2 == sushiSwap
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'AVVE', 18, '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9', '0xdfc14d2af169b0d36c4eff567ada9b2e0cae044f', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'AVVE', 18, '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9', '0xD75EA151a61d06868E31F8988D28DFE5E9df57B4', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DAI', 18, '0x6b175474e89094c44da98b954eedeac495271d0f', '0xa478c2975ab1ea89e8196811f51a7b7ade33eb11', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DAI', 18, '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DOGE', 18, '0x35a532d376ffd9a705d0bb319532837337a398e7', '0xc3d7aa944105d3fafe07fc1822102449c916a8d0', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DOGE', 18, '0x35a532d376ffd9a705d0bb319532837337a398e7', '0x60Bce13608701789Ab9c8Faa9B82dE115Ea8744d', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DPI', 18, '0x1494ca1f11d487c2bbe4543e90080aeba4ba3c2b', '0x4d5ef58aac27d99935e5b6b4a6778ff292059991', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DPI', 18, '0x1494ca1f11d487c2bbe4543e90080aeba4ba3c2b', '0x34b13F8CD184F55d0Bd4Dd1fe6C07D46f245c7eD', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'HEZ', 18, '0xeef9f339514298c6a857efcfc1a762af84438dee', '0x23d15edceb5b5b3a23347fa425846de80a2e8e5c', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'HEZ', 18, '0xeef9f339514298c6a857efcfc1a762af84438dee', '0xD7c2A4aa31E1bF08dc7Ff44C9980fa8573E10C1B', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'LINK', 18, '0x514910771af9ca656af840dff83e8264ecf986ca', '0xa2107fa5b38d9bbd2c461d6edf11b11a50f6b974', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'LINK', 18, '0x514910771af9ca656af840dff83e8264ecf986ca', '0xC40D16476380e4037e6b1A2594cAF6a6cc8Da967', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'LON', 18, '0x0000000000095413afc295d19edeb1ad7b71c952', '0x7924a818013f39cf800f5589ff1f1f0def54f31f', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'LON', 18, '0x0000000000095413afc295d19edeb1ad7b71c952', '0x0EEB656C196E3022f6052BB2858b884817090dfE', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MATIC', 18, '0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0', '0x819f3450da6f110ba6ea52195b3beafa246062de', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MATIC', 18, '0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0', '0x7f8F7Dd53D1F3ac1052565e3ff451D7fE666a311', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MKR', 18, '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2', '0xc2adda861f89bbb333c90c492cb837741916a225', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'MKR', 18, '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2', '0xBa13afEcda9beB75De5c56BbAF696b880a5A50dD', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'SHIB', 18, '0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce', '0x4d5ef58aac27d99935e5b6b4a6778ff292059991', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'SHIB', 18, '0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce', '0x24D3dD4a62e29770cf98810b09F89D3A90279E7a', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'UNI', 18, '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0xd3d2e2692501a5c9ca623199d38826e513033a17', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'UNI', 18, '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0xDafd66636E2561b0284EDdE37e42d192F2844D40', '{"amount":1,"token":"ETHER"}'),
  (1, 'USDC', 6,	'0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', 'ETH', 18, '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc', '{"amount":1,"token":"ETHER"}'),
  (1, 'DAI', 18,	'0x6b175474e89094c44da98b954eedeac495271d0f', 'USDC', 6, '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', '0xAE461cA67B15dc8dc81CE7615e0320dA1A9aB8D5', '{"amount":1,"token":"ETHER"}'),
  (1, 'USDC', 6,	'0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', 'ETH', 18, '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc', '{"amount":1,"token":"ETHER"}'),
  (2, 'DAI', 18,	'0x6b175474e89094c44da98b954eedeac495271d0f', 'USDC', 6, '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', '0xAaF5110db6e744ff70fB339DE037B990A20bdace', '{"amount":1,"token":"ETHER"}'),
  (1, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'USDT', 6, '0xdac17f958d2ee523a2206206994597c13d831ec7', '0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852', '{"amount":1,"token":"ETHER"}'),
  (2, 'ETH', 18,	'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'USDT', 6, '0xdac17f958d2ee523a2206206994597c13d831ec7', '0x06da0fd433C1A5d7a4faa01111c044910A184553', '{"amount":1,"token":"ETHER"}'),
  (1, 'WBTC', 8,	'0x2260fac5e5542a773aa44fbcfedf7c193bc2c599', 'ETH', 18, '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0xbb2b8038a1640196fbe3e38816f3e67cba72d940', '{"amount":1,"token":"ETHER"}'),
  (2, 'WBTC', 8,	'0x2260fac5e5542a773aa44fbcfedf7c193bc2c599', 'ETH', 18, '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0xbb2b8038a1640196fbe3e38816f3e67cba72d940', '{"amount":1,"token":"ETHER"}'),


CREATE TABLE public.rates(
 id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
 exchange_id integer,
 pair_id integer,
 direction character varying COLLATE pg_catalog."default",
 rate double precision,
 slippage_rate double precision,
 "datetime" character varying COLLATE pg_catalog."default",
 CONSTRAINT rates_pkey PRIMARY KEY (id)
)
