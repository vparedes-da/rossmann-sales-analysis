## Power BI Dashboard – Rossmann Sales Analysis

This Power BI dashboard was built to analyze the key drivers of sales performance across time, regions, store types and promotional activity.

The dashboard directly supports the business question:

What factors drive sales in Rossmann stores, and how can we optimize commercial performance at the regional and temporal level?

# Data Model

Brief description:

- train_features_enriched as fact table

- store and store_state as dimension tables

Relationships:

One-to-many (store → sales (train_features_enriched table))

One-to-many (store_state → stores)

## Key DAX Measures

- Total Sales: Sum of daily sales across all stores

- Average Daily Sales: Average sales per day, used to compare seasons and promotions


- Seasonal Average Sales: Used to identify seasonal demand patterns



# Dashboard Pages & Visuals
Page 1 – Temporal & Regional Performance

- Sales trend over time (Year–Month)

- Sales by State

Global filters: Year, State

Purpose
Identify long-term trends and regional disparities in sales performance.

Page 2 – Seasonality, Store Type & Promotions

- Average sales by store type and season

- Seasonal sales comparison

- Impact of promotions on sales

- Seasonal behavior during active promotions

Purpose
Understand how seasonality and promotions interact with store characteristics.

Page 3 - Key Insights and Business Implications

# Key Insights

Short bullets:

- Clear seasonality patterns across years

- Promotions significantly increase average daily sales

- Store types respond differently to seasonal demand

- Certain states consistently outperform others

# Files

- rossmann_sales_dashboard.pbix → Interactive Power BI file

- page_1_dashboard.png → Static preview of the dashboard
  
- page_2_dashboard.png → Static preview of the dashboard

- insights_diagnosis.pns → Key Insights and Business Implications
- 
