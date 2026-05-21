"""
PROJETO WALMART SALES
Script Python para carregar os dados no banco MySQL/SQLite

Uso:
    pip install pandas sqlalchemy openpyxl
    python python_loader.py
"""

import pandas as pd
from sqlalchemy import create_engine, text

# ============================================================
# CONFIGURAÇÃO DO BANCO
# ============================================================

# Escolha uma das opções abaixo:

# OPÇÃO 1: SQLite (mais fácil, não precisa instalar nada extra)
# Cria um arquivo .db local — ótimo para testes e portfólio no GitHub
engine = create_engine("sqlite:///walmart_sales.db", echo=False)

# OPÇÃO 2: MySQL (descomente se tiver MySQL instalado)
# engine = create_engine("mysql+pymysql://usuario:senha@localhost/walmart_db")

# OPÇÃO 3: PostgreSQL
# engine = create_engine("postgresql://usuario:senha@localhost/walmart_db")


# ============================================================
# LEITURA E LIMPEZA DOS DADOS
# ============================================================

print("Lendo o arquivo de dados...")
df = pd.read_excel("Walmart_Sales.csv")   # o arquivo é Excel mesmo

# Renomear colunas para remover espaços extras
df.columns = [col.strip() for col in df.columns]

# Mapeamento para nomes padronizados em inglês (boas práticas SQL)
df = df.rename(columns={
    "Store":           "store",
    "Date":            "sale_date",
    "Weekly_Sales":    "weekly_sales",
    "Holiday_Flag":    "holiday_flag",
    "Temperature":     "temperature",
    "Fuel_Price":      "fuel_price",
    "CPI":             "cpi",
    "Unemploiment":    "unemployment",   # corrige o typo do dataset original
    "ANO":             "sale_year",
    "MÊS":             "sale_month",
    "Número do mês":   "month_number",
    "Dias da semana":  "day_of_week",
})

# Garantir que a data esteja no formato correto
df["sale_date"] = pd.to_datetime(df["sale_date"])

print(f"Dados carregados: {len(df)} linhas, {len(df.columns)} colunas")
print(df.head())


# ============================================================
# CARGA NO BANCO DE DADOS
# ============================================================

print("\nCarregando no banco de dados...")
df.to_sql(
    name="walmart_sales",       # nome da tabela
    con=engine,
    if_exists="replace",        # recria a tabela se já existir
    index=True,                 # índice vira coluna "id"
    index_label="id",
)

print("✅ Dados carregados com sucesso!")


# ============================================================
# TESTE: RODAR UMA CONSULTA SQL
# ============================================================

print("\n--- TESTE: Top 5 lojas por vendas totais ---")
with engine.connect() as conn:
    result = conn.execute(text("""
        SELECT
            store                       AS loja,
            SUM(weekly_sales)           AS total_vendas,
            ROUND(AVG(weekly_sales), 2) AS media_semanal
        FROM walmart_sales
        GROUP BY store
        ORDER BY total_vendas DESC
        LIMIT 5
    """))
    for row in result:
        print(f"  Loja {row[0]:>2} | Total: ${row[1]:>15,.0f} | Média: ${row[2]:>12,.2f}")

print("\n--- TESTE: Feriado vs. Semana Normal ---")
with engine.connect() as conn:
    result = conn.execute(text("""
        SELECT
            CASE holiday_flag
                WHEN 1 THEN 'Semana de Feriado'
                ELSE 'Semana Normal'
            END                             AS tipo_semana,
            COUNT(*)                        AS qtd_semanas,
            ROUND(AVG(weekly_sales), 2)     AS media_vendas
        FROM walmart_sales
        GROUP BY holiday_flag
    """))
    for row in result:
        print(f"  {row[0]:<22} | Semanas: {row[1]:>4} | Média: ${row[2]:>12,.2f}")

print("\n✅ Tudo funcionando! Banco pronto para uso.")
