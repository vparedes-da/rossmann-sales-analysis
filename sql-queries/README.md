# DATA CLEANING

This folder contains all SQL scripts used in the project.

01_tables_cleaning.sql: Initial data cleaning and validation
02_store_states.sql: To perform a more specific and regional analysis, a new table was created in which each store (in the original file stores are identified by numbers) is assigned to the German state where the Rossmann store is located.
03_train_features_table.sql: Creation of new features (temporal and business features).
04_lag_rolling_table.sql: Calculation of LAG variables for “Sales” and “Customers” for future analysis.
05_rolling_means_table.sql: Calculation of rolling means for “Sales” and “Customers” for future analysis.

