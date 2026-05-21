-- ============================================================
-- PROJETO WALMART SALES - SQL
-- Arquivo 2: Análises e Consultas de Negócio
-- ============================================================

USE walmart_db;

-- ============================================================
-- BLOCO 1: VISÃO GERAL DOS DADOS
-- ============================================================

-- Quantas linhas existem?
SELECT COUNT(*) AS total_registros FROM walmart_sales;

-- Quais anos e quantas lojas?
SELECT 
    sale_year                   AS ano,
    COUNT(DISTINCT store)       AS qtd_lojas,
    COUNT(*)                    AS total_semanas
FROM walmart_sales
GROUP BY sale_year
ORDER BY sale_year;

-- ============================================================
-- BLOCO 2: VENDAS POR LOJA
-- ============================================================

-- Total de vendas por loja (ranking decrescente)
SELECT
    store                           AS loja,
    SUM(weekly_sales)               AS total_vendas,
    ROUND(AVG(weekly_sales), 2)     AS media_semanal,
    MAX(weekly_sales)               AS melhor_semana,
    MIN(weekly_sales)               AS pior_semana
FROM walmart_sales
GROUP BY store
ORDER BY total_vendas DESC;

-- Top 5 lojas que mais venderam
SELECT
    store                       AS loja,
    SUM(weekly_sales)           AS total_vendas
FROM walmart_sales
GROUP BY store
ORDER BY total_vendas DESC
LIMIT 5;

-- 5 lojas que menos venderam
SELECT
    store                       AS loja,
    SUM(weekly_sales)           AS total_vendas
FROM walmart_sales
GROUP BY store
ORDER BY total_vendas ASC
LIMIT 5;

-- ============================================================
-- BLOCO 3: VENDAS POR ANO E MÊS
-- ============================================================

-- Total de vendas por ano
SELECT
    sale_year                   AS ano,
    SUM(weekly_sales)           AS total_vendas,
    ROUND(AVG(weekly_sales), 2) AS media_semanal
FROM walmart_sales
GROUP BY sale_year
ORDER BY sale_year;

-- Total de vendas por mês (todos os anos juntos)
SELECT
    month_number                AS num_mes,
    sale_month                  AS mes,
    SUM(weekly_sales)           AS total_vendas,
    ROUND(AVG(weekly_sales), 2) AS media_semanal
FROM walmart_sales
GROUP BY month_number, sale_month
ORDER BY month_number;

-- Vendas por ano e mês (visão cruzada)
SELECT
    sale_year                   AS ano,
    month_number                AS num_mes,
    sale_month                  AS mes,
    SUM(weekly_sales)           AS total_vendas
FROM walmart_sales
GROUP BY sale_year, month_number, sale_month
ORDER BY sale_year, month_number;

-- ============================================================
-- BLOCO 4: FERIADOS X SEMANAS NORMAIS
-- ============================================================

-- Comparação de vendas: feriado vs. semana normal
SELECT
    CASE holiday_flag
        WHEN 1 THEN 'Semana de Feriado'
        ELSE 'Semana Normal'
    END                             AS tipo_semana,
    COUNT(*)                        AS qtd_semanas,
    SUM(weekly_sales)               AS total_vendas,
    ROUND(AVG(weekly_sales), 2)     AS media_vendas,
    MAX(weekly_sales)               AS maior_venda
FROM walmart_sales
GROUP BY holiday_flag;

-- Impacto dos feriados por loja
SELECT
    store                           AS loja,
    ROUND(AVG(CASE WHEN holiday_flag = 1 THEN weekly_sales END), 2) AS media_feriado,
    ROUND(AVG(CASE WHEN holiday_flag = 0 THEN weekly_sales END), 2) AS media_normal,
    ROUND(
        (AVG(CASE WHEN holiday_flag = 1 THEN weekly_sales END) /
         AVG(CASE WHEN holiday_flag = 0 THEN weekly_sales END) - 1) * 100
    , 2)                            AS variacao_pct
FROM walmart_sales
GROUP BY store
ORDER BY variacao_pct DESC;

-- ============================================================
-- BLOCO 5: ANÁLISE DE FATORES ECONÔMICOS
-- ============================================================

-- Média de temperatura, combustível, CPI e desemprego por ano
SELECT
    sale_year                       AS ano,
    ROUND(AVG(temperature), 2)      AS temp_media,
    ROUND(AVG(fuel_price), 3)       AS combustivel_medio,
    ROUND(AVG(cpi), 4)              AS cpi_medio,
    ROUND(AVG(unemployment), 3)     AS desemprego_medio
FROM walmart_sales
GROUP BY sale_year
ORDER BY sale_year;

-- Semanas com desemprego acima da média (mercados mais difíceis)
SELECT
    store                           AS loja,
    sale_date                       AS data,
    weekly_sales                    AS vendas,
    unemployment                    AS desemprego
FROM walmart_sales
WHERE unemployment > (SELECT AVG(unemployment) FROM walmart_sales)
ORDER BY weekly_sales DESC
LIMIT 20;

-- ============================================================
-- BLOCO 6: MELHORES E PIORES SEMANAS DE VENDA
-- ============================================================

-- Top 10 melhores semanas de vendas (qualquer loja)
SELECT
    store                   AS loja,
    sale_date               AS data,
    weekly_sales            AS vendas,
    CASE holiday_flag WHEN 1 THEN 'Feriado' ELSE 'Normal' END AS tipo
FROM walmart_sales
ORDER BY weekly_sales DESC
LIMIT 10;

-- Top 10 piores semanas
SELECT
    store                   AS loja,
    sale_date               AS data,
    weekly_sales            AS vendas,
    CASE holiday_flag WHEN 1 THEN 'Feriado' ELSE 'Normal' END AS tipo
FROM walmart_sales
ORDER BY weekly_sales ASC
LIMIT 10;

-- ============================================================
-- BLOCO 7: INDICADORES KPI (para usar no GitHub README)
-- ============================================================

-- Resumo executivo em uma só consulta
SELECT
    COUNT(DISTINCT store)                   AS total_lojas,
    COUNT(*)                                AS total_semanas_analisadas,
    MIN(sale_date)                          AS data_inicio,
    MAX(sale_date)                          AS data_fim,
    SUM(weekly_sales)                       AS receita_total,
    ROUND(AVG(weekly_sales), 2)             AS media_semanal_geral,
    MAX(weekly_sales)                       AS maior_semana,
    MIN(weekly_sales)                       AS menor_semana,
    SUM(CASE WHEN holiday_flag = 1 THEN 1 ELSE 0 END) AS semanas_feriado
FROM walmart_sales;
