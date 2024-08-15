/* DATA WRANGLING: patient_age_race TABLE */

-- In the original dataset, patient age ranges (<18, 18-64, >64) are reported as percentages of total patients. The following query creates new columns for patient counts (#) by age range.
ALTER TABLE patient_age_race
ADD COLUMN children_count INT,
ADD COLUMN adults_18to64_count INT,
ADD COLUMN adults_over64_count INT;

-- Add patient counts to the new columns (by multiplying total_patients by the corresponding age range percentages)
UPDATE patient_age_race 
SET children_count = ROUND(total_patients * children),
    adults_18to64_count = ROUND(total_patients * adults_18to64),
    adults_over64_count = ROUND(total_patients * adults_over64);
    
-- NULL values do not necessarily represent 0 in the dataset, however if only one of the age ranges is NULL, we can calculate its missing value. The following two queries replace NULLs where their correct values can be deduced.
-- (For example, if a row has a NULL value in the 'children' percentage column and the 'adults_18to64' and 'adults_over64' values are NOT NULL, we can calculate the value that should replace NULL so that the sum of the 3 columns equals 100%.)
UPDATE patient_age_race 
SET children = ROUND(1 - adults_18to64 - adults_over64, 7),
    children_count = (total_patients - adults_18to64_count - adults_over64_count)
WHERE children IS NULL
	AND adults_18to64 IS NOT NULL
	AND adults_over64 IS NOT NULL;
UPDATE patient_age_race 
SET adults_over64 = ROUND(1 - adults_18to64 - children, 7),
    adults_over64_count = (total_patients - adults_18to64_count - children_count)
WHERE children IS NOT NULL
	AND adults_18to64 IS NOT NULL
	AND adults_over64 IS NULL;

-- While NULL values in percentage columns do not necessarily equal 0%, it can be deduced that where total_patients equals 0, the age range counts also equal 0.
UPDATE patient_age_race
SET children_count = 0,
    adults_18to64_count = 0,
    adults_over64_count = 0
WHERE total_patients = 0;
    
-- To confirm that the sum of the new columns is equal to the total_patients column, this query should return a 0 value. (Since NULL values do not necessarily equal 0, rows containing any NULL values in the count columns must be excluded from this validation query.)
SELECT SUM(children_count + adults_18to64_count + adults_over64_count) - SUM(total_patients) AS patient_count_variance
FROM patient_age_race
WHERE children_count IS NOT NULL AND
	adults_18to64_count IS NOT NULL AND
	adults_over64_count IS NOT NULL;


/* DATA WRANGLING: cost TABLE */

-- Calculate and update NULL values in total_cost_per_patient by joining cost and patient_age_race tables
UPDATE cost c
JOIN patient_age_race p ON c.hc_name = p.hc_name AND c.year = p.year
SET c.total_cost_per_patient = ROUND(c.total_cost / p.total_patients, 2)
WHERE c.total_cost_per_patient IS NULL
	AND p.total_patients <> 0 ;


/* DATA WRANGLING: payer_mix_fpl TABLE */

-- In the original dataset, payer mix is reported as percentages of total patients. The following query creates new columns for patient counts (#) by payer type.
ALTER TABLE payer_mix_fpl
ADD COLUMN uninsured_count INT,
ADD COLUMN medicaid_count INT,
ADD COLUMN medicare_count INT,
ADD COLUMN other_payer_count INT;

-- Add patient counts to the new columns (by multiplying total_patients by the corresponding payer mix percentages)
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.uninsured_count = ROUND(pm.uninsured * par.total_patients),
    pm.medicaid_count = ROUND(pm.medicaid * par.total_patients),
    pm.medicare_count = ROUND(pm.medicare * par.total_patients),
    pm.other_payer_count = ROUND(pm.other_payer * par.total_patients);

-- Similar to the age ranges on the patient_age_race table, if only one of the payer columns is NULL, we can calculate its missing value. The following four queries replace NULLs where their correct values can be deduced.
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.uninsured = ROUND(1 - pm.medicaid - pm.medicare - pm.other_payer, 7),
    pm.uninsured_count = (par.total_patients - pm.medicaid_count - pm.medicare_count - pm.other_payer_count)
WHERE pm.uninsured IS NULL
	AND pm.medicaid IS NOT NULL
	AND pm.medicare IS NOT NULL
    AND pm.other_payer IS NOT NULL;
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.medicaid = ROUND(1 - pm.uninsured - pm.medicare - pm.other_payer, 7),
    pm.medicaid_count = (par.total_patients - pm.uninsured_count - pm.medicare_count - pm.other_payer_count)
WHERE pm.uninsured IS NOT NULL
	AND pm.medicaid IS NULL
	AND pm.medicare IS NOT NULL
    AND pm.other_payer IS NOT NULL;
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.medicare = ROUND(1 - pm.uninsured - pm.medicaid - pm.other_payer, 7),
    pm.medicare_count = (par.total_patients - pm.uninsured_count - pm.medicaid_count - pm.other_payer_count)
WHERE pm.uninsured IS NOT NULL
	AND pm.medicaid IS NOT NULL
	AND pm.medicare IS NULL
    AND pm.other_payer IS NOT NULL;
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.other_payer = ROUND(1 - pm.uninsured - pm.medicaid - pm.medicare, 7),
    pm.other_payer_count = (par.total_patients - pm.uninsured_count - pm.medicaid_count - pm.medicare_count)
WHERE pm.uninsured IS NOT NULL
	AND pm.medicaid IS NOT NULL
	AND pm.medicare IS NOT NULL
    AND pm.other_payer IS NULL;

-- Set all other payers to 0 where one payer is 100%. (Some of these instances are reported as NULL in the original dataset.)
UPDATE payer_mix_fpl
SET medicaid = 0,
    medicaid_count = 0,
    medicare = 0,
    medicare_count = 0,
    other_payer = 0,
    other_payer_count = 0
WHERE uninsured = 1;
UPDATE payer_mix_fpl
SET uninsured = 0,
    uninsured_count = 0,
    medicare = 0,
    medicare_count = 0,
    other_payer = 0,
    other_payer_count = 0
WHERE medicaid = 1;
UPDATE payer_mix_fpl
SET uninsured = 0,
    uninsured_count = 0,
    medicaid = 0,
    medicaid_count = 0,
    other_payer = 0,
    other_payer_count = 0
WHERE medicare = 1;
UPDATE payer_mix_fpl
SET uninsured = 0,
    uninsured_count = 0,
    medicaid = 0,
    medicaid_count = 0,
    medicare = 0,
    medicare_count = 0
WHERE other_payer = 1;

/* DATA WRANGLING: services TABLE */

-- Similar to tables above, services rendered are reported as percentages of total patients. The following query creates new columns for patient counts (#) for each service type.
ALTER TABLE services
ADD COLUMN medical_count INT,
ADD COLUMN dental_count INT,
ADD COLUMN mental_health_count INT,
ADD COLUMN substance_abuse_count INT,
ADD COLUMN vision_count INT,
ADD COLUMN enabling_count INT;

-- Add patient counts to the new columns (by multiplying total_patients by the corresponding service type percentages)
UPDATE services AS s
JOIN patient_age_race AS par ON s.hc_name = par.hc_name AND s.year = par.year
SET s.medical_count = ROUND(s.medical * par.total_patients),
    s.dental_count = ROUND(s.dental * par.total_patients),
    s.mental_health_count = ROUND(s.mental_health * par.total_patients),
    s.substance_abuse_count = ROUND(s.substance_abuse * par.total_patients),
    s.vision_count = ROUND(s.vision * par.total_patients),
    s.enabling_count = ROUND(s.enabling * par.total_patients);



/* DATA WRANGLING: sites TABLE */

-- Standardize site zip codes
ALTER TABLE sites
ADD COLUMN site_zipcode_ext VARCHAR(4)
AFTER site_zipcode;
UPDATE sites 
SET site_zipcode_ext = CASE
        WHEN LENGTH(site_zipcode) = 5 THEN NULL
        ELSE RIGHT(site_zipcode, 4)
    END,
    site_zipcode = LEFT(site_zipcode, 5);
    
-- Standardize admin zip codes
ALTER TABLE sites
ADD COLUMN hc_zipcode_ext VARCHAR(4)
AFTER hc_zipcode;
UPDATE sites 
SET hc_zipcode_ext = CASE
        WHEN LENGTH(hc_zipcode) = 5 THEN NULL
        ELSE RIGHT(hc_zipcode, 4)
    END,
    hc_zipcode = LEFT(hc_zipcode, 5);

-- Standardize phone numbers
ALTER TABLE sites
ADD COLUMN site_phone_ext VARCHAR(15)
AFTER site_phone;
UPDATE sites
SET site_phone_ext = CASE 
        WHEN LENGTH(site_phone) > 12 THEN RIGHT(site_phone, LENGTH(site_phone) - 12)
        ELSE NULL
    END,
    site_phone = LEFT(site_phone, 12);
    