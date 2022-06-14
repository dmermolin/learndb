import pandas as pd
df = pd.read_csv('mypath.csv')
df.columns = [c.lower() for c in df.columns] #postgres doesn't like capitals or spaces

from sqlalchemy import create_engine
engine = create_engine('postgresql://username:password@localhost:5432/dbname')

df.to_sql("ur.bases", engine)