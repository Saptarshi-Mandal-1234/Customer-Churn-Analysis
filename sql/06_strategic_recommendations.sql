-- =====================================================================
-- STEP 6: Strategic flag-level summary (MySQL version)
-- Aggregates impact PER FLAG (not per customer) - answers:
-- "If we fix this ONE thing, how many customers and how much revenue
-- does it touch?" This powers the new Strategic Recommendations pages.
-- =====================================================================

USE churn_analysis;

CREATE OR REPLACE VIEW v_flag_summary AS
SELECT
    'flag_month_to_month' AS flag_name,
    SUM(flag_month_to_month) AS customers_affected,
    SUM(CASE WHEN flag_month_to_month = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_affected,
    ROUND(SUM(CASE WHEN flag_month_to_month = 1 THEN MonthlyCharges ELSE 0 END), 2) AS mrr_exposed
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_new_customer',
    SUM(flag_new_customer),
    SUM(CASE WHEN flag_new_customer = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_new_customer = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_no_tech_support',
    SUM(flag_no_tech_support),
    SUM(CASE WHEN flag_no_tech_support = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_no_tech_support = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_no_online_security',
    SUM(flag_no_online_security),
    SUM(CASE WHEN flag_no_online_security = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_no_online_security = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_high_charge_low_tenure',
    SUM(flag_high_charge_low_tenure),
    SUM(CASE WHEN flag_high_charge_low_tenure = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_high_charge_low_tenure = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_electronic_check',
    SUM(flag_electronic_check),
    SUM(CASE WHEN flag_electronic_check = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_electronic_check = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags

UNION ALL
SELECT
    'flag_fiber_no_support',
    SUM(flag_fiber_no_support),
    SUM(CASE WHEN flag_fiber_no_support = 1 AND Churn = 'Yes' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN flag_fiber_no_support = 1 THEN MonthlyCharges ELSE 0 END), 2)
FROM customer_risk_flags;

-- =====================================================================
-- v_strategic_recommendations: joins the flag summary to the playbook,
-- and adds a "churned_mrr_exposed" figure = the actual $ currently being
-- lost from customers matching that flag who HAVE churned. This is the
-- number that answers "how much money is this problem costing us right now."
-- =====================================================================

CREATE OR REPLACE VIEW v_strategic_recommendations AS
SELECT
    f.flag_name,
    p.observation,
    p.likely_cause,
    p.recommended_action,
    p.expected_impact,
    p.priority,
    f.customers_affected,
    f.churned_affected,
    ROUND(100.0 * f.churned_affected / NULLIF(f.customers_affected, 0), 2) AS flag_churn_rate_pct,
    f.mrr_exposed
FROM v_flag_summary f
JOIN recommendation_playbook p ON p.flag_name = f.flag_name
ORDER BY f.mrr_exposed DESC;

-- Check the output - this is your ranked strategic priority list
SELECT * FROM v_strategic_recommendations;
