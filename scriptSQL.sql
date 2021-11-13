
CREATE SEQUENCE dim_regiao_sk_regiao_seq;

CREATE TABLE DIM_REGIAO (
                SK_REGIAO VARCHAR NOT NULL DEFAULT nextval('dim_regiao_sk_regiao_seq'),
                NK_REGIAO VARCHAR(60) NOT NULL,
                NM_CIDADE VARCHAR(60) NOT NULL,
                NM_UF VARCHAR(60) NOT NULL,
                CONSTRAINT dim_regiao_pk PRIMARY KEY (SK_REGIAO)
);
COMMENT ON COLUMN DIM_REGIAO.SK_REGIAO IS 'Região geográfica';
COMMENT ON COLUMN DIM_REGIAO.NK_REGIAO IS 'chave natural de região, por exemplo, CEP.';
COMMENT ON COLUMN DIM_REGIAO.NM_CIDADE IS 'Nome da cidade';
COMMENT ON COLUMN DIM_REGIAO.NM_UF IS 'Nome do Estado ,abreviado';


ALTER SEQUENCE dim_regiao_sk_regiao_seq OWNED BY DIM_REGIAO.SK_REGIAO;

CREATE SEQUENCE dim_produto_sk_produto_seq;

CREATE TABLE DIM_PRODUTO (
                SK_PRODUTO INTEGER NOT NULL DEFAULT nextval('dim_produto_sk_produto_seq'),
                NK_PRODUTO VARCHAR(120) NOT NULL,
                NM_PRODUTO VARCHAR(60) NOT NULL,
                MARCA_PRODUTO VARCHAR(60) NOT NULL,
                CONSTRAINT dim_produto_pk PRIMARY KEY (SK_PRODUTO)
);
COMMENT ON COLUMN DIM_PRODUTO.SK_PRODUTO IS 'SK do produto, chave primária.
Identificador';
COMMENT ON COLUMN DIM_PRODUTO.NK_PRODUTO IS 'Chave natural, o código do produto no legado';
COMMENT ON COLUMN DIM_PRODUTO.NM_PRODUTO IS 'Nome do produto';
COMMENT ON COLUMN DIM_PRODUTO.MARCA_PRODUTO IS 'Marca dos produtos';


ALTER SEQUENCE dim_produto_sk_produto_seq OWNED BY DIM_PRODUTO.SK_PRODUTO;

CREATE SEQUENCE dim_cliente_nk_cliente_seq;

CREATE TABLE DIM_CLIENTE (
                SK_CLIENTE INTEGER NOT NULL,
                NK_CLIENTE VARCHAR(60) NOT NULL DEFAULT nextval('dim_cliente_nk_cliente_seq'),
                NM_CLIENTE VARCHAR(60) NOT NULL,
                EMAIL_CLIENTE VARCHAR(60) NOT NULL,
                CONSTRAINT dim_cliente_pk PRIMARY KEY (SK_CLIENTE)
);
COMMENT ON TABLE DIM_CLIENTE IS 'Dimensão para cadastro dos clientes';
COMMENT ON COLUMN DIM_CLIENTE.SK_CLIENTE IS 'Surrogate key é uma chave autoincremental
Não reutilizar.
Sequence.';
COMMENT ON COLUMN DIM_CLIENTE.NK_CLIENTE IS 'Natural key, exemplo, cpf, codigo do produto etc';
COMMENT ON COLUMN DIM_CLIENTE.NM_CLIENTE IS 'Nome do cliente (completo)';
COMMENT ON COLUMN DIM_CLIENTE.EMAIL_CLIENTE IS 'email do cliente (completo)';


ALTER SEQUENCE dim_cliente_nk_cliente_seq OWNED BY DIM_CLIENTE.NK_CLIENTE;

CREATE TABLE FT_VENDAS (
                VL_VENDA NUMERIC(12,4),
                QTD_VENDIDA INTEGER NOT NULL,
                SK_CLIENTE INTEGER NOT NULL,
                SK_PRODUTO INTEGER NOT NULL,
                SK_REGIAO VARCHAR NOT NULL
);
COMMENT ON TABLE FT_VENDAS IS 'Não está utilizando pk na fato';
COMMENT ON COLUMN FT_VENDAS.VL_VENDA IS 'métrica(quantidade) de vendas
Não aceita nulo.';
COMMENT ON COLUMN FT_VENDAS.SK_CLIENTE IS 'Surrogate key é uma chave autoincremental
Não reutilizar.
Sequence.';
COMMENT ON COLUMN FT_VENDAS.SK_PRODUTO IS 'SK do produto, chave primária.
Identificador';
COMMENT ON COLUMN FT_VENDAS.SK_REGIAO IS 'Região geográfica';


ALTER TABLE FT_VENDAS ADD CONSTRAINT dim_regiao_ft_vendas_fk
FOREIGN KEY (SK_REGIAO)
REFERENCES DIM_REGIAO (SK_REGIAO)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FT_VENDAS ADD CONSTRAINT dim_produto_ft_vendas_fk
FOREIGN KEY (SK_PRODUTO)
REFERENCES DIM_PRODUTO (SK_PRODUTO)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FT_VENDAS ADD CONSTRAINT dim_cliente_ft_vendas_fk
FOREIGN KEY (SK_CLIENTE)
REFERENCES DIM_CLIENTE (SK_CLIENTE)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
