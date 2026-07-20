
# SQL Project for Data Job Analysis

## Introduction

This project focuses on **Data Analyst** roles in **Indonesia**. It explores the highest-paying positions, the most in-demand skills, and the intersection between high demand and high salaries in the data analytics job market.

For the queries, please check out them here: [project_sql folder](/project_sql/)

## Background

This project was inspired by **@lukebarousse** work and tutorials. Thank you for the guidance and educational resources that made this project possible.

Driven by a quest to navigate the data analyst job market in Indonesia more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

**The questions I wanted to answer through my SQL queries were:**

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

## Tools I used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

## The Analysis

Each query in this project aimed to investigate specific aspects of the data analyst job market. I attempted to filter for remote data analyst jobs in Indonesia, but no remote listings were found.

![No Data for Remote Data Analyst Jobs in Indonesia](Assets/01_NoData.png)

So, I just focusing on the location which is in Indonesia. Here’s how I approached each question:

### 1. Top Paying Data Analysis Jobs

To pinpoint the top-paying roles, I filtered data analyst positions by average annual salary and location, focusing specifically on Indonesia. This query surfaces the most lucrative opportunities within the field

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'Indonesia' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Based on the query above, I obtained the following results. However, as shown below, when I removed the filter for `job_location = 'Anywhere'`, data was shown some result.

|Job Title|Company|Location|Schedule Type|Avg Salary (USD)|Posted Date|
|---|---|---|---|---|---|
|Marketing Data Analytics Manager|GoTo Group|Jakarta, Indonesia|Full-time|$132,500|2023-08-03|
|Data Analyst - Merchant Success|BukuWarung|Jakarta, Indonesia|Full-time|$111,175|2023-02-03|
|Data Analyst - Consumer Lending|GoTo Group|Jakarta, Indonesia|Full-time|$105,000|2023-08-30|
|Customer Loyalty SLA Control Tower & Data Analyst|Ninja Van|Jakarta, Indonesia|Contractor|$105,000|2023-08-14|
|(Operation) Data Analyst Manual Activity|Ninja Van|Yogyakarta, Yogyakarta City, Special Region of Yogyakarta, Indonesia|Full-time|$102,500|2023-04-05|
|Data Analyst|Stockbit|Jakarta, Indonesia|Full-time|$100,500|2023-06-08|
|Data Analyst - Junior|Samsung Electronics|Indonesia|Full-time|$77,017.5|2023-12-15|
|Data Analyst|Trusting Social|Jakarta, Indonesia|Full-time|$75,067.5|2023-12-22|
|Audit Data Analytics & System Development|Amartha|South Jakarta, South Jakarta City, Jakarta, Indonesia|Full-time|$64,800|2023-05-10|
|Data Analyst|Gravel|Jakarta, Indonesia|Full-time|$57,500|2023-08-26|

However, here's a breakdown of the top highest-paying Data Analyst roles in Indonesia for 2023:

- **Salary Range & Distribution**: Salaries span from $57,500 to $132,500 — more than a 2x spread across just 10 roles and the average across all 10 listings is about $93,100.
- **Company Patterns**: Fintech/lending and tech-platform companies (GoTo, BukuWarung, Trusting Social) dominate the upper-to-mid range, consistent with Jakarta's strong fintech scene.
- **Location Concentration**: 8 of 10 roles are based in Jakarta, confirming it as the overwhelming hub for data analyst hiring in Indonesia.

![Top Paying Data Analyst Jobs in Indonesia](Assets\02_indonesia_data_analyst_salaries.png)
*bar chart above visualizing the salary for the top 10 salaries for data analysts in Indonesia; Claude generated this chart from my query results.*

### 2. Skills for Top Paying Jobs

To understand the skills required for top-paying jobs, I joined the job postings data with the skills dataset, revealing what employers value most in high-compensation roles.

```sql
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
```

However, here's a breakdown of the most skills are required for these top-paying jobs in Indonesia for 2023:

#### Table of the required skills for the top 10 data analyst

|Skill|# of Jobs Requiring It|% of All 10 Jobs|
|---|---|---|
|SQL|8|80%|
|Python|6|60%|
|Excel|6|60%|
|Tableau|3|30%|
|R|2|20%|
|JavaScript|1|10%|
|Power BI|1|10%|
|Looker|1|10%|
|AWS|1|10%|
|Hadoop|1|10%|
|SQL Server|1|10%|
|Word|1|10%|
|PowerPoint|1|10%|
|BigQuery|1|10%|

- **SQL is non-negotiable** — it's required in 8 out of 10 top-paying roles (80%), making it the single most important skill for landing a high-paying data analyst job in Indonesia.
- **Python and Excel are tied as the second most valuable skill** — both appear in 6 of 10 roles (60%). This suggests employers want a mix of technical scripting ability (Python) and practical spreadsheet fluency (Excel), rather than one replacing the other.
- **The highest-paying job demands the broadest toolkit**. The #1 role — Marketing Data Analytics Manager at GoTo Group ($132,500) — requires 6 different skills (SQL, Python, JavaScript, Excel, Tableau, Power BI), the most of any job in the list.

### 3. In-Demand Skills for Data Analyst

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
Select
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
WHERE
    job_country = 'Indonesia' AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

Here's the breakdown of the most demanded skills for data analysts in Indonesia for 2023:

- **SQL dominates the market** — it's mentioned in 226 job postings, nearly 1.5x more than the next closest skill (Python). This confirms SQL as the foundational, must-have skill for any data analyst role in Indonesia.
- **The top 3 skills (SQL, Python, Excel) account for 73% of total demand** — meaning if a candidate masters just these three, they'd cover the vast majority of what employers are asking for, before even touching visualization tools like Tableau or R.

![Top In-Demand Skills](Assets\03_indonesia_top_skills_2023.png)
*Bar chart visualizing the the most 5 demanded skills for data analyst jobs in Indonesia for 2023; Claude generated this graph from my SQL query results.*

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_country = 'Indonesia' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25
```

Here's a breakdown of the results for top paying skills for Data Analysts:

- **JavaScript and Power BI tie for the top spot ($132,500 each)** — this is a striking finding because JavaScript isn't a typical "core" data analyst skill.
- **Interesting inversion: demand vs. pay**. SQL was the #1 most demanded skill (226 postings) but ranks only 6th in average pay ($91,784). This is a classic labor-market pattern.
- **Programming languages (Python, R) rank lower than BI tools** — reinforcing that in this specific market, presentation and dashboarding skills are currently valued more highly than statistical/programming depth alone.

Table of the average salary for the top 10 paying skills for data analysts

|Skill|Average Salary (USD)|
|---|---|
|JavaScript|$132,500.00|
|Power BI|$132,500.00|
|Tableau|$112,666.67|
|Looker|$105,000.00|
|Excel|$92,814.17|
|SQL|$91,784.44|
|Python|$83,270.00|
|R|$81,247.50|
|AWS|$77,017.50|
|Hadoop|$75,067.50|

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```

Here's a breakdown of the most optimal skills for Data Analysts in Indonesia for 2023:

- **Tableau holds the 3rd-highest salary ($112,666.67) and has the strongest demand among the top 4 highest-paid skills (114 postings)**. This makes Tableau the most "trustworthy" high earner in the list — its salary premium is backed by real, widespread hiring activity, not a handful of outlier roles.
- **There's a clear tier break after Looker**. The jump from Looker ($105,000) to Excel ($92,814.17) is roughly a $12K drop, marking a visible line between "premium BI/visualization tools" (JavaScript, Power BI, Tableau, Looker) and "core/foundational skills" (Excel, SQL, Python, R) that follow.

Table of the optimal skills for data analyst

|Skill|Average Salary (USD)|Demand Count|
|---|---|---|
|JavaScript|$132,500.00|11|
|Power BI|$132,500.00|65|
|Tableau|$112,666.67|114|
|Looker|$105,000.00|19|
|Excel|$92,814.17|141|
|SQL|$91,784.44|226|
|Python|$83,270.00|148|
|R|$81,247.50|77|
|AWS|$77,017.50|16|
|PowerPoint|$64,800.00|11|
|SQL Server|$64,800.00|15|
|Word|$64,800.00|17|
|BigQuery|$55,133.33|31|

## What I learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **Complex Query Crafting**: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **Data Aggregation**: Got cozy with GROUP BY and turned aggregate functions like `COUNT()` and `AVG()` into my data-summarizing sidekicks.
- **Analytical Wizardry**: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

## Conlusions

**Insight**. From the analysis, several general insights emerged:

1. **The top-paying data analyst jobs**: Jobs based in Jakarta at fintech/tech platforms — led by Marketing Data Analytics Manager at GoTo Group ($132,500), followed by roles at BukuWarung, GoTo Group, and Ninja Van (all $100K–$111K).
2. **Skills for Top-Paying Jobs**: SQL, Python, and Excel form the core foundation across nearly all top roles.
3. **Most In-Demand Skills**: SQL is by far the most requested skill, followed by Python, Excel, Tableau, and R. SQL is essentially a baseline requirement for the job market.
4. **Skills with Higher Salaries**: BI/visualization tools pay the most — Power BI and JavaScript ($132,500), Tableau ($112,667), and Looker ($105,000) top the list.
5. **Optimal Skills for Job Market Value**: SQL + Excel (must-haves — high demand, decent pay) paired with Tableau.

### Closing Thoughts

SQL gets you **hired**, but **visualization skills** get you **paid more**. Master SQL, Python, and Excel as your foundation, then add Tableau or Power BI to stand out and earn a premium.