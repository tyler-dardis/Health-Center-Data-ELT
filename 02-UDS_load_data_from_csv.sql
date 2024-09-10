/* LOAD DATA FROM CSV FILES INTO THE CORRESPONDING TABLES */

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
