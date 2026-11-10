import sys
import time
import logging
import subprocess

# إعداد الـ Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

def run_step(step_name, command):
    logging.info(f"--- Starting: {step_name} ---")
    start_time = time.time()
    
    result = subprocess.run(command, shell=True)
    
    if result.returncode != 0:
        logging.error(f"Failed at: {step_name} (Exit code: {result.returncode})")
        sys.exit(result.returncode)
        
    elapsed = round(time.time() - start_time, 2)
    logging.info(f"Finished: {step_name} in {elapsed}s\n")

def main():
    pipeline_start = time.time()
    logging.info("Starting Market Data ELT Pipeline Execution...")

    # 1. سحب البيانات الخام (Bronze)
    run_step("Bronze Ingestion (yfinance to Parquet)", "python extract_to_bronze.py")

    # 2. تحميل البيانات المنظفة (Silver)
    run_step("Silver Staging (Parquet to PostgreSQL)", "python load_to_silver.py")

    # 3. نمذجة البيانات (Gold Star Schema)
    run_step("Gold Dimensional Transformation (dbt run)", "dbt run --profiles-dir .")

    # 4. فحص جودة البيانات (Data Testing)
    run_step("Data Quality & Integrity Tests (dbt test)", "dbt test --profiles-dir .")

    total_time = round(time.time() - pipeline_start, 2)
    logging.info(f"==================================================")
    logging.info(f"ELT Pipeline completed successfully in {total_time}s!")
    logging.info(f"==================================================")

if __name__ == "__main__":
    main()