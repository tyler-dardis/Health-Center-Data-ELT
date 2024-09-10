# Health Center Data ELT

**Objective:** Extract, load, and transform (ELT) the UDS dataset to prepare it for analysis.

**Data:** 2018-2023 Uniform Data System dataset (from the [HRSA website](data.HRSA.gov))

**Tools/Languages:** SQL database (and minimal python)

## Summary
In this ELT project, I created a MySQL database for storing and querying community health center data. Once the data was loaded into the appropriate tables, I used SQL to wrangle the data to prepare it for future analysis. After the ELT process, I queried the database to perform some high level data analysis.

**Note:** This page presents the project in a reader-friendly format, with some query results. All of the raw .sql files are also available in this repository.

## Table of Contents
1. [Dataset](https://github.com/tyler-dardis/Health-Center-Data-ELT#dataset)
2. [Create Tables](https://github.com/tyler-dardis/Health-Center-Data-ELT#create-tables)
3. [Load Data](https://github.com/tyler-dardis/Health-Center-Data-ELT#load-data)
4. [Data Wrangling](https://github.com/tyler-dardis/Health-Center-Data-ELT#data-wrangling)
5. [Data Validation](https://github.com/tyler-dardis/Health-Center-Data-ELT#data-validation)
6. [Data Querying/Analysis](https://github.com/tyler-dardis/Health-Center-Data-ELT#data-queryinganalysis)
7. [Related Projects](https://github.com/tyler-dardis/Health-Center-Data-ELT#related-projects)

## Dataset
The Health Resources and Services Administration (HRSA) oversees the national health center program, which includes 1,496 health centers serving 32.5 million patients across the U.S. In overseeing this program, HRSA collects financial and clinical data from health centers via the annual Uniform Data System (UDS) report. While some of the data reported is proprietary and not publicly available, HRSA publishes some of the dataset. This dataset is available for download on their website in Excel format and includes the most recent five years of data. (I downloaded the dataset before and after the publication of the 2023 UDS report, so my data includes six years.)

The data is available as two separate downloads, one for each of the two health center types, Federally Qualified Health Centers (FQHCs) and Look-Alike health centers. I've combined these into the same tables, adding 'hc_type' columns to differentiate between the two. (For those unfamiliar with these terms, a health center's type indicates their federal funding status. FQHCs receive HRSA service grants, while Look-Alikes do not.)

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
For each table storing annual data (all tables except 'sites'), I used the 'hc_name' and 'year' columns together as the composite primary key. However, some health centers use the same 'hc_name'. To ensure that each has a unique 'hc_name', I used the following queries to add the health center's 'state' to 'hc_name' for each duplicate, differentiating them. (This step was necessary to avoid errors when establishing the primary keys.)

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
#### Query Result:
| patient_count_variance |
|------------------------|
| 0                      |

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

Phone numbers were also not reported in a consistent format.
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

### Age Range Count Validation
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
#### Query Result:
| year  | SUM(total_patients) | SUM(children_count) | SUM(adults_18to64_count) | SUM(adults_over64_count) |
|-------|----------------|----------------|--------------------|----------------------|
| 2018  | 28379680      | 8736509      | 17041599         | 2601572            |
| 2019  | 29836613      | 9204942      | 17767170         | 2864501            |
| 2020  | 28590897      | 7872234      | 17786985         | 2931650            |
| 2021  | 30193278      | 8635363      | 18268669         | 3289246            |
| 2022  | 30517276      | 8824109      | 18137909         | 3555258            |
| 2023  | 31277341      | 9110850      | 18458338         | 3708153            |

### Payer Type Count Validation
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
#### Query Result:
| year  | SUM(uninsured_count) | SUM(medicaid_count) | SUM(medicare_count) | SUM(other_payer_count) |
|-------|----------------------|---------------------|---------------------|------------------------|
| 2018  | 6419472              | 13905805            | 2741037             | 5313366                |
| 2019  | 6783710              | 14380852            | 2927781             | 5744270                |
| 2020  | 6239686              | 13399491            | 2973387             | 5978309                |
| 2021  | 6137142              | 14603356            | 3213947             | 6238826                |
| 2022  | 5681091              | 15331626            | 3330416             | 6174121                |
| 2023  | 5601394              | 15777227            | 3433995             | 6464702                |

### Service Type Count Validation
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
#### Query Result:
| year  | SUM(medical_count) | SUM(dental_count) | SUM(mental_health_count) | SUM(substance_abuse_count) | SUM(vision_count) | SUM(enabling_count) |
|-------|--------------------|-------------------|--------------------------|----------------------------|-------------------|---------------------|
| 2018  | 23827122            | 6406667           | 2249876                  | 223390                     | 746087            | 2593393             |
| 2019  | 25029835            | 6712204           | 2581706                  | 325732                     | 828977            | 2608861             |
| 2020  | 24529374            | 5155474           | 2512198                  | 294387                     | 612035            | 2085776             |
| 2021  | 25759024            | 5700965           | 2659248                  | 285394                     | 769117            | 2241376             |
| 2022  | 25915807            | 6019752           | 2729559                  | 298387                     | 827941            | 2377090             |
| 2023  | 26581300            | 6382904           | 2790220                  | 293880                     | 920498            | 2555152             |

### Cost and Grant Expenditure Validation
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
#### Query Result:
| year  | SUM(total_cost) | SUM(svc_grant_exp) | total_cost_per_patient |
|-------|-----------------|--------------------|------------------------|
| 2018  | 28100675862      | 4718365832         | 990.17                 |
| 2019  | 31161368639      | 4929883133         | 1044.40                |
| 2020  | 33074410001      | 4734433643         | 1156.82                |
| 2021  | 36793239742      | 5181329158         | 1218.59                |
| 2022  | 40863346675      | 5042113995         | 1339.02                |
| 2023  | 46011772825      | 5078647217         | 1471.09                |

### Conclusion After Validating:
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
       ROUND(SUM(children_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100, 2) AS pct_children,
       ROUND(SUM(adults_18to64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100, 2) AS pct_adults_18to64,
       ROUND(SUM(adults_over64_count)/(SUM(children_count)+SUM(adults_18to64_count)+SUM(adults_over64_count))*100, 2) AS pct_adults_over64
FROM patient_age_race
WHERE hc_type = 'FQHC'
GROUP BY year;
```
#### Query Result:
| year | pct_children | pct_adults_18to64 | pct_adults_over64 |
|------|--------------|-------------------|-------------------|
| 2018 | 30.78        | 60.05             | 9.17              |
| 2019 | 30.85        | 59.55             | 9.60              |
| 2020 | 27.53        | 62.21             | 10.25             |
| 2021 | 28.60        | 60.51             | 10.89             |
| 2022 | 28.92        | 59.43             | 11.65             |
| 2023 | 29.13        | 59.02             | 11.86             |


```sql
-- FQHC patient age distribution by state (5-year average)
SELECT s.state_name,
       ROUND(SUM(p.children_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100, 2) AS pct_children,
       ROUND(SUM(p.adults_18to64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100, 2) AS pct_adults_18to64,
       ROUND(SUM(p.adults_over64_count)/(SUM(p.children_count)+SUM(p.adults_18to64_count)+SUM(p.adults_over64_count))*100, 2) AS pct_adults_over64
FROM patient_age_race AS p
JOIN state_names AS s ON p.state = s.state
WHERE p.year BETWEEN 2019 AND 2023
  AND p.hc_type = 'FQHC'
  AND s.state_type = 'state'
GROUP BY s.state_name
ORDER BY s.state_name;
```
#### Query Result:
| state_name              | pct_children | pct_adults_18to64 | pct_adults_over64 |
|-------------------------|--------------|-------------------|-------------------|
| Alabama             | 23.94        | 65.68             | 10.37             |
| Alaska              | 23.67        | 60.48             | 15.84             |
| Arizona             | 29.10        | 58.19             | 12.70             |
| Arkansas            | 25.30        | 61.49             | 13.20             |
| California          | 30.06        | 60.35             | 9.59              |
| Colorado            | 30.36        | 60.68             | 8.96              |
| Connecticut         | 32.10        | 59.20             | 8.70              |
| Delaware            | 24.71        | 65.87             | 9.43              |
| District of Columbia| 25.39        | 66.79             | 7.81              |
| Florida             | 35.09        | 55.35             | 9.56              |
| Georgia             | 24.60        | 63.82             | 11.59             |
| Hawaii              | 29.70        | 56.01             | 14.29             |
| Idaho               | 22.02        | 63.10             | 14.88             |
| Illinois            | 32.69        | 59.95             | 7.36              |
| Indiana             | 36.78        | 55.76             | 7.46              |
| Iowa                | 31.73        | 60.51             | 7.77              |
| Kansas              | 33.50        | 55.76             | 10.74             |
| Kentucky            | 29.67        | 58.43             | 11.90             |
| Louisiana           | 25.59        | 65.62             | 8.79              |
| Maine               | 20.20        | 56.41             | 23.39             |
| Maryland            | 27.47        | 62.26             | 10.28             |
| Massachusetts       | 21.05        | 66.47             | 12.48             |
| Michigan            | 26.89        | 61.42             | 11.68             |
| Minnesota           | 24.04        | 64.15             | 11.81             |
| Mississippi         | 25.02        | 62.11             | 12.87             |
| Missouri            | 35.01        | 55.67             | 9.31              |
| Montana             | 17.12        | 65.48             | 17.40             |
| Nebraska            | 31.74        | 61.02             | 7.24              |
| Nevada              | 25.70        | 64.20             | 10.10             |
| New Hampshire       | 22.34        | 59.47             | 18.19             |
| New Jersey          | 33.20        | 59.73             | 7.08              |
| New Mexico          | 20.54        | 61.57             | 17.89             |
| New York            | 28.91        | 60.38             | 10.72             |
| North Carolina      | 20.84        | 64.55             | 14.61             |
| North Dakota        | 29.77        | 58.05             | 12.18             |
| Ohio                | 27.80        | 61.47             | 10.73             |
| Oklahoma            | 29.45        | 57.70             | 12.85             |
| Oregon              | 25.63        | 62.18             | 12.18             |
| Pennsylvania        | 27.90        | 59.47             | 12.63             |
| Rhode Island        | 26.29        | 63.56             | 10.15             |
| South Carolina      | 24.92        | 59.62             | 15.46             |
| South Dakota        | 29.35        | 54.38             | 16.28             |
| Tennessee           | 22.31        | 65.30             | 12.39             |
| Texas               | 35.59        | 56.22             | 8.19              |
| Utah                | 26.87        | 63.77             | 9.36              |
| Vermont             | 17.62        | 58.01             | 24.37             |
| Virginia            | 23.26        | 61.28             | 15.47             |
| Washington          | 29.85        | 60.40             | 9.74              |
| West Virginia       | 24.87        | 57.57             | 17.56             |
| Wisconsin           | 33.94        | 56.16             | 9.90              |
| Wyoming             | 22.93        | 61.91             | 15.16             |

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
#### Query Result:
| hc_name                                          | city         | state | hc_type | pct_race_ethno_minority |
|-------------------------------------------------|--------------|-------|---------|-------------------------|
| FAMILY HEALTH CARE CENTERS OF GREATER LOS ANGELES, INC. | BELL GARDENS | CA    | FQHC    | 100                     |
| CALI MED CORPORATION                            | SOUTH GATE   | CA    | Look-Alike | 100                     |
| URBAN HEALTH PLAN, INC.                         | BRONX        | NY    | FQHC    | 99.74                   |
| SOUTH CAROLINA PRIMARY HEALTH CARE ASSOCIATION  | COLUMBIA     | SC    | FQHC    | 99.71                   |
| MORRIS HEIGHTS HEALTH CENTER                    | BRONX        | NY    | FQHC    | 99.52                   |
| BROWNSVILLE COMMUNITY DEVELOPMENT CORP.         | BROOKLYN     | NY    | FQHC    | 99.52                   |
| QUALITY COMMUNITY HEALTH CARE, INC.             | PHILADELPHIA | PA    | FQHC    | 99.49                   |
| PROTEUS EMPLOYMENT OPPORTUNITIES, INC.          | DES MOINES   | IA    | FQHC    | 99.48                   |
| MAINE MOBILE HEALTH PROGRAM INC.                 | AUGUSTA      | ME    | FQHC    | 99.37                   |
| LA CLINICA DEL PUEBLO                           | WASHINGTON   | DC    | FQHC    | 99.29                   |

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
#### Query Result:
| territory_name             | pts_2018 | pts_2019 | pts_2020 | pts_2021 | pts_2022 | pts_2023 |
|----------------------------|----------|----------|----------|----------|----------|----------|
| Puerto Rico                | 392925   | 425830   | 377472   | 413219   | 446903   | 466994   |
| American Samoa             | 16172    | 20517    | 13308    | 11117    | 22646    | 25018    |
| Federated States of Micronesia | 26781   | 25479    | 27360    | 21288    | 26910    | 20890    |
| U.S. Virgin Islands        | 17650    | 19214    | 14914    | 15930    | 16895    | 15292    |
| Republic of Palau          | 14728    | 14383    | 14019    | 14576    | 13684    | 12939    |
| Guam                       | 11874    | 11592    | 8141     | 8012     | 8698     | 8551     |
| Marshall Islands           | 7779     | 7854     | 7703     | 7804     | 6909     | 6321     |
| Northern Mariana Islands   | 1630     | 1855     | 1875     | 2445     | 3221     | 3725     |

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
#### Query Result:
| hc_name                             | city      | state | total_patients | cervical_cancer | adult_tobacco_use | colorectal_cancer | depression | breast_cancer | hiv    |
|-------------------------------------|-----------|-------|----------------|------------------|-------------------|-------------------|------------|---------------|--------|
| ALTA MED HEALTH SERVICES CORPORATION | COMMERCE | CA    | 276326         | 69.51            | 92.43             | 54.8              | 82.36      | 63.59         | 54.35  |
| FAMILY HEALTHCARE NETWORK           | VISALIA   | CA    | 238703         | 57.72            | 95.09             | 40.92             | 88.71      | 53.11         | 54.51  |
| SUN RIVER HEALTH, INC.              | PEEKSKILL | NY    | 234160         | 65.99            | 82.41             | 41.56             | 59.62      | 55.21         | 67.78  |
| SEA-MAR COMMUNITY HEALTH CENTER     | SEATTLE   | WA    | 221269         | 47.56            | 91.29             | 35.75             | 82.52      | 50.47         | 39.74  |
| DENVER HEALTH & HOSPITAL AUTHORITY  | DENVER    | CO    | 199757         | 61.2             | 90.15             | 48.81             | 58.49      | 72.57         | 57.96  |

```sql
-- Percentage of FQHC patients with hypertension, diabetes, and asthma (5 year average)
SELECT ROUND(AVG(hypertension)*100, 2) AS hypertension_pct,
       ROUND(AVG(diabetes)*100, 2) AS diabetes_pct,
       ROUND(AVG(asthma)*100, 2) AS asthma_pct,
       ROUND(AVG(hiv)*100, 2) AS hiv_pct
FROM clinical_data
WHERE year BETWEEN 2019 AND 2023;
```
#### Query Result:
| hypertension_pct | diabetes_pct | asthma_pct | hiv_pct |
|------------------|--------------|------------|---------|
| 30.16            | 15.69        | 5.2        | 1.54    |

### Costs and Grant Expenditures

```sql
-- Percentage of total costs funded by service grants each year
SELECT year,
       ROUND(SUM(svc_grant_exp)/SUM(total_cost)*100, 2) AS pct_grant_funded
FROM cost
WHERE hc_type = 'FQHC'
GROUP BY year;
```
#### Query Result:
| year | pct_grant_funded |
|------|------------------|
| 2018 | 16.79            |
| 2019 | 15.82            |
| 2020 | 14.31            |
| 2021 | 14.08            |
| 2022 | 12.34            |
| 2023 | 11.04            |

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
#### Query Result:
| state_name      | grant_exp_per_patient |
|-----------------|------------------------|
| Alaska          | 672.48                 |
| Montana         | 366.57                 |
| Delaware        | 343.29                 |
| North Dakota    | 324.27                 |
| New Hampshire   | 295.18                 |

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
#### Query Result:
| year | avg_medicaid_pct | avg_medicare_pct | avg_other_payer_pct | avg_uninsured_pct |
|------|------------------|------------------|---------------------|-------------------|
| 2018 | 49.97            | 8.46             | 12.92               | 28.65             |
| 2019 | 49.47            | 8.46             | 13.52               | 28.55             |
| 2020 | 48.77            | 9.17             | 14.71               | 27.57             |
| 2021 | 49.00            | 9.40             | 15.02               | 26.75             |
| 2022 | 51.74            | 9.69             | 14.55               | 24.24             |
| 2023 | 52.31            | 9.94             | 15.61               | 22.31             |

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
#### Query Result:
| year | fqhc_count |
|------|------------|
| 2018 | 569        |
| 2019 | 614        |
| 2020 | 672        |
| 2021 | 636        |
| 2022 | 641        |
| 2023 | 676        |

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
#### Query Result:
| year | avg_medical_pct | avg_dental_pct | avg_mental_health_pct |
|------|------------------|----------------|------------------------|
| 2018 | 88.33            | 14.87          | 11.35                  |
| 2019 | 87.83            | 15.22          | 13.57                  |
| 2020 | 88.12            | 13.76          | 12.97                  |
| 2021 | 86.6             | 15.75          | 13.37                  |
| 2022 | 86.12            | 15.78          | 13.19                  |
| 2023 | 86.7             | 15.61          | 15.24                  |

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
#### Query Result:
| dep_screening_bin | avg_mental_health_utilization |
|-------------------|-------------------------------|
| 0_to_24_pct       | 11.43                         |
| 25_to_49_pct      | 10.34                         |
| 50_to_74_pct      | 10.63                         |
| 75_to_100_pct     | 10.58                         |

```sql
-- Drop temporary table created for above queries
DROP TEMPORARY TABLE state_names;
```

## Related Projects
After preparing this UDS data in my SQL database, I used the processed data in two other projects:
- [Health Center Dashboards](https://github.com/tyler-dardis/Health-Center-Dashboards) - Built two Tableau dashboards, one to visualize aggregated data at the national level, and a second to visualize data at the individual health center level (with an interactive dropdown, allowing the user to select any one health center).
- [Payer Mix Linear Regression](https://github.com/tyler-dardis/Payer-Mix-Linear-Regression) - Developed a linear regression model to predict payer mix percentages of health centers.
