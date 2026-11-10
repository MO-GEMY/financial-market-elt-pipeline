import os
import yfinance as yf
import pandas as pd

# 1. قائمة الأصول المالية المستهدفة
TICKERS = ["BTC-USD", "ETH-USD", "SPY", "GLD"]

# 2. تحديد مجلد بحيرة البيانات (Bronze Layer)
DATA_LAKE_DIR = os.path.join("data_lake", "bronze")
os.makedirs(DATA_LAKE_DIR, exist_ok=True)

print("Starting data extraction...")

for ticker in TICKERS:
    # سحب بيانات آخر 30 يوماً
    data = yf.download(ticker, period="30d", interval="1d")
    
    if data.empty:
        print(f"Warning: No data found for {ticker}")
        continue

    # تسطيح الأعمدة وإضافة رمز الأصل
    data.reset_index(inplace=True)
    if isinstance(data.columns, pd.MultiIndex):
        data.columns = [col[0] for col in data.columns]
    data["Ticker"] = ticker

    # حفظ البيانات كملف Parquet
    clean_ticker = ticker.replace("-", "_")
    file_path = os.path.join(DATA_LAKE_DIR, f"{clean_ticker}_prices.parquet")
    data.to_parquet(file_path, index=False)
    
    print(f"Saved: {file_path} ({len(data)} records)")

print("Bronze ingestion completed successfully.")