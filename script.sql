CREATE TABLE public.exchanges(
 id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
 name character varying COLLATE pg_catalog."default",
 router_address character varying COLLATE pg_catalog."default",
 is_active boolean,
 CONSTRAINT dex_pkey PRIMARY KEY (id)
);

INSERT INTO public.exchanges(name, router_address, is_active)  VALUES ('uniSwap', '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D', true);
INSERT INTO public.exchanges (name, router_address, is_active)  VALUES ('sushiSwap', '0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F', true);
INSERT INTO public.exchanges(name, router_address, is_active)  VALUES ('pancakeSwap', '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F', false);


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

INSERT INTO public.pairs (exchange_id, input_token_symbol, input_token_decimals, input_token_address, output_token_symbol, output_token_decimals, output_token_address, pair_address, input_amount) VALUES ( 2, 'ETH', '18', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'DAI', '18', '0x6b175474e89094c44da98b954eedeac495271d0f', '0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f', '{"amount":1,"token":"ETHER"}');
INSERT INTO public.pairs (exchange_id, input_token_symbol, input_token_decimals, input_token_address, output_token_symbol, output_token_decimals, output_token_address, pair_address, input_amount) VALUES ( 1, 'ETH', '18', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'USDT', '6', '0xdac17f958d2ee523a2206206994597c13d831ec7', '0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852', '{"amount":1,"token":"ETHER"}');
INSERT INTO public.pairs (exchange_id, input_token_symbol, input_token_decimals, input_token_address, output_token_symbol, output_token_decimals, output_token_address, pair_address, input_amount) VALUES ( 3, 'BNB', '18', '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c', 'BUSD', '18', '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c', '0x1B96B92314C44b159149f7E0303511fB2Fc4774f', '{"amount":1,"token":"ETHER"}');


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
