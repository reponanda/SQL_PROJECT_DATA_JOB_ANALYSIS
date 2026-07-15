/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

-- If i to get the remote jobs than indonesia is not the option
-- cuse there is no remote job for data analyst in indonesia
WITH job_posted AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'Indonesia' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    job_posted.*,
    skills
FROM job_posted
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_posted.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id

WITH job_posted AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    job_country = 'Indonesia' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    job_posted.*,
    skills
FROM job_posted
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_posted.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 