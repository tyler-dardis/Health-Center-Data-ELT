/* DATA VALIDATION */

-- To validate the accuracy of the data after wrangling, the following queries are used to compare our dataset to the national aggregated summaries published by HRSA: https://data.hrsa.gov/tools/data-reporting/program-data/national (Note: HRSA publishes separate national summaries for FQHC and Look-Alike health centers. The queries below validate FQHC data. To validate Look-Alike data, run the same queries with 'Look-Alike' replacing 'FQHC' in the WHERE clause.)

-- CONCLUSION: Most national totals in our dataset match exactly with HRSA's published national totals. Some totals show small variances due to NULL values at the health center level, where HRSA suppresses values less than 16 for confidentiality, causing these values to be included in HRSA's aggregated totals but excluded in ours. These variances are negligible, representing a difference of less than 0.001% between datasets. (Note that these variances were minimized during data wrangling, when NULL values were replaced where their true values could be calculated using other columns in the dataset.)


-- Confirm patient counts by age range
SELECT year,
	   SUM(total_patients),
       SUM(children_count),
       SUM(adults_18to64_count),
       SUM(adults_over64_count)
FROM patient_age_race
WHERE hc_type = 'FQHC'
GROUP BY year;

-- Confirm patient counts by payer type
SELECT year,
	   SUM(uninsured_count),
       SUM(medicaid_count),
       SUM(medicare_count),
       SUM(other_payer_count)
FROM payer_mix_fpl
WHERE hc_type = 'FQHC'
GROUP BY year;

-- Confirm patient counts by service type
SELECT year,
	   SUM(medical_count),
       SUM(dental_count),
       SUM(mental_health_count),
       SUM(substance_abuse_count),
       SUM(vision_count),
       SUM(enabling_count)
FROM services
WHERE hc_type = 'FQHC'
GROUP BY year;

-- Confirm cost and grant expenditure totals (JOIN is used to calculate national cost per patient)
SELECT c.year,
	   SUM(total_cost),
       SUM(svc_grant_exp),
       ROUND(SUM(total_cost)/SUM(total_patients), 2) AS total_cost_per_patient
FROM cost AS c
JOIN patient_age_race AS p ON c.hc_name = p.hc_name AND c.year = p.year
WHERE c.hc_type = 'FQHC'
GROUP BY c.year;
