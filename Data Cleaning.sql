-- DATA CLEANING

SET SQL_SAFE_UPDATES = 0;

SELECT * 
FROM world_layoffs.layoffs;

-- STEPS IN DATA CLEANING
-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Deal with null values or blank values
-- 4. Remove any unnecessary columns


-- Create a staging table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 1. Remove Duplicates
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;

SELECT *
FROM layoffs_staging
WHERE company='Casper';

-- Create another table to remove duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;

-- Delete duplicates
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2;

-- 2. Standardize the Data
SELECT company, (trim(company)) 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT industry, (trim(industry)) 
FROM layoffs_staging2;

-- Check industry column
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
-- Cryto industry has 3 different values

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Check location column
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Check country column
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

-- United States has two values in country column. The incorrect values is updated by trimming the '.'

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Check date column 
SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change date column to date type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Deal with Null Values or Blank Values
-- Check NULL values in industry column
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Select rows where industry is NULL
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Update industry to NULL where it is blank
UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';

-- Check industry where company is Airbnb
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Select rows where industry from table 1 is NULL and industry from table 2 is not NULL
-- The values of industry from table 2 will be used to update rows where industry is NULL.
SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Update rows where industry is NULL 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Rows where total_laid_off and percentage_laid_off are NULL. 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- These rows are deleted.
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- NULL values in total_laid_off, percentage_laid_off and funds_raised_millions are ignored as they cannot be imputed due to lack of additional data.

-- 4. Remove any unnecessary columns
-- Drop column row_num
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
