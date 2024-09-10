# Health Center Data ELT

**Objective:** Extract, load, and transform (ELT) the UDS dataset to prepare it for analysis.

**Data:** 2018-2023 Uniform Data System dataset (from the [HRSA website](data.HRSA.gov))

**Tools:** SQL (MySQL)
<br><br>

## Summary
In this ELT project, I created a MySQL database for storing and querying community health center data. Once the data was loaded into the appropriate tables, I used SQL to clean and manipulate the data to prepare it for future analysis. After the data had been wrangled, I queried the database to perform some high level data anlaysis.

**Note:** This page presents the project in a reader-friendly format, with some query outputs. All of the raw .sql files are also available in this repository.

## Table of Contents
1. Dataset
2. Create Tables
3. Load Data
4. Data Wrangling
5. Data Validation
6. Data Querying/Data Analysis

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
After the tables were created, I loaded teh data from the .csv files into their corresponding tables.

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
