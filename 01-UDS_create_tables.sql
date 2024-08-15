/* CREATE TABLES FOR UDS DATA. */

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