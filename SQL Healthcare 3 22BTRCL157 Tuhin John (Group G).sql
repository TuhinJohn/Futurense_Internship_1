/*problem statement 11 , ADITI AV [22BTRCL009]*/
SELECT 
    p.pharmacyName,
    COUNT(*) AS total_prescriptions
FROM 
    pharmacy p
JOIN 
    prescription pr ON p.pharmacyID = pr.pharmacyID
JOIN 
    contain c ON pr.prescriptionID = c.prescriptionID
JOIN 
    medicine m ON c.medicineID = m.medicineID
JOIN 
    treatment t ON pr.treatmentID = t.treatmentID
WHERE 
    m.hospitalExclusive = 'S'
    AND YEAR(t.date) IN (2021, 2022)
GROUP BY 
    p.pharmacyName
ORDER BY 
    total_prescriptions DESC;

/*problem statement 12 , N. VENKATESHWARA RAO [22BTRCL108]*/
SELECT 
    ip.planName,
    ic.companyName,
    COUNT(t.treatmentID) AS treatment_count
FROM 
    claim c
JOIN 
    insuranceplan ip ON c.uin = ip.uin
JOIN 
    insurancecompany ic ON ip.companyID = ic.companyID
JOIN 
    treatment t ON c.claimID = t.claimID
GROUP BY 
    ip.planName, ic.companyName
ORDER BY 
    treatment_count DESC;

/*PROBLEM STATEMENT 13 , VENKATESH S [22BTRCL165]*/
SELECT IC.companyName, IP.planName, COUNT(T.treatmentID) AS numTreatments,
CASE
	WHEN COUNT(T.treatmentID) = MAX(COUNT(T.treatmentID)) OVER (PARTITION BY IC.companyName) THEN 'Most Claimed'
	WHEN COUNT(T.treatmentID) = MIN(COUNT(T.treatmentID)) OVER (PARTITION BY IC.companyName) THEN 'Least Claimed'
ELSE NULL
END AS ClaimStatus
FROM InsurancePlan IP
JOIN InsuranceCompany IC ON IP.companyID = IC.companyID
JOIN Claim CL ON IP.UIN = CL.UIN
JOIN Treatment T ON CL.claimID = T.claimID GROUP BY IC.companyName, IP.planName ORDER BY IC.companyName, ClaimStatus DESC, numTreatments DESC;

/*PROBLEM STATEMENT 14 , VENKATESH S [22BTRCL165]*/
SELECT A.state,
    COUNT(DISTINCT P.personID) AS numPeople,
    COUNT(DISTINCT Pat.spatientID) AS numPatients,
    COUNT(DISTINCT P.personID) / COUNT(DISTINCT Pat.patientID) AS peopleToPatientRatio
FROM Person P JOIN Address A ON P.addressID = A.addressID LEFT JOIN Patient Pat ON P.personID = Pat.patientID GROUP BY A.state ORDER BY peopleToPatientRatio;

/*PROBLEM STATEMENT 15 , ANUSHKA P URS [22BTRCL109]*/
SELECT 
    ph.pharmacyName,
    SUM(k.quantity) AS total_quantity
FROM 
    pharmacy ph
JOIN 
    address a ON ph.addressID = a.addressID
JOIN 
    prescription pr ON ph.pharmacyID = pr.pharmacyID
JOIN 
    keep k ON ph.pharmacyID = k.pharmacyID
JOIN 
    treatment t ON pr.treatmentID= t.treatmentID
JOIN 
    medicine m ON k.medicineID = m.medicineID
WHERE 
    a.state = 'AZ'
    AND m.taxCriteria = 'I'
    AND YEAR(t.date) = 2021
GROUP BY 
    ph.pharmacyName
ORDER BY 
    total_quantity DESC;