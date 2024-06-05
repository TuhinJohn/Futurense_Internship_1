-- PS-1 HARIKA
SELECT
    CASE
        WHEN YEAR(CURDATE()) - YEAR(P.dob) - IF(STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(P.dob), '-', DAY(P.dob)), '%Y-%c-%e') > CURDATE(), 1, 0) BETWEEN 0 AND 14 THEN 'Children'
        WHEN YEAR(CURDATE()) - YEAR(P.dob) - IF(STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(P.dob), '-', DAY(P.dob)), '%Y-%c-%e') > CURDATE(), 1, 0) BETWEEN 15 AND 24 THEN 'Youth'
        WHEN YEAR(CURDATE()) - YEAR(P.dob) - IF(STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(P.dob), '-', DAY(P.dob)), '%Y-%c-%e') > CURDATE(), 1, 0) BETWEEN 25 AND 64 THEN 'Adults'
        ELSE 'Seniors'
    END AS AgeCategory, COUNT(T.treatmentID) AS NumberOfTreatments
FROM Patient P JOIN Treatment T ON P.patientID = T.patientID
WHERE YEAR(T.date) = 2022
GROUP BY AgeCategory;


-- PS-2 AKASH
SELECT
    D.diseaseName,
    COUNT(CASE WHEN Per.gender = 'Male' THEN 1 END) AS MaleCount,
    COUNT(CASE WHEN Per.gender = 'Female' THEN 1 END) AS FemaleCount,
    IFNULL(COUNT(CASE WHEN Per.gender = 'Male' THEN 1 END) / NULLIF(COUNT(CASE WHEN Per.gender = 'Female' THEN 1 END), 0), 0) AS MaleToFemaleRatio
FROM Treatment T JOIN Disease D ON T.diseaseID = D.diseaseID JOIN Patient P ON T.patientID = P.patientID JOIN Person Per ON P.patientID = Per.personID
GROUP BY D.diseaseName ORDER BY MaleToFemaleRatio DESC;


-- PS-3 HARSHITHA
SELECT
    Per.gender,
    COUNT(DISTINCT T.treatmentID) AS NumberOfTreatments,
    COUNT(DISTINCT C.claimID) AS NumberOfClaims,
    IFNULL(COUNT(DISTINCT C.claimID) / NULLIF(COUNT(DISTINCT T.treatmentID), 0), 0) AS TreatmentToClaimRatio
FROM
    Treatment T
    JOIN Patient P ON T.patientID = P.patientID
    JOIN Person Per ON P.patientID = Per.personID
    LEFT JOIN Claim C ON T.claimID = C.claimID
GROUP BY Per.gender
ORDER BY TreatmentToClaimRatio DESC;
    
    
-- PS-4 NEEV SHAH
SELECT
    PH.pharmacyName,
    COUNT(DISTINCT M.medicineID) AS NumberOfMedicines,
    SUM(M.maxPrice) AS TotalMaxRetailPrice,
    SUM(M.maxPrice * (1 - (M.governmentDiscount / 100))) AS TotalPriceAfterGovDiscount
FROM
    Pharmacy PH
    JOIN Prescription PR ON PH.pharmacyID = PR.pharmacyID
    JOIN Contain C ON PR.prescriptionID = C.prescriptionID
    JOIN Medicine M ON C.medicineID = M.medicineID
GROUP BY
    PH.pharmacyName
ORDER BY
    PH.pharmacyName;
    

-- PS-5 NEEV SHAH
SELECT PH.pharmacyName, MAX(medicine_count) AS MaxMedicines, MIN(medicine_count) AS MinMedicines,
    AVG(medicine_count) AS AvgMedicines
FROM (
    SELECT PR.pharmacyID, COUNT(C.medicineID) AS medicine_count
    FROM Prescription PR JOIN Contain C ON PR.prescriptionID = C.prescriptionID
    GROUP BY PR.prescriptionID
) AS PrescriptionMedicineCounts
JOIN Pharmacy PH ON PrescriptionMedicineCounts.pharmacyID = PH.pharmacyID
GROUP BY PH.pharmacyName
ORDER BY PH.pharmacyName;



