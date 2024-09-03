# MySQL-Data-Cleaning-EDA-Project
Data Cleaning and Exploratory Data Analysis of Layoffs Data in MySQL


## Problem Statement
To perform a comprehensive data cleaning and exploratory data analysis (EDA) on a dataset containing data on layoffs across various companies 


## Data 

#### Data Dictionary
Feature | Description |
--- | --- |
company | Name of the company                    
location | City where the company's operational headquarters is located                 
industry | Industry in which the company operates              
total_laid_off | Count of employess laid off        
percentage_laid_off | Percentage of employees laid off          
date | Date when layoffs were announced     
stage | Funding stage of the company         
funds_raised_millions | Funds (in millions) raised by the company


## Data Cleaning

#### Steps in Data Cleaning
1. Remove duplicates
2. Standardize the data
3. Deal with null values or blank values
4. Remove any unnecessary columns


## Exploratory Data Analysis

The following SQL queries were executed to analyze the layoffs data:
1. **Maximum Values Analysis**
Selected the maximum values of 'total_laid_off' and 'percentage_laid_off' to identify the companies with the highest layoffs.
2. **Complete Layoff Analysis**
Selected rows where companies laid off all their staff to understand the impact on different organizations.
3. **Fund-Raised and Layoff Analysis**
Selected rows where companies laid off all staff, ordered by funds_raised_millions in descending order to observe the correlation between funds raised and layoffs.
4. **Company-Wise Layoff Sum**
Calculated the sum of 'total_laid_off' for each company to get a company-wise distribution of layoffs.
5. **Date Range Analysis**
Retrieved the minimum and maximum values of date to understand the time range covered in the dataset.
6. **Industry-Wise Layoff Sum**
Calculated the sum of 'total_laid_off' for each industry to see the layoffs distribution across different industries.
7. **Country-Wise Layoff Sum**
Calculated the sum of 'total_laid_off' for each country to analyze the impact on different regions.
8. **Yearly Layoff Analysis**
Calculated the sum of 'total_laid_off' by each year to observe annual trends in layoffs.
9. **Company Stage Analysis**
Calculated the sum of 'total_laid_off' for companies at each stage (e.g., startup, growth, mature) to see how layoffs vary with company maturity.
10. **Monthly and Yearly Layoff Trends**
Calculated the sum of 'total_laid_off' by both month and year to identify seasonal or yearly patterns in layoffs.


