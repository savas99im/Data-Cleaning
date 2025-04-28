# Data Cleaning (Remove Duplicates, Standardize the Data, Null and blank values,Remove Any Colums)

#looking my data
SELECT * 
from layoffs 
;

# make a new table because i need to keep the original as it is
create table layoffs_remove_dublicates 
like layoffs
;

insert into layoffs_remove_dublicates
select *
from layoffs
;


-- see if there is a dublicates 
WITH duplicate_cte AS (
    SELECT *, 
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_remove_dublicates
)
select *
from duplicate_cte
 WHERE row_num > 1;
-- yes

 CREATE TABLE `layoffs_remove_dublicates2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` bigint DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 

insert layoffs_remove_dublicates2
 SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_remove_dublicates;


select *
from layoffs_remove_dublicates2;

delete
from layoffs_remove_dublicates2
where row_num >1;

# stadardizing data 

select *
from layoffs_remove_dublicates2
;

update layoffs_remove_dublicates2
set company= trim(company);


select *
from layoffs_remove_dublicates2
where industry like '%Crypto%'
;

update layoffs_remove_dublicates2
set industry= 'Crypto'
where industry like '%Crypto%';

select distinct country
from layoffs_remove_dublicates2
order by 1;

update layoffs_remove_dublicates2
set country= 'United States'
where country like 'United States%';


# null value or/and blank 

delete
from layoffs_remove_dublicates2
where total_laid_off is null  and percentage_laid_off is null;

select*
from layoffs_remove_dublicates2;

update layoffs_remove_dublicates2
set industry= null
where industry ='';

select t1.industry,t2.industry
from layoffs_remove_dublicates2 as t1
join layoffs_remove_dublicates2 as t2
	on t1.company=t2.company
where t1.industry is null 
and t2.industry is not null;


update layoffs_remove_dublicates2 as t1
join layoffs_remove_dublicates2 as t2
	on t1.company=t2.company
set     t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;


select *
from layoffs_remove_dublicates2
;

-- remove colum 
 alter table layoffs_remove_dublicates2
 drop column row_num ;

select *
from layoffs_remove_dublicates2;
