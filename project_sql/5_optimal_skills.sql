/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

WITH demanded_skills AS (
Select
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
WHERE
    job_country = 'Indonesia' AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skill_id
), 

paying_skills AS (
SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_country = 'Indonesia' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_job_dim.skill_id
)

SELECT 
    demanded_skills.skill_id,
    demanded_skills.skills,
    demanded_skills.demand_count,
    paying_skills.average_salary
FROM demanded_skills
INNER JOIN paying_skills ON paying_skills.skill_id = demanded_skills.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary DESC
LIMIT 25