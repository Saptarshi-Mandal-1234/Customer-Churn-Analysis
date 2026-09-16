-- =====================================================================
-- STEP 4: Risk Flags table (MySQL version)
-- Tags every customer with the specific negative pattern(s) they match,
-- and a composite risk_score (0-7). Validated: churn rate climbs from
-- 3% (score 0) to 78.5% (score 7) - proof these flags are predictive.
-- =====================================================================

USE churn_analysis;

DROP TABLE IF EXISTS customer_risk_flags;

CREATE TABLE customer_risk_flags AS
SELECT
    customerID,
    Churn,
    Contract,
    tenure,
    tenure_bucket,
    MonthlyCharges,
    TechSupport,
    OnlineSecurity,
    InternetService,
    PaymentMethod,

    CASE WHEN Contract = 'Month-to-month' THEN 1 ELSE 0 END AS flag_month_to_month,
    CASE WHEN tenure <= 6 THEN 1 ELSE 0 END AS flag_new_customer,
    CASE WHEN TechSupport = 'No' AND InternetService != 'No' THEN 1 ELSE 0 END AS flag_no_tech_support,
    CASE WHEN OnlineSecurity = 'No' AND InternetService != 'No' THEN 1 ELSE 0 END AS flag_no_online_security,
    CASE WHEN MonthlyCharges > 70 AND tenure <= 12 THEN 1 ELSE 0 END AS flag_high_charge_low_tenure,
    CASE WHEN PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END AS flag_electronic_check,
    CASE WHEN InternetService = 'Fiber optic' AND TechSupport = 'No' AND OnlineSecurity = 'No'
         THEN 1 ELSE 0 END AS flag_fiber_no_support,

    (CASE WHEN Contract = 'Month-to-month' THEN 1 ELSE 0 END) +
    (CASE WHEN tenure <= 6 THEN 1 ELSE 0 END) +
    (CASE WHEN TechSupport = 'No' AND InternetService != 'No' THEN 1 ELSE 0 END) +
    (CASE WHEN OnlineSecurity = 'No' AND InternetService != 'No' THEN 1 ELSE 0 END) +
    (CASE WHEN MonthlyCharges > 70 AND tenure <= 12 THEN 1 ELSE 0 END) +
    (CASE WHEN PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END) +
    (CASE WHEN InternetService = 'Fiber optic' AND TechSupport = 'No' AND OnlineSecurity = 'No' THEN 1 ELSE 0 END)
    AS risk_score

FROM clean_telco_churn;

SELECT
    risk_score,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM customer_risk_flags
GROUP BY risk_score
ORDER BY risk_score DESC;
