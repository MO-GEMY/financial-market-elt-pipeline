import os
import glob
import pandas as pd
from sqlalchemy import create_engine, text, inspect

# 1. إعداد الاتصال بقاعدة بيانات PostgreSQL
DB_URI = "postgresql+psycopg2://de_user:de_password@localhost:5432/market_db"
engine = create_engine(DB_URI)

# 2. قراءة كل ملفات الـ Parquet من طبقة الـ Bronze
files = glob.glob(os.path.join("data_lake", "bronze", "*.parquet"))

if not files:
    raise FileNotFoundError("No parquet files found in data_lake/bronze. Run extract_to_bronze.py first.")

combined_df = []
for file in files:
    df = pd.read_parquet(file)
    combined_df.append(df)

final_df = pd.concat(combined_df, ignore_index=True)

# 3. توحيد أسماء الأعمدة لتلائم معايير SQL
final_df.columns = [c.lower().replace(" ", "_") for c in final_df.columns]

# 4. إدراج البيانات (تفريغ الجدول دون حذفه للحفاظ على الـ Views)
TABLE_NAME = "raw_market_prices"

inspector = inspect(engine)
if inspector.has_table(TABLE_NAME):
    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE {TABLE_NAME};"))
    final_df.to_sql(TABLE_NAME, engine, if_exists="append", index=False)
else:
    final_df.to_sql(TABLE_NAME, engine, if_exists="replace", index=False)

print(f"Successfully loaded {len(final_df)} rows into table '{TABLE_NAME}' in PostgreSQL.")