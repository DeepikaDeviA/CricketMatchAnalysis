Cricsheet Match Data Analysis
Overview:
This project focuses on scraping, processing, analyzing, and visualizing cricket match data from Cricsheet. The analysis covers multiple formats — ODI, T20, Test, and IPL — and produces insights through SQL queries, Python EDA, and interactive Power BI dashboards.

Skills & Tools Used:
Web Scraping – Selenium
Data Processing – Python (Pandas, JSON)
Database Management – TiDB Cloud
Data Analysis – SQL Queries
Visualization – Power BI, Matplotlib, Seaborn, Plotly
Automation – Selenium scripts for batch downloads

Dataset:
Source: Cricsheet Match Data
Format: JSON files (one per match)
Content Includes:
Match metadata (teams, venue, date, toss result)
Innings data (runs, wickets, overs, deliveries)
Player details (batting & bowling performance)

Problem Statement:
The goal is to automate the extraction of cricket match data, clean and transform it into SQL database tables, perform analytical queries, and visualize insights for better decision-making in sports analytics.

Approach:
1. Data Collection (Selenium)
Automated navigation to Cricsheet match pages.

Downloaded JSON files for ODI, T20, Test, and IPL matches.

2. Data Transformation (Python)
Parsed JSON using Pandas.

Flattened nested structures into DataFrames.

Created separate CSVs for each match type (match summary, ball-by-ball, player registry).

3. Database Management (SQL)
Created MySQL/TiDB tables for each format.

Uploaded data in batches of 500 records.

4. Data Analysis (SQL)
Wrote 20+ queries for insights such as:

Top batsmen by runs

Leading wicket-takers

Teams with best win percentages

Matches with narrowest margin of victory

5. EDA (Python)
Created 10+ visualizations using Matplotlib, Seaborn, and Plotly.

6. Power BI Dashboard
Built interactive dashboards showing:

Batting Performance
Bowling Performance
Team wise Performance


Key Results:
Automated scraping pipeline for cricket match data.

Cleaned and structured SQL database for all match formats.

Insightful SQL queries revealing player & team performance metrics.

Interactive Power BI dashboard for data exploration.

Contact
Author: Deepika Devi
Email: deepikaarunachalam20@gmail.com