-- =====================================================================
-- STEP 3: Core analysis queries (MySQL version)
-- =====================================================================

USE churn_analysis;

CREATE OR REPLACE VIEW v_overall_churn AS
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn;

CREATE OR REPLACE VIEW v_churn_by_contract AS
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

CREATE OR REPLACE VIEW v_churn_by_tenure AS
SELECT
    tenure_bucket,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn
GROUP BY tenure_bucket
ORDER BY MIN(tenure);

CREATE OR REPLACE VIEW v_churn_by_payment AS
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

CREATE OR REPLACE VIEW v_churn_by_support AS
SELECT
    InternetService,
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn
GROUP BY InternetService, TechSupport
ORDER BY churn_rate_pct DESC;

CREATE OR REPLACE VIEW v_cltv_by_contract AS
SELECT
    Contract,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(AVG(tenure), 1) AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges) * AVG(tenure), 2) AS estimated_cltv
FROM clean_telco_churn
GROUP BY Contract;

CREATE OR REPLACE VIEW v_revenue_at_risk AS
SELECT
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS mrr_lost_to_churn,
    ROUND(SUM(MonthlyCharges), 2) AS total_mrr,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) / SUM(MonthlyCharges), 2) AS pct_revenue_at_risk
FROM clean_telco_churn;

CREATE OR REPLACE VIEW v_revenue_at_risk_by_contract AS
SELECT
    Contract,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS mrr_lost_to_churn,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_customers
FROM clean_telco_churn
GROUP BY Contract
ORDER BY mrr_lost_to_churn DESC;

CREATE OR REPLACE VIEW v_churn_by_demographics AS
SELECT
    senior_citizen,
    Dependents,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM clean_telco_churn
GROUP BY senior_citizen, Dependents;
