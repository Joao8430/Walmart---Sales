-- ============================================================
-- PROJETO WALMART SALES - SQL
-- Arquivo 1: Criação da Tabela e Carga de Dados
-- ============================================================

-- 1. Criar o banco de dados (caso ainda não exista)
CREATE DATABASE IF NOT EXISTS walmart_db;
USE walmart_db;

-- 2. Apagar a tabela caso já exista (útil ao recriar o projeto)
DROP TABLE IF EXISTS walmart_sales;

-- 3. Criar a tabela com todas as colunas do dataset
CREATE TABLE walmart_sales (
    id            INT AUTO_INCREMENT PRIMARY KEY,  -- chave única de cada linha
    store         INT            NOT NULL,          -- número da loja (1 a 45)
    sale_date     DATE           NOT NULL,          -- data da semana
    weekly_sales  DECIMAL(15,2)  NOT NULL,          -- vendas semanais em dólares
    holiday_flag  TINYINT(1)     NOT NULL,          -- 1 = semana de feriado, 0 = semana normal
    temperature   DECIMAL(6,2),                     -- temperatura média (°F)
    fuel_price    DECIMAL(6,3),                     -- preço do combustível (USD/galão)
    cpi           DECIMAL(15,6),                    -- índice de preços ao consumidor
    unemployment  DECIMAL(6,3),                     -- taxa de desemprego (%)
    sale_year     INT,                              -- ano extraído da data
    sale_month    VARCHAR(20),                      -- nome do mês (em português)
    month_number  INT,                              -- número do mês (1-12)
    day_of_week   VARCHAR(20)                       -- dia da semana (em português)
);

-- ============================================================
-- COMO CARREGAR OS DADOS
-- ============================================================
-- Opção A: Via MySQL LOAD DATA (servidor local com o arquivo CSV)
-- LOAD DATA INFILE '/caminho/para/Walmart_Sales.csv'
-- INTO TABLE walmart_sales
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (store, @sale_date, weekly_sales, holiday_flag, temperature,
--  fuel_price, cpi, unemployment, sale_year, sale_month,
--  month_number, day_of_week)
-- SET sale_date = STR_TO_DATE(@sale_date, '%Y-%m-%d');

-- Opção B: Inserir via script Python (ver arquivo python_loader.py)
-- Opção C: Usar qualquer ferramenta de importação de CSV do seu banco
