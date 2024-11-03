#Data Cleaning
select * from layoffs;

#1.Remove duplicates
#2.Standardizing the data
#3.Null values or blank values
#4.Remove irrelevant columns

Create table layoffs_staging
like layoffs;
select * from layoffs_staging;
insert layoffs_staging
select * 
from layoffs;
select * ,
row_number() OVER( partition by company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions)as row_num
from layoffs_staging;
with duplicate_cte as
(
select * ,
row_number() OVER( partition by company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions)as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num>1;
select*
from layoffs_staging
where company='casper';

with duplicate_cte as
(
select * ,
row_number() OVER( partition by company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions)as row_num
from layoffs_staging
)
delete 
from duplicate_cte
where row_num>1;

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
select*
from layoffs_staging2
where row_num>1;
insert into layoffs_staging2
select * ,
row_number() OVER( partition by company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions)as row_num
from layoffs_staging;
set sql_safe_updates=0;
delete
from layoffs_staging2
where row_num>1;
set sql_safe_updates=0;

select*
from layoffs_staging2;

#Standardizing the data
select company,TRIM(company)
from layoffs_staging2; 

update layoffs_staging2
set company=trim(company);

select *
from layoffs_staging2
where industry LIKE'CRYPTO%';

UPDATE layoffs_staging2
set industry='crypto'
where industry LIKE'CRYPTO%';
select *
from layoffs_staging2
where industry LIKE'CRYPTO%';

select distinct country
from layoffs_staging2
 order by 1;
 
 select distinct country,trim(trailing '.' from country)
 from layoffs_staging2
 order by 1;
 
update layoffs_staging2
set country=trim(trailing '.' from country)
where country like 'united states%';

select distinct country
from layoffs_staging2
order by 1;

select date,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set date=str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry='null'
where industry='';

select *
from layoffs_staging2
where industry is null
or industry='';
 
select *
from layoffs_staging2
where company='airbnb';
#Data Cleaning
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company=t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

update layoffs_staging2
set industry='Travel'
where industry='null'
and company='airbnb';

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

#Deleting data
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


alter table layoffs_staging2
drop column row_num;
select *
from layoffs_staging2;