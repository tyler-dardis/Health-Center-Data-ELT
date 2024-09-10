/* DIFFERENTIATE DUPLICATES IN hc_name COLUMN */

-- For each table storing annual data (all tables except 'sites'), the 'hc_name' and 'year' columns will be used together as the composite primary key. However, some health centers have the same hc_name. To ensure that each has a unique hc_name, the following queries add the state to the hc_name for each duplicate, differentiating them. (This step is necessary to avoid errors when establishing the primary keys.)

CREATE TEMPORARY TABLE duplicate_hc_names AS
SELECT hc_name
FROM clinical_data
GROUP BY hc_name
HAVING COUNT(DISTINCT state) > 1;

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

-- The following query should return no records if no duplicates remain. (If this query DOES return some records, this means there are health centers using the same hc_name within the same state. Similar to the methodology above, 'city' could then be used to differentiate between the duplicates.)
SELECT hc_name
FROM clinical_data
GROUP BY hc_name
HAVING COUNT(year) > 6;


/* SET PRIMARY KEY FOR EACH TABLE. */

ALTER TABLE patient_age_race ADD PRIMARY KEY (hc_name, year);
ALTER TABLE clinical_data ADD PRIMARY KEY (hc_name, year);
ALTER TABLE cost ADD PRIMARY KEY (hc_name, year);
ALTER TABLE payer_mix_fpl ADD PRIMARY KEY (hc_name, year);
ALTER TABLE services ADD PRIMARY KEY (hc_name, year);
ALTER TABLE sites ADD PRIMARY KEY (bphc_id);
