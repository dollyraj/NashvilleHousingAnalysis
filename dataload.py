import pandas as pd
from sqlalchemy import create_engine

# 1. Read CSV
df = pd.read_csv(r'C:/Users/rajdo\Downloads/nashville_housing_data.csv')

# Remove trailing whitespace in column names if any
df.columns = df.columns.str.strip()

# 2. Connect to MySQL (adjust user, password, host, port, db_name)
engine = create_engine('mysql+mysqlconnector://root:dolly123@localhost:3306/nashville_housing_db')

# 3. Load directly into table
df.to_sql('nashville_housing', con=engine, if_exists='append', index=False, chunksize=5000)
print("Import complete!")