CREATE TABLE public.exchanges
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
    name character varying COLLATE pg_catalog."default",
    routeraddress character varying COLLATE pg_catalog."default",
    isactive boolean,
    CONSTRAINT dex_pkey PRIMARY KEY (id)
)

CREATE TABLE public.pairs
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
    exchangeid integer,
    inputtokensymbol character varying COLLATE pg_catalog."default",
    inputtokendecimals character varying COLLATE pg_catalog."default",
    inputtokenaddress character varying COLLATE pg_catalog."default",
    outputtokensymbol character varying COLLATE pg_catalog."default",
    outputtokendecimals character varying COLLATE pg_catalog."default",
    outputtokenaddress character varying COLLATE pg_catalog."default",
    pairaddress character varying COLLATE pg_catalog."default",
    CONSTRAINT pairs_pkey PRIMARY KEY (id),
    CONSTRAINT pairs_fkey FOREIGN KEY (exchangeid)
        REFERENCES public.exchanges (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
CREATE TABLE public.prices
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 10000000000000000 CACHE 1 ),
    exchangeid integer,
    pairid integer,
    price double precision,
    "timestamp" character varying COLLATE pg_catalog."default",
    CONSTRAINT prices_pkey PRIMARY KEY (id)
)
