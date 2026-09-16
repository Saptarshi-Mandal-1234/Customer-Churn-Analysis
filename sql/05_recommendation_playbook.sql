-- =====================================================================
-- STEP 5: Recommendation Playbook (MySQL version)
-- The prescriptive engine: maps every risk flag to a diagnosis and a
-- specific recommended action. v_customer_recommendations joins every
-- customer to every recommendation they match, powering the dashboard's
-- click-to-see-recommendation panel.
-- =====================================================================

USE churn_analysis;

DROP TABLE IF EXISTS recommendation_playbook;

CREATE TABLE recommendation_playbook (
    flag_name           VARCHAR(50) PRIMARY KEY,
    observation          VARCHAR(200),
    likely_cause          VARCHAR(200),
    recommended_action     VARCHAR(300),
    expected_impact         VARCHAR(200),
    priority                 VARCHAR(10)
);

INSERT INTO recommendation_playbook VALUES
('flag_month_to_month',
 'Customer is on a month-to-month contract',
 'No lock-in period, low switching cost, easy to leave anytime',
 'Offer a discounted 1-year or 2-year contract upgrade (e.g. 10-15% off) before renewal date',
 'Month-to-month customers churn at the highest rate of all contract types',
 'High'),

('flag_new_customer',
 'Customer is within their first 6 months (onboarding window)',
 'Poor onboarding experience, unmet early expectations',
 'Trigger a structured onboarding check-in call/email at day 30, 60, and 90; offer a first-90-days loyalty discount',
 'Early-tenure churn is disproportionately high',
 'High'),

('flag_no_tech_support',
 'Customer has internet service but no tech support add-on',
 'Unresolved technical issues go unaddressed, leading to frustration',
 'Offer a free 3-month trial of the tech support add-on to at-risk segments',
 'Customers without tech support show a notably higher churn rate',
 'Medium'),

('flag_no_online_security',
 'Customer has internet service but no online security add-on',
 'Security/privacy concerns unaddressed, perceived lower service value',
 'Bundle online security free for the first 2 months as part of a retention offer',
 'Correlates with segments showing above-average churn',
 'Medium'),

('flag_high_charge_low_tenure',
 'Customer pays >$70/month but has been with the company <= 12 months',
 'Price shock relative to perceived value in early relationship stage',
 'Proactive outreach explaining value/bundle savings; offer a loyalty discount tied to a 1-year commitment',
 'Reduces price-driven early churn',
 'High'),

('flag_electronic_check',
 'Customer pays via electronic check',
 'Historically correlated with higher friction / lower engagement payment method',
 'Incentivize switch to auto-pay (credit card or bank transfer) with a small one-time bill credit',
 'Electronic check payers show the highest churn rate among all payment methods',
 'Medium'),

('flag_fiber_no_support',
 'Fiber optic customer with no tech support and no online security',
 'Higher expectations and technical complexity compound dissatisfaction',
 'Proactively bundle a support package for all new fiber signups at onboarding',
 'Typically the single highest-churn segment',
 'High');

CREATE OR REPLACE VIEW v_customer_recommendations AS
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_month_to_month'
WHERE c.flag_month_to_month = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_new_customer'
WHERE c.flag_new_customer = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_no_tech_support'
WHERE c.flag_no_tech_support = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_no_online_security'
WHERE c.flag_no_online_security = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_high_charge_low_tenure'
WHERE c.flag_high_charge_low_tenure = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_electronic_check'
WHERE c.flag_electronic_check = 1
UNION ALL
SELECT c.customerID, c.Churn, c.Contract, c.tenure_bucket, c.MonthlyCharges, c.risk_score,
       p.flag_name, p.observation, p.likely_cause, p.recommended_action, p.expected_impact, p.priority
FROM customer_risk_flags c
JOIN recommendation_playbook p ON p.flag_name = 'flag_fiber_no_support'
WHERE c.flag_fiber_no_support = 1;
