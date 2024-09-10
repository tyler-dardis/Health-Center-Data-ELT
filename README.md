# Health Center Data ELT

**Objective:** Extract, load, and transform (ELT) the UDS dataset to prepare it for analysis.

**Data:** 2018-2023 Uniform Data System dataset (from the [HRSA website](data.HRSA.gov))

**Tools:** SQL (MySQL)
<br><br>

## Summary
In this ELT project, I created a MySQL database for storing and querying community health center data. Once the data was loaded into the appropriate tables, I used SQL to wrangle the data to prepare it for future analysis. After the ELT process, I queried the database to perform some high level data analysis.

**Note:** This page presents the project in a reader-friendly format, with some query outputs. All of the raw .sql files are also available in this repository.

## Table of Contents
1. [Dataset](https://github.com/tyler-dardis/Health-Center-Data-ELT#dataset)
2. [Create Tables](https://github.com/tyler-dardis/Health-Center-Data-ELT#create-tables)
3. [Load Data](https://github.com/tyler-dardis/Health-Center-Data-ELT#load-data)
4. [Data Wrangling](https://github.com/tyler-dardis/Health-Center-Data-ELT/edit/main/README.md#data-wrangling)
5. [Data Validation](https://github.com/tyler-dardis/Health-Center-Data-ELT/edit/main/README.md#data-validation)
6. [Data Querying/Analysis](https://github.com/tyler-dardis/Health-Center-Data-ELT/edit/main/README.md#data-queryinganalysis)

## Dataset
The Health Resources and Services Administration (HRSA) oversees the national health center program, which includes 1,496 health centers serving 32.5 million patients across the U.S. In overseeing this program, HRSA collects financial and clinical data from health centers via the annual Uniform Data System report. While some of the data reported is proprietary and not publicly available, HRSA publishes some of the dataset. This dataset is available for download on their website in Excel format and includes the most recent five years of data. (I downloaded the dataset before and after the publication of the 2023 UDS report, so my data includes six years.)

The UDS dataset is split into five categories:
- Clinical data
- Cost
- Patient age & race
- Payer mix & FPL (federal poverty line)
- Services

I also used a dataset that includes records of all health center sites/locations. While this is not a part of the annual HRSA report download, I found this dataset relevant and useful to this project.

**Note:** The UDS data download is broken out by year into separate Excel files. Each year's Excel file has separate sheets for each data category. To minimize the time spent saving these as .csv files to import to my database, I used a simple Python script to extract each tab and compile all years into one .csv file for each data category. As this project is focused on SQL, I won't detail the python script here.

## Create Tables
Once the .csv files were prepared and ready to import, I created six tables in my database, one for each of the categories of data:
- clinical_data
- cost
- patient_age_race
- payer_mix_fpl
- services
- sites

```sql
DROP TABLE IF EXISTS patient_age_race;
DROP TABLE IF EXISTS clinical_data;
DROP TABLE IF EXISTS cost;
DROP TABLE IF EXISTS payer_mix_fpl;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS sites;

CREATE TABLE patient_age_race (
    hc_name VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    year INT,
    total_patients INT,
    children FLOAT,
    adults_18to64 FLOAT,
    adults_over64 FLOAT,
    race_ethno_minority FLOAT,
    hisp_lat_ethno FLOAT,
    black FLOAT,
    asian FLOAT,
    native_amer_alaska FLOAT,
    native_hawaii_pacific FLOAT,
    more_than_one_race FLOAT,
    another_language FLOAT,
    hc_type VARCHAR(25)
);

CREATE TABLE clinical_data (
    hc_name VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    year INT,
    hypertension FLOAT,
    diabetes FLOAT,
    asthma FLOAT,
    hiv FLOAT,
    prenatal_patients INT,
    prenatal_patients_delivered INT,
    access_to_prenatal_care FLOAT,
    low_birth_weight FLOAT,
    cervical_cancer_screening FLOAT,
    adolescent_weight_screening FLOAT,
    adult_weight_screening FLOAT,
    adult_tobacco_use_screening FLOAT,
    colorectal_cancer_screening FLOAT,
    childhood_immunization FLOAT,
    depression_screening FLOAT,
    dental_sealants FLOAT,
    asthma_treatment FLOAT,
    statin_therapy_cardio_disease FLOAT,
    heart_attack_stroke_treatment FLOAT,
    bp_control FLOAT,
    uncontrolled_diabetes FLOAT,
    hiv_linkage_to_care FLOAT,
    breast_cancer_screening FLOAT,
    depression_remission FLOAT,
    hiv_screening FLOAT,
    hc_type VARCHAR(25)
);

CREATE TABLE cost (
    hc_name VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    year INT,
    svc_grant_exp INT,
    total_cost INT,
    total_cost_per_patient FLOAT,
    hc_type VARCHAR(25)
);

CREATE TABLE payer_mix_fpl (
    hc_name VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    year INT,
    patients_at_below_200_fpl FLOAT,
    patients_at_below_100_fpl FLOAT,
    uninsured FLOAT,
    medicaid FLOAT,
    medicare FLOAT,
    other_payer FLOAT,
    hc_type VARCHAR(25)
);

CREATE TABLE services (
    hc_name VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    year INT,
    medical FLOAT,
    dental FLOAT,
    mental_health FLOAT,
    substance_abuse FLOAT,
    vision FLOAT,
    enabling FLOAT,
    hc_type VARCHAR(25)
);

CREATE TABLE sites (
    hc_type VARCHAR(200),
    hc_id VARCHAR(50),
    bhcmis_id VARCHAR(50),
    bphc_id VARCHAR(50),
    site_name VARCHAR(200),
    site_address VARCHAR(200),
    site_city VARCHAR(50),
    site_state VARCHAR(2),
    site_zipcode VARCHAR(50),
    site_phone VARCHAR(50),
    site_website VARCHAR(200),
    op_hrs_per_wk FLOAT,
    site_setting_id INT,
    site_setting_desc VARCHAR(200),
    site_status_id INT,
    hc_status_desc VARCHAR(50),
    site_medicare_billing_num VARCHAR(50),
    site_npi VARCHAR(50),
    loc_type_id INT,
    loc_type_desc VARCHAR(50),
    site_type_id INT,
    site_type_desc VARCHAR(50),
    hc_operator_id INT,
    hc_operator_desc VARCHAR(50),
    site_op_sched_id INT,
    site_op_sched_desc VARCHAR(50),
    site_op_calendar_id INT,
    site_op_calendar_desc VARCHAR(50),
    site_added_date DATE,
    hc_name VARCHAR(200),
    hc_address VARCHAR(200),
    hc_city VARCHAR(50),
    hc_state VARCHAR(2),
    hc_zipcode VARCHAR(50),
    hc_org_type VARCHAR(200),
    site_longitude FLOAT,
    site_latitude FLOAT,
    site_mex_border_100km VARCHAR(2),
    site_mex_border_county VARCHAR(2),
    site_state_county_fed_info_code VARCHAR(5),
    site_county_full VARCHAR(200),
    site_county VARCHAR(200),
    site_county_type VARCHAR(50),
    site_region_code VARCHAR(2),
    site_region_name VARCHAR(9),
    site_state_fips_code VARCHAR(2),
    site_state_name VARCHAR(50),
    site_fips_congress_dist_num VARCHAR(4),
    site_congress_dist_num VARCHAR(2),
    site_congress_dist_name VARCHAR(50),
    site_congress_dist_code VARCHAR(5),
    site_us_rep_name VARCHAR(50),
    site_us_sen_name_1 VARCHAR(50),
    site_us_sen_name_2 VARCHAR(50),
    data_collection_date DATE
);
```

## Load Data
After the tables were created, I loaded the data from the .csv files into their corresponding tables.

```sql
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\patient_age_race_combined.csv'
INTO TABLE patient_age_race
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_name,
    city,
    state,
    year,
    total_patients,
    children,
    adults_18to64,
    adults_over64,
    race_ethno_minority,
    hisp_lat_ethno,
    black,
    asian,
    native_amer_alaska,
    native_hawaii_pacific,
    more_than_one_race,
    another_language,
    hc_type
);
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\clinical_data_combined.csv'
INTO TABLE clinical_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_name,
    city,
    state,
    year,
    hypertension,
    diabetes,
    asthma,
    hiv,
    prenatal_patients,
    prenatal_patients_delivered,
    access_to_prenatal_care,
    low_birth_weight,
    cervical_cancer_screening,
    adolescent_weight_screening,
    adult_weight_screening,
    adult_tobacco_use_screening,
    colorectal_cancer_screening,
    childhood_immunization,
    depression_screening,
    dental_sealants,
    asthma_treatment,
    statin_therapy_cardio_disease,
    heart_attack_stroke_treatment,
    bp_control,
    uncontrolled_diabetes,
    hiv_linkage_to_care,
    breast_cancer_screening,
    depression_remission,
    hiv_screening,
    hc_type
);
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\cost_combined.csv'
INTO TABLE cost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_name,
    city,
    state,
    year,
    svc_grant_exp,
    total_cost,
    total_cost_per_patient,
    hc_type
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\payer_mix_fpl_combined.csv'
INTO TABLE payer_mix_fpl
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_name,
    city,
    state,
    year,
    patients_at_below_200_fpl,
    patients_at_below_100_fpl,
    uninsured,
    medicaid,
    medicare,
    other_payer,
    hc_type
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\services_combined.csv'
INTO TABLE services
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_name,
    city,
    state,
    year,
    medical,
    dental,
    mental_health,
    substance_abuse,
    vision,
    enabling,
    hc_type
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\LOAD DATA INFILE\\Health_Center_Service_Delivery_and_LookAlike_Sites.csv'
INTO TABLE sites
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hc_type,
    hc_id,
    bhcmis_id,
    bphc_id,
    site_name,
    site_address,
    site_city,
    site_state,
    site_zipcode,
    site_phone,
    site_website,
    op_hrs_per_wk,
    site_setting_id,
    site_setting_desc,
    site_status_id,
    hc_status_desc,
    site_medicare_billing_num,
    site_npi,
    loc_type_id,
    loc_type_desc,
    site_type_id,
    site_type_desc,
    hc_operator_id,
    hc_operator_desc,
    site_op_sched_id,
    site_op_sched_desc,
    site_op_calendar_id,
    site_op_calendar_desc,
    site_added_date,
    hc_name,
    hc_address,
    hc_city,
    hc_state,
    hc_zipcode,
    hc_org_type,
    site_longitude,
    site_latitude,
    site_mex_border_100km,
    site_mex_border_county,
    site_state_county_fed_info_code,
    site_county_full,
    site_county,
    site_county_type,
    site_region_code,
    site_region_name,
    site_state_fips_code,
    site_state_name,
    site_fips_congress_dist_num,
    site_congress_dist_num,
    site_congress_dist_name,
    site_congress_dist_code,
    site_us_rep_name,
    site_us_sen_name_1,
    site_us_sen_name_2,
    data_collection_date
);
```

### Set Primary Keys
For each table storing annual data (all tables except 'sites'), I used the 'hc_name' and 'year' columns together as the composite primary key. However, some health centers have the same 'hc_name'. To ensure that each has a unique 'hc_name', I used the following queries to add the health center's 'state' to 'hc_name' for each duplicate, differentiating them. (This step was necessary to avoid errors when establishing the primary keys.)

```sql
-- Create temp table containing all duplicate 'hc_name'
CREATE TEMPORARY TABLE duplicate_hc_names AS
SELECT hc_name
FROM clinical_data
GROUP BY hc_name
HAVING COUNT(DISTINCT state) > 1;

-- For all dupicates, add 'state' to 'hc_name' (repeat for all tables)
UPDATE clinical_data
SET hc_name = CONCAT(hc_name, ' (', state, ')')
WHERE hc_name IN (SELECT hc_name FROM duplicate_hc_names);

UPDATE cost
SET hc_name = CONCAT(hc_name, ' (', state, ')')
WHERE hc_name IN (SELECT hc_name FROM duplicate_hc_names);

UPDATE patient_age_race
SET hc_name = CONCAT(hc_name, ' (', state, ')')
WHERE hc_name IN (SELECT hc_name FROM duplicate_hc_names);

UPDATE payer_mix_fpl
SET hc_name = CONCAT(hc_name, ' (', state, ')')
WHERE hc_name IN (SELECT hc_name FROM duplicate_hc_names);

UPDATE services
SET hc_name = CONCAT(hc_name, ' (', state, ')')
WHERE hc_name IN (SELECT hc_name FROM duplicate_hc_names);

DROP TEMPORARY TABLE duplicate_hc_names;

-- The following query should return nothing if no duplicates remain.
-- (If this query DOES return any health center names, this means they are using the same hc_name within the same state.
-- Similar to the methodology above, 'city' could then be used to differentiate between the duplicates.)
SELECT hc_name
FROM clinical_data
GROUP BY hc_name
HAVING COUNT(year) > 6;

-- Set primary key for each table
ALTER TABLE patient_age_race ADD PRIMARY KEY (hc_name, year);
ALTER TABLE clinical_data ADD PRIMARY KEY (hc_name, year);
ALTER TABLE cost ADD PRIMARY KEY (hc_name, year);
ALTER TABLE payer_mix_fpl ADD PRIMARY KEY (hc_name, year);
ALTER TABLE services ADD PRIMARY KEY (hc_name, year);
ALTER TABLE sites ADD PRIMARY KEY (bphc_id);
```

## Data Wrangling
Because HRSA has dedicated staff that review all UDS report submissions each year, the dataset does not require a significant amount of cleaning. However, performing some data wrangling, such as reformatting some of the columns (e.g., converting percentages to counts) and replacing NULL values where their true values can be determined, can better prepare the data for analysis. The follow queries were used to accomplish this.

### 'patient_age_race' Table
In the original dataset, patient age ranges (<18, 18-64, >64) are reported as percentages of total patients. The following queries create new columns for patient counts (#) by age range and add values to them (calculated by multiplying 'total_patients' by the corresponding age range percentages).

```sql
-- Add new columns for patient counts
ALTER TABLE patient_age_race
ADD COLUMN children_count INT,
ADD COLUMN adults_18to64_count INT,
ADD COLUMN adults_over64_count INT;

-- Add patient counts to the new columns
UPDATE patient_age_race 
SET children_count = ROUND(total_patients * children),
    adults_18to64_count = ROUND(total_patients * adults_18to64),
    adults_over64_count = ROUND(total_patients * adults_over64);
```

NULL values do not necessarily represent 0 in the dataset. However, if only one of the age ranges is NULL, its missing value can be determined. The following two queries replace NULLs where their correct values can be deduced. (For example, if a row has a NULL value in the 'children' percentage column and the 'adults_18to64' and 'adults_over64' values are NOT NULL, we can calculate the value that should replace NULL so that the sum of the 3 columns equals 100%.)

```sql
-- Replace all NULLs in age range columns where true values can be determined
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
```

While NULL values in percentage columns do not necessarily equal 0%, it can be deduced that where total_patients equals 0, the age range counts also equal 0. (This is very uncommon in this dataset, but I did identify several health centers with 0 reported patients.)

```sql
-- Set all age range counts to 0 where 'total_patients' is 0.
UPDATE patient_age_race
SET children_count = 0,
    adults_18to64_count = 0,
    adults_over64_count = 0
WHERE total_patients = 0;
```

To confirm that the sum of the new columns is equal to the 'total_patients' column, this query should return a 0 value. (Since NULL values do not necessarily equal 0, rows containing any NULL values in the count columns must be excluded from this validation query.)

```sql    
-- Validate age range counts
SELECT SUM(children_count + adults_18to64_count + adults_over64_count) - SUM(total_patients) AS patient_count_variance
FROM patient_age_race
WHERE children_count IS NOT NULL
  AND adults_18to64_count IS NOT NULL
  AND adults_over64_count IS NOT NULL;
```


### 'cost' Table
Many of the 'total_cost_per_patient' values were NULL. The following query calculates the correct values and updates all NULLs. To do this, the 'cost' and 'patient_age_race' tables are joined.
```sql
-- Update NULL values in 'total_cost_per_patient'
UPDATE cost c
JOIN patient_age_race p ON c.hc_name = p.hc_name AND c.year = p.year
SET c.total_cost_per_patient = ROUND(c.total_cost / p.total_patients, 2)
WHERE c.total_cost_per_patient IS NULL
  AND p.total_patients <> 0 ;
```

### 'payer_mix_fpl' Table
In the original dataset, payer mix is reported as percentages of total patients, similar to the age ranges in the 'patient_age_race' table. The following queries add new columns for patient counts (#) by payer type and add values to them (calculated by multiplying 'total_patients' by the corresponding payer type percentages)

```sql
-- Add new columns for patient counts by payer type
ALTER TABLE payer_mix_fpl
ADD COLUMN uninsured_count INT,
ADD COLUMN medicaid_count INT,
ADD COLUMN medicare_count INT,
ADD COLUMN other_payer_count INT;

-- Add patient counts to the new columns
UPDATE payer_mix_fpl AS pm
JOIN patient_age_race AS par ON pm.hc_name = par.hc_name AND pm.year = par.year
SET pm.uninsured_count = ROUND(pm.uninsured * par.total_patients),
    pm.medicaid_count = ROUND(pm.medicaid * par.total_patients),
    pm.medicare_count = ROUND(pm.medicare * par.total_patients),
    pm.other_payer_count = ROUND(pm.other_payer * par.total_patients);
```

Also similar to the age ranges in the 'patient_age_race' table, if only one of the payer columns is NULL, its missing value can be determined. The following four queries replace NULLs where their correct values can be deduced.

```sql
-- Replace all NULLs in payer mix columns where true values can be determined
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
```

It can also be deduced that where one payer is 100%, all others are 0%.

```sql
-- Set payer mix values to 0 where appropriate
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
```

### 'services' Table
Similar to tables above, services rendered are reported as percentages of total patients. The following query add new columns for patient counts (#) for each service type and add values to them (calculated by multiplying 'total_patients' by the corresponding service type percentages)

```sql
-- Add new columns for patient counts by service type
ALTER TABLE services
ADD COLUMN medical_count INT,
ADD COLUMN dental_count INT,
ADD COLUMN mental_health_count INT,
ADD COLUMN substance_abuse_count INT,
ADD COLUMN vision_count INT,
ADD COLUMN enabling_count INT;

-- Add patient counts to the new columns
UPDATE services AS s
JOIN patient_age_race AS par ON s.hc_name = par.hc_name AND s.year = par.year
SET s.medical_count = ROUND(s.medical * par.total_patients),
    s.dental_count = ROUND(s.dental * par.total_patients),
    s.mental_health_count = ROUND(s.mental_health * par.total_patients),
    s.substance_abuse_count = ROUND(s.substance_abuse * par.total_patients),
    s.vision_count = ROUND(s.vision * par.total_patients),
    s.enabling_count = ROUND(s.enabling * par.total_patients);
```
### 'sites' Table
Health center site zip codes were not reported consistently, as some included a 4-digit extension, while others did not. The following queries standardize the format.

```sql
-- Standardize service delivery site zip codes
ALTER TABLE sites
ADD COLUMN site_zipcode_ext VARCHAR(4)
AFTER site_zipcode;
UPDATE sites 
SET site_zipcode_ext = CASE
        WHEN LENGTH(site_zipcode) = 5 THEN NULL
        ELSE RIGHT(site_zipcode, 4)
    END,
    site_zipcode = LEFT(site_zipcode, 5);
    
-- Standardize admin/master site zip codes
ALTER TABLE sites
ADD COLUMN hc_zipcode_ext VARCHAR(4)
AFTER hc_zipcode;
UPDATE sites 
SET hc_zipcode_ext = CASE
        WHEN LENGTH(hc_zipcode) = 5 THEN NULL
        ELSE RIGHT(hc_zipcode, 4)
    END,
    hc_zipcode = LEFT(hc_zipcode, 5);
```
Phone numbers were also not reported consistently, some including an extension.

```sql
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
```

## Data Validation
To validate the accuracy of the data after wrangling, I used the following queries to compare my processed data with the national aggregated summaries published on the [HRSA website](https://data.hrsa.gov/tools/data-reporting/program-data/national).

**Note:** HRSA publishes separate national summaries for FQHC and Look-Alike health centers. The queries below validate FQHC data. To validate Look-Alike data, the same queries could be run with 'Look-Alike' replacing 'FQHC' in the WHERE clause.

```sql
-- Confirm patient counts by age range
SELECT year,
       SUM(total_patients),
       SUM(children_count),
       SUM(adults_18to64_count),
       SUM(adults_over64_count)
FROM patient_age_race
WHERE hc_type = 'FQHC'
GROUP BY year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Confirm patient counts by payer type
SELECT year,
       SUM(uninsured_count),
       SUM(medicaid_count),
       SUM(medicare_count),
       SUM(other_payer_count)
FROM payer_mix_fpl
WHERE hc_type = 'FQHC'
GROUP BY year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
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
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Confirm cost and grant expenditure totals (JOIN is used to calculate national cost per patient)
SELECT c.year,
       SUM(total_cost),
       SUM(svc_grant_exp),
       ROUND(SUM(total_cost)/SUM(total_patients), 2) AS total_cost_per_patient
FROM cost AS c
JOIN patient_age_race AS p ON c.hc_name = p.hc_name AND c.year = p.year
WHERE c.hc_type = 'FQHC'
GROUP BY c.year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

### Conclusion:
Most national totals in my dataset match exactly with HRSA's published national totals. Some totals show small variances due to NULL values at the health center level, where HRSA suppresses patient count values less than 16 for confidentiality, causing these values to be included in HRSA's aggregated totals but excluded from mine. These variances are negligible, representing a difference of less than 0.001% between datasets. (Note that these variances were also minimized during data wrangling, when NULL values were replaced where their true values could be deduced.)

## Data Querying/Analysis
After completing the ELT process, I used the queries below for some high level, exploratory data analysis.

First, to display full state names in my query results and differentiate between states (including DC) and territories, I ran this query to create a temporary table for use later.

```sql
-- Create temporary table containing full state names and state/territory type
CREATE TEMPORARY TABLE state_names AS
SELECT DISTINCT site_state AS state,
       site_state_name AS state_name,
       CASE WHEN site_state_fips_code BETWEEN 1 AND 59 THEN 'state'
            ELSE 'territory'
       END AS state_type
FROM sites;
```

### Patient Demographics

```sql
-- FQHC patient age distribution (national) by year
SELECT year,
       SUM(children_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_children,
       SUM(adults_18to64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_adults_18to64,
       SUM(adults_over64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100 AS pct_adults_over64
FROM patient_age_race
WHERE hc_type = 'FQHC'
GROUP BY year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- FQHC patient age distribution by state (5-year average)
SELECT s.state_name,
       SUM(p.children_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_children,
       SUM(p.adults_18to64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_adults_18to64,
       SUM(p.adults_over64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100 AS pct_adults_over64
FROM patient_age_race AS p
JOIN state_names AS s ON p.state = s.state
WHERE p.year BETWEEN 2019 AND 2023
  AND p.hc_type = 'FQHC'
  AND s.state_type = 'state'
GROUP BY s.state_name
ORDER BY s.state_name;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Top 10 health centers with the highest percentage of patients representing racial or ethnic minorities in 2023 (excluding health centers based in US territories)
SELECT p.hc_name,
       p.city,
       p.state,
       p.hc_type,
       ROUND(p.race_ethno_minority*100, 2) AS pct_race_ethno_minority
FROM patient_age_race AS p
JOIN state_names AS s ON p.state = s.state
WHERE p.year = 2023
  AND s.state_type = 'state'
GROUP BY p.hc_name, p.city, p.state
ORDER BY pct_race_ethno_minority DESC
LIMIT 10;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Number of patients served at FQHCs in US territories in years 2018-2023
SELECT s.state_name AS territory_name,
       SUM(CASE WHEN p.year = 2018 THEN p.total_patients ELSE 0 END) AS pts_2018,
       SUM(CASE WHEN p.year = 2019 THEN p.total_patients ELSE 0 END) AS pts_2019,
       SUM(CASE WHEN p.year = 2020 THEN p.total_patients ELSE 0 END) AS pts_2020,
       SUM(CASE WHEN p.year = 2021 THEN p.total_patients ELSE 0 END) AS pts_2021,
       SUM(CASE WHEN p.year = 2022 THEN p.total_patients ELSE 0 END) AS pts_2022,
       SUM(CASE WHEN p.year = 2023 THEN p.total_patients ELSE 0 END) AS pts_2023
FROM patient_age_race AS p
JOIN state_names AS s ON p.state = s.state
WHERE s.state_type = 'territory'
  AND p.hc_type = 'fqhc'
GROUP BY s.state_name
ORDER BY pts_2023 DESC;
```

### Clinical Outcomes and Metrics

```sql
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
JOIN patient_age_race AS p ON c.hc_name = p.hc_name AND c.year = p.year
WHERE c.year = 2023
  AND c.hc_type = 'FQHC'
ORDER BY p.total_patients DESC
LIMIT 5;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Percentage of FQHC patients with hypertension, diabetes, and asthma (5 year average)
SELECT ROUND(AVG(hypertension)*100, 2) AS hypertension_pct,
       ROUND(AVG(diabetes)*100, 2) AS diabetes_pct,
       ROUND(AVG(asthma)*100, 2) AS asthma_pct,
       ROUND(AVG(hiv)*100, 2) AS hiv_pct
FROM clinical_data
WHERE year BETWEEN 2019 AND 2023;
```

### Costs and Grant Expenditures

```sql
-- Percentage of total costs funded by service grants each year
SELECT year,
       ROUND(SUM(svc_grant_exp)/SUM(total_cost)*100, 2) AS pct_grant_funded
FROM cost
WHERE hc_type = 'FQHC'
GROUP BY year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Top 5 states with the highest grant expenditure per patient in 2023
SELECT s.state_name,
       ROUND(SUM(c.svc_grant_exp)/SUM(p.total_patients), 2) AS grant_exp_per_patient
FROM cost c
JOIN patient_age_race AS p ON c.hc_name = p.hc_name AND c.year = p.year
JOIN state_names AS s ON c.state = s.state
WHERE c.year = 2023
  AND c.hc_type = 'FQHC'
  AND s.state_type = 'state'
GROUP BY s.state_name
ORDER BY grant_exp_per_patient DESC
LIMIT 5;
```

### Payer Mix and Socioeconomic Factors

```sql
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
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Number of FQHCs where total costs associated with uninsured patients exceed total service grant expenditures.
SELECT pm.year,
       COUNT(*) AS fqhc_count
FROM payer_mix_fpl AS pm
JOIN cost AS c ON pm.hc_name = c.hc_name AND pm.year = c.year
WHERE c.svc_grant_exp < (c.total_cost_per_patient*pm.uninsured_count)
  AND pm.hc_type = 'FQHC'
GROUP BY year
ORDER BY year;
```

### Service Utilization

```sql
-- Average service utilization (as % of total patients) at health centers serving less than 2,500 patients each year.
SELECT s.year,
       ROUND(AVG(s.medical)*100, 2) AS avg_medical_pct,
       ROUND(AVG(s.dental)*100, 2) AS avg_dental_pct,
       ROUND(AVG(s.mental_health)*100, 2) AS avg_mental_health_pct
FROM services AS s
JOIN patient_age_race AS p ON s.hc_name = p.hc_name AND s.year = p.year
WHERE p.total_patients < 2500
GROUP BY s.year
ORDER BY s.year;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Comparing mental health utilization and depression screening rates.
-- (This query excludes health centers that do not provide mental health services.)
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
JOIN services AS s ON d.hc_name = s.hc_name AND d.year = s.year
WHERE s.mental_health > 0
GROUP BY d.dep_screening_bin
ORDER BY d.dep_screening_bin;
```
# INSERT SCREENSHOT OF OUTPUT HERE

```sql
-- Drop temporary table created for above queries
DROP TEMPORARY TABLE state_names;
```
