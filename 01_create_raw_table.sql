-- =====================================================================
-- STEP 1: Create raw staging table (MySQL version)
-- Database: churn_analysis
-- Dataset: Telco Customer Churn (Kaggle - IBM Sample Data Set)
-- Source: https://www.kaggle.com/datasets/blastchar/telco-customer-churn
-- =====================================================================

CREATE DATABASE IF NOT EXISTS churn_analysis;
USE churn_analysis;

DROP TABLE IF EXISTS raw_telco_churn;

CREATE TABLE raw_telco_churn (
    customerID          VARCHAR(20) PRIMARY KEY,
    gender               VARCHAR(10),
    SeniorCitizen        INT,
    Partner              VARCHAR(5),
    Dependents           VARCHAR(5),
    tenure                INT,
    PhoneService          VARCHAR(5),
    MultipleLines         VARCHAR(20),
    InternetService       VARCHAR(20),
    OnlineSecurity        VARCHAR(20),
    OnlineBackup          VARCHAR(20),
    DeviceProtection      VARCHAR(20),
    TechSupport           VARCHAR(20),
    StreamingTV            VARCHAR(20),
    StreamingMovies        VARCHAR(20),
    Contract               VARCHAR(20),
    PaperlessBilling       VARCHAR(5),
    PaymentMethod           VARCHAR(40),
    MonthlyCharges          DECIMAL(8,2),
    TotalCharges             VARCHAR(20),
    Churn                    VARCHAR(5)
);

-- IMPORT INSTRUCTIONS (MySQL Workbench):
-- Right-click "raw_telco_churn" -> Table Data Import Wizard
-- Browse to WA_Fn-UseC_-Telco-Customer-Churn.csv -> Use existing table -> import
-- IMPORTANT: on the column mapping screen, verify every row's target dropdown
-- matches its own source column name (a known Workbench bug can mis-map columns)
