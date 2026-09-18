SELECT job_title_short AS Title,
        job_location AS Location,
        job_posted_date AT time zone 'UTC' AT time zone'EST' AS Date,
        EXTRACT(day From job_posted_date) As Day
from 
    job_postings_fact

Limit 5;

Select 
    count(Job_id) as count_job_posted,
    extract(month from job_posted_date) as month

from job_postings_fact

where job_title_short ='Data Analyst'

group by month

order by count_job_posted desc;

select * FROM job_postings_fact
LIMIT 10;

Create table january_job_postings as
SELECT *
    from job_postings_fact
    where extract(month from job_posted_date) = 1;

select * from january_job_postings
limit 10;

select 
    count(job_id) as count_job_category,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        when job_location like 'New York, NY' then 'local'
        ELSE 'On-site'
    END As location_category
from job_postings_fact

    where job_title_short = 'Data Analyst'

GROUP BY location_category

order by count_job_category desc;


Create table january_job_postings as
SELECT *
    from job_postings_fact
    where extract(month from job_posted_date) = 1;

Create table february_job_postings as
SELECT *
    from job_postings_fact
    where extract(month from job_posted_date) = 2;

Create table march_job_postings as
SELECT *
    from job_postings_fact
    where extract(month from job_posted_date) = 3;

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE extract(month from job_posted_date) = 1
) AS january_job_postings;

SELECT  company_id,
        name AS company_name

from company_dim

where company_id in (

    Select 
            company_id
    from 
            job_postings_fact
    where 
            job_no_degree_mention = true
    order by 
            company_id
)



WIth company_jobs AS (
    select 
        company_id,
        count(*) AS Total_jobs

from 
        job_postings_fact
group by 
        company_id
)

Select 
    company_dim.name AS company_name,
    company_jobs.Total_jobs
from 
    company_dim 
left join company_jobs on company_dim.company_id = company_jobs.company_id

order by 
    company_jobs.Total_jobs desc






with remote_job_skills AS (
Select
    skill_id,
    Count(*) AS skill_count
From
    skills_job_dim AS skills_job
inner join job_postings_fact on job_postings_fact.job_id = skills_job.job_id
where 
    job_postings_fact.job_work_from_home = true and
    job_postings_fact.job_title_short = 'Data Analyst'
group by 
    skill_id
)

select 
    skills_dim.skill_id,
    skills_dim AS skill_name,
    skill_count
from 
    remote_job_skills
inner join skills_dim on skills_dim.skill_id = remote_job_skills.skill_id
 
 ORDER BY skill_count DESC
 limit 5;


SELECT
    job_title_short,
    company_id,
    job_location,
    job_posted_date
From
    january_job_postings

UNION ALL

Select
    job_title_short,
    company_id,
    job_location,
    job_posted_date
FROM 
    february_job_postings

UNION ALL

Select
    job_title_short,
    company_id,
    job_location,
    job_posted_date
FROM
    march_job_postings


Select 
    job_title_short,
    company_id,
    job_location,
    job_posted_date::DATE,
    salary_year_avg
From(
    Select *
    From
        january_job_postings
    Union All
    Select *
    from
        february_job_postings
    Union All
    Select *
    from
        march_job_postings
) AS quarterly_job_postings
where 
    salary_year_avg > 80000 AND 
    job_title_short = 'Data Analyst'
order by 
    salary_year_avg desc