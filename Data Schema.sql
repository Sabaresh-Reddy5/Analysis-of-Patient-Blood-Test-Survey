/* -----------------------------------------------------
   1. CREATE DATABASE
------------------------------------------------------*/
CREATE DATABASE PatientBloodTestDB;
USE PatientBloodTestDB;


/* -----------------------------------------------------
   2. CREATE TABLES
------------------------------------------------------*/

/* 2.1 Patient Master Table */
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    PatientName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    Age INT,
    Contact VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* 2.2 Blood Test Table */
CREATE TABLE BloodTests (
    TestID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    TestDate DATE NOT NULL,
    Hemoglobin FLOAT,
    RBC_Count FLOAT,
    WBC_Count FLOAT,
    Platelets INT,
    SugarLevel FLOAT,
    Cholesterol FLOAT,
    Notes VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);


/* -----------------------------------------------------
   3. SAMPLE DATA INSERTION (ETL LOADED DATA)
------------------------------------------------------*/

/* Patient Data */
INSERT INTO Patients (PatientName, Gender, Age, Contact)
VALUES
('Rohan Kumar', 'Male', 34, '9876543210'),
('Priya Sharma', 'Female', 28, '9786543210'),
('Arun Singh', 'Male', 45, '9988776655'),
('Meena Devi', 'Female', 52, '9871200345');

/* Blood Test Records */
INSERT INTO BloodTests 
(PatientID, TestDate, Hemoglobin, RBC_Count, WBC_Count, Platelets, SugarLevel, Cholesterol, Notes)
VALUES
(1, '2025-01-10', 14.2, 4.8, 6000, 250000, 98, 180, 'Normal'),
(1, '2025-02-10', 13.5, 4.5, 7000, 240000, 110, 200, 'Slight sugar increase'),
(2, '2025-01-15', 12.0, 4.2, 8000, 300000, 90, 170, 'Normal'),
(3, '2025-01-20', 10.8, 3.8, 11000, 200000, 150, 220, 'High WBC'),
(4, '2025-02-05', 13.0, 4.4, 7000, 230000, 95, 160, 'Normal');
 

/* -----------------------------------------------------
   4. DATA CLEANING (T - Transform in ETL)
------------------------------------------------------*/

/* Replace NULL values with averages (example logic) */
UPDATE BloodTests 
SET Hemoglobin = (SELECT AVG(Hemoglobin) FROM BloodTests)
WHERE Hemoglobin IS NULL;

UPDATE BloodTests 
SET SugarLevel = 0
WHERE SugarLevel IS NULL;


/* -----------------------------------------------------
   5. EDA ANALYSIS QUERIES
------------------------------------------------------*/

/* 5.1 Patient count */
SELECT COUNT(*) AS TotalPatients
FROM Patients;

/* 5.2 Avg test values */
SELECT 
    AVG(Hemoglobin) AS AvgHemoglobin,
    AVG(RBC_Count) AS AvgRBC,
    AVG(WBC_Count) AS AvgWBC,
    AVG(SugarLevel) AS AvgSugar,
    AVG(Cholesterol) AS AvgCholesterol
FROM BloodTests;

/* 5.3 Identify patients with high sugar level (>120) */
SELECT 
    p.PatientName,
    b.SugarLevel,
    b.TestDate
FROM BloodTests b
JOIN Patients p ON p.PatientID = b.PatientID
WHERE b.SugarLevel > 120;

/* 5.4 Track patient health trend */
SELECT
    p.PatientName,
    b.TestDate,
    b.Hemoglobin,
    b.SugarLevel,
    b.Cholesterol
FROM BloodTests b
JOIN Patients p ON p.PatientID = b.PatientID
ORDER BY p.PatientName, b.TestDate;


/* -----------------------------------------------------
   6. CREATE VIEW FOR POWER BI
------------------------------------------------------*/
CREATE VIEW vw_PatientBloodReport AS
SELECT
    p.PatientName,
    p.Gender,
    p.Age,
    b.TestDate,
    b.Hemoglobin,
    b.RBC_Count,
    b.WBC_Count,
    b.Platelets,
    b.SugarLevel,
    b.Cholesterol,
    b.Notes
FROM BloodTests b
JOIN Patients p ON p.PatientID = b.PatientID;
