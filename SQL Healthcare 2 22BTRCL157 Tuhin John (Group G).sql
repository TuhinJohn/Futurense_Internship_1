/*Problem Statement 6*/

WITH pharmacy_ratio AS (
  SELECT 
    city,
    COUNT(DISTINCT pharmacy_id) AS num_pharmacies,
    COUNT(*) AS num_prescriptions
  FROM prescriptions
  INNER JOIN pharmacy ON prescriptions.pharmacy_id = pharmacy.id
  GROUP BY city
)
SELECT 
  city,
  (num_prescriptions / CAST(num_pharmacies AS FLOAT)) AS pharmacy_to_prescription_ratio
FROM pharmacy_ratio
WHERE num_prescriptions > 100
ORDER BY pharmacy_to_prescription_ratio ASC
LIMIT 3;

/*Problem Statement 7*/

WITH city_disease_count AS (
  SELECT 
    a.city,
    d.name AS disease_name,
    COUNT(*) AS num_patients
  FROM patients p
  INNER JOIN address a ON p.address_id = a.id
  INNER JOIN treatment t ON p.patient_id = t.patient_id
  INNER JOIN disease d ON t.disease_id = d.id
  WHERE a.state = 'AL'  -- Filter for Alabama (AL)
  GROUP BY a.city, d.id
)
SELECT 
  city,
  disease_name,
  MAX(num_patients) OVER (PARTITION BY city) AS max_patients
FROM city_disease_count
ORDER BY city;

/*Problem Statement 8*/

WITH disease_claims AS (
  SELECT 
    d.name AS disease_name,
    ip.name AS insurance_plan,
    COUNT(*) AS num_claims
  FROM claim c
  INNER JOIN disease d ON c.disease_id = d.id
  INNER JOIN insurance_plan ip ON c.insurance_plan_id = ip.id
  GROUP BY d.id, ip.id
)
SELECT 
  disease_name,
  MAX(insurance_plan) AS most_claimed_plan,
  MIN(insurance_plan) AS least_claimed_plan
FROM (
  SELECT 
    disease_name,
    insurance_plan,
    num_claims,
    ROW_NUMBER() OVER (PARTITION BY disease_name ORDER BY num_claims DESC) AS most_claimed_rank,
    ROW_NUMBER() OVER (PARTITION BY disease_name ORDER BY num_claims ASC) AS least_claimed_rank
  FROM disease_claims
) AS ranked_claims
WHERE most_claimed_rank = 1 OR least_claimed_rank = 1
GROUP BY disease_name
ORDER BY disease_name;

/* Problem Statement 9*/

WITH household_diseases AS (
  SELECT 
    d.name AS disease_name,
    a.id AS address_id,
    COUNT(*) AS num_patients
  FROM patients p
  INNER JOIN address a ON p.address_id = a.id
  INNER JOIN treatment t ON p.patient_id = t.patient_id
  INNER JOIN disease d ON t.disease_id = d.id
  GROUP BY d.id, a.id
)
SELECT 
  disease_name,
  COUNT(DISTINCT address_id) AS num_multi_patient_households
FROM household_diseases
WHERE num_patients > 1
GROUP BY disease_name
ORDER BY num_multi_patient_households DESC;

/* Problem Statement 10*/

WITH treatment_claims AS (
  SELECT 
    a.state,
    t.id AS treatment_id,
    COUNT(*) AS num_treatments
  FROM claim c
  INNER JOIN treatment t ON c.treatment_id = t.id
  INNER JOIN patients p ON c.patient_id = p.patient_id
  INNER JOIN address a ON p.address_id = a.id
  WHERE c.claim_date >= '2021-04-01' AND c.claim_date <= '2022-03-31'  -- Filter date range
  GROUP BY a.state, t.id
)
SELECT 
  state,
  t.name AS treatment_name,
  SUM(num_treatments) AS total_treatments,
  SUM(num_claims) AS total_claims,
  CAST(SUM(num_treatments) AS FLOAT) / SUM(num_claims) AS treatment_to_claim_ratio
FROM treatment_claims
INNER JOIN treatment t ON treatment_claims.treatment_id = t.id
GROUP BY state, treatment_id
ORDER BY state, treatment_name;
