/* EXPLORATORY DATA ANALYSIS (EDA) */

-- Create temporary table to display full state names in query results and differentiate between states (including DC) and territories.
CREATE TEMPORARY TABLE state_names AS
SELECT
	DISTINCT site_state AS state,
    site_state_name AS state_name,
    CASE WHEN site_state_fips_code BETWEEN 1 AND 59 THEN 'state'
		 ELSE 'territory'
	END AS state_type
FROM sites;


/* PATIENT DEMOGRAPHICS */

-- FQHC patient age distribution (national) by year
SELECT year,
	   SUM(children_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_children,
	   SUM(adults_18to64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_adults_18to64,
       SUM(adults_over64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_adults_over64
FROM patient_age_race
WHERE hc_type = 'FQHC'
GROUP BY year;

-- FQHC patient age distribution by state (5-year average)
SELECT s.state_name,
       SUM(p.children_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_children,
	   SUM(p.adults_18to64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_adults_18to64,
       SUM(p.adults_over64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_adults_over64
FROM patient_age_race AS p
JOIN state_names AS s
	 ON p.state = s.state
WHERE p.year BETWEEN 2019 AND 2023
	  AND p.hc_type = 'FQHC'
      AND s.state_type = 'state'
GROUP BY s.state_name
ORDER BY s.state_name;

-- Top 10 health centers with the highest percentage of patients representing racial or ethnic minorities in 2023 (excluding health centers based in US territories)
SELECT p.hc_name,
	   p.city,
       p.state,
       p.hc_type,
       ROUND(p.race_ethno_minority*100, 2) AS pct_race_ethno_minority
FROM patient_age_race AS p
JOIN state_names AS s
	 ON p.state = s.state
WHERE p.year = 2023
      AND s.state_type = 'state'
GROUP BY p.hc_name, p.city, p.state
ORDER BY pct_race_ethno_minority DESC
LIMIT 10;

-- Number of patients served at FQHCs in US territories in years 2018-2023
SELECT s.state_name AS territory_name,
       SUM(CASE WHEN p.year = 2018 THEN p.total_patients ELSE 0 END) AS pts_2018,
       SUM(CASE WHEN p.year = 2019 THEN p.total_patients ELSE 0 END) AS pts_2019,
       SUM(CASE WHEN p.year = 2020 THEN p.total_patients ELSE 0 END) AS pts_2020,
       SUM(CASE WHEN p.year = 2021 THEN p.total_patients ELSE 0 END) AS pts_2021,
       SUM(CASE WHEN p.year = 2022 THEN p.total_patients ELSE 0 END) AS pts_2022,
       SUM(CASE WHEN p.year = 2023 THEN p.total_patients ELSE 0 END) AS pts_2023
FROM patient_age_race AS p
JOIN state_names AS s
     ON p.state = s.state
WHERE s.state_type = 'territory'
	  AND p.hc_type = 'fqhc'
GROUP BY s.state_name
ORDER BY pts_2023 DESC;


/* CLINICAL OUTCOMES AND METRICS */

-- Preventive screening rates at the 5 largest FQHCs in 2023
-- (For the purpose of this query, FQHC size is determined by total_patients in 2023)
SELECT c.hc_name,
	   c.city,
       c.state,
       p.total_patients,
	   ROUND(c.cervical_cancer_screening*100, 2) AS cervical_cancer,
       ROUND(c.adult_tobacco_use_screening*100, 2) AS adult_tobacco_use,
       ROUND(c.colorectal_cancer_screening*100, 2) AS colorectal_cancer,
       ROUND(c.depression_screening*100, 2) AS depression,
       ROUND(c.breast_cancer_screening*100, 2) AS breast_cancer,
       ROUND(c.hiv_screening*100, 2) AS hiv
FROM clinical_data AS c
JOIN patient_age_race AS p
	ON c.hc_name = p.hc_name
	AND c.year = p.year
WHERE c.year = 2023
	AND c.hc_type = 'FQHC'
ORDER BY p.total_patients DESC
LIMIT 5;

-- Percentage of FQHC patients with hypertension, diabetes, and asthma (5 year average)
SELECT ROUND(AVG(hypertension)*100, 2) AS hypertension_pct,
       ROUND(AVG(diabetes)*100, 2) AS diabetes_pct,
       ROUND(AVG(asthma)*100, 2) AS asthma_pct,
       ROUND(AVG(hiv)*100, 2) AS hiv_pct
FROM clinical_data
WHERE year BETWEEN 2019 AND 2023;


/* COSTS AND GRANT EXPENDITURES */

-- Percentage of total costs funded by service grants each year
SELECT year,
	   ROUND(SUM(svc_grant_exp)/SUM(total_cost)*100, 2) AS pct_grant_funded
FROM cost
WHERE hc_type = 'FQHC'
GROUP BY year;

-- Top 5 states with the highest grant expenditure per patient in 2023
SELECT s.state_name,
	   ROUND(SUM(c.svc_grant_exp)/SUM(p.total_patients), 2) AS grant_exp_per_patient
FROM cost c
JOIN patient_age_race AS p
	 ON c.hc_name = p.hc_name
     AND c.year = p.year
JOIN state_names AS s
     ON c.state = s.state
WHERE c.year = 2023
	  AND c.hc_type = 'FQHC'
      AND s.state_type = 'state'
GROUP BY s.state_name
ORDER BY grant_exp_per_patient DESC
LIMIT 5;


/* PAYER MIX AND SOCIOECONOMIC FACTORS */

-- Average payer mix by year at health centers with over 75% of patients at or below 100% Federal Poverty Line
SELECT year, 
       ROUND(AVG(medicaid)*100, 2) AS avg_medicaid_pct, 
       ROUND(AVG(medicare)*100, 2) AS avg_medicare_pct,
       ROUND(AVG(other_payer)*100, 2) AS avg_other_payer_pct,
       ROUND(AVG(uninsured)*100, 2) AS avg_uninsured_pct
FROM payer_mix_fpl
WHERE patients_at_below_100_fpl > 0.75
GROUP BY year
ORDER BY year;

-- Number of FQHCs where total costs associated with uninsured patients exceed total service grant expenditures.
SELECT pm.year,
	   COUNT(*) AS fqhc_count
FROM payer_mix_fpl AS pm
JOIN cost AS c
	 ON pm.hc_name = c.hc_name
     AND pm.year = c.year
WHERE c.svc_grant_exp < (c.total_cost_per_patient*pm.uninsured_count)
	  AND pm.hc_type = 'FQHC'
GROUP BY year
ORDER BY year;


/* SERVICE UTILIZATION */

-- Average service utilization (as % of total patients) at health centers serving less than 2,500 patients each year.
SELECT s.year,
	   ROUND(AVG(s.medical)*100, 2) AS avg_medical_pct,
       ROUND(AVG(s.dental)*100, 2) AS avg_dental_pct,
       ROUND(AVG(s.mental_health)*100, 2) AS avg_mental_health_pct
FROM services AS s
JOIN patient_age_race AS p
	 ON s.hc_name = p.hc_name
     AND s.year = p.year
WHERE p.total_patients < 2500
GROUP BY s.year
ORDER BY s.year;

-- Comparing mental health utilization and depression screening rates.
-- (Note: This query excludes health centers that do not provide mental health services.)
WITH dep_screen_ranges AS (
	SELECT hc_name,
		   year,
           depression_screening,
           CASE WHEN depression_screening < 0.25 THEN '0_to_24_pct'
				WHEN depression_screening >= 0.25 AND depression_screening < 0.5 THEN '25_to_49_pct'
                WHEN depression_screening >= 0.5 AND depression_screening < 0.75 THEN '50_to_74_pct'
                ELSE '75_to_100_pct'
		   END AS dep_screening_bin
    FROM clinical_data
    )
SELECT d.dep_screening_bin,
 	   ROUND(AVG(s.mental_health)*100, 2) AS avg_mental_health_utilization
FROM dep_screen_ranges AS d
JOIN services AS s
	 ON d.hc_name = s.hc_name
     AND d.year = s.year
WHERE s.mental_health > 0 -- Excludes health centers that do not provide mental health services
GROUP BY d.dep_screening_bin
ORDER BY d.dep_screening_bin;

-- Drop temporary table created for above queries
DROP TEMPORARY TABLE state_names;