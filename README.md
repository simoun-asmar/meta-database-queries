## Meta Database Connection

This repository contains SQL queries for cleaning and analyzing the Meta Database. Connect to the PostgreSQL database using the following URL:

postgresql://Student2:cQDO8rxaN4sG@ep-noisy-flower-846766.us-east-2.aws.neon.tech/Meta?sslmode=require


## Files

- **meta_data_cleaning_queries.sql**: 
This analysis focuses on data cleaning by standardizing sector names and countries. After cleaning, key metrics like average revenue by sector, marketing spend by country, and customer penetration are analyzed. It also reviews data freshness for long-term clients and tracks year-over-year customer penetration for key clients.
- **meta_analysis_queries.sql**: The analysis addresses financial performance, customer data quality, and employee engagement. It helps management compare customer segments, monitor sales team performance, and ensure client information is up to date.

## Running the Queries

Once connected to the Meta Database, you can run the queries provided in these files.
