-- =====================================================================
-- STEP 2: Clean and standardize the raw data (MySQL version)
-- =====================================================================

USE churn_analysis;

DROP TABLE IF EXISTS clean_telco_churn;

CREATE TABLE clean_telco_churn AS
SELECT
    customerID,
    gender,
    CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END AS senior_citizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    CASE
        WHEN TRIM(TotalCharges) = '' THEN MonthlyCharges
        ELSE CAST(TotalCharges AS DECIMAL(10,2))
    END AS total_charges,
    Churn,
    CASE
        WHEN tenure <= 6  THEN '0-6 months'
        WHEN tenure <= 12 THEN '7-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_bucket
FROM raw_telco_churn;

SELECT COUNT(*) AS total_rows FROM clean_telco_churn;
SELECT COUNT(*) AS null_total_charges FROM clean_telco_churn WHERE total_charges IS NULL;
SELECT DISTINCT Churn FROM clean_telco_churn;
