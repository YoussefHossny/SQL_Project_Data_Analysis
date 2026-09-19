SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_dim.skills) AS skills_count,
    round(AVG(job_postings_fact.salary_year_avg)) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    count(skills_dim.skills)>15
ORDER BY
    avg_salary DESC,
    skills_count DESC
LIMIT 25;