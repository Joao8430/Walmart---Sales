# 🛒 Walmart Sales Analysis — SQL + Excel + Power BI

Projeto de análise de dados de vendas do Walmart cobrindo **45 lojas** entre **fevereiro de 2010** e **outubro de 2012** — com **6.435 registros semanais**.

O projeto foi desenvolvido em três camadas:

| Camada | Ferramenta | O que faz |
|---|---|---|
| 📊 Dados | Excel | Tratamento, colunas calculadas (Ano, Mês, Dia da semana) |
| 📈 Visualização | Power BI | Dashboard executivo interativo |
| 🗄️ Banco de Dados | SQL | Criação de tabela, carga e análises de negócio |

---

## 📁 Estrutura do Repositório

```
walmart-sales/
│
├── Walmart_Sales.csv          ← Dataset original (45 lojas, 2010-2012)
├── Dados_executivos_Walmart.pbix  ← Dashboard Power BI
│
├── sql/
│   ├── 01_create_and_load.sql ← Cria a tabela no banco
│   ├── 02_analysis_queries.sql← Todas as consultas de análise
│   └── python_loader.py       ← Script para popular o banco automaticamente
│
└── README.md
```

---

## 📊 Dataset — Colunas

| Coluna | Tipo | Descrição |
|---|---|---|
| `store` | INT | Número da loja (1 a 45) |
| `sale_date` | DATE | Data de início da semana |
| `weekly_sales` | DECIMAL | Vendas brutas da semana (USD) |
| `holiday_flag` | BOOL | 1 = semana de feriado, 0 = semana normal |
| `temperature` | DECIMAL | Temperatura média (°F) |
| `fuel_price` | DECIMAL | Preço do galão de combustível (USD) |
| `cpi` | DECIMAL | Índice de Preços ao Consumidor |
| `unemployment` | DECIMAL | Taxa de desemprego (%) |
| `sale_year` | INT | Ano (2010, 2011, 2012) |
| `sale_month` | VARCHAR | Nome do mês em português |
| `month_number` | INT | Número do mês (1-12) |
| `day_of_week` | VARCHAR | Dia da semana em português |

---

## 🗄️ SQL — Como Usar

### Opção 1: SQLite (mais rápida, sem instalação)

```bash
pip install pandas sqlalchemy openpyxl
python sql/python_loader.py
```

O script cria o arquivo `walmart_sales.db` e você pode consultar com qualquer ferramenta SQLite (DB Browser, DBeaver, etc.).

### Opção 2: MySQL

1. Crie o banco: `CREATE DATABASE walmart_db;`
2. Execute o arquivo `sql/01_create_and_load.sql`
3. Importe os dados (via LOAD DATA ou pelo script Python)
4. Rode as análises em `sql/02_analysis_queries.sql`

---

## 🔍 Análises SQL Incluídas

- ✅ Vendas totais e médias por loja
- ✅ Ranking das top 5 lojas e das 5 piores
- ✅ Vendas por ano e por mês
- ✅ Comparação: semanas de feriado vs. semanas normais
- ✅ Impacto dos feriados em cada loja
- ✅ Correlação com fatores econômicos (CPI, desemprego, combustível)
- ✅ Melhores e piores semanas de venda
- ✅ KPIs executivos em uma única consulta

---

## 📈 KPIs Principais

| Indicador | Valor |
|---|---|
| Total de lojas | 45 |
| Período analisado | Fev/2010 – Out/2012 |
| Total de registros | 6.435 semanas |
| Semanas de feriado | 450 |
| Maior venda semanal | $381.868.645 |
| Menor venda semanal | $279.677 |

---

## 🛠️ Tecnologias

![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoftexcel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

---

> Projeto desenvolvido para portfólio de análise de dados.
