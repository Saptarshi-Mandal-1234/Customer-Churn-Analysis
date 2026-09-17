# Dashboard Build Guide — Customer Churn Analysis with Prescriptive Recommendations

This guide assumes you've run all SQL scripts (01–05) and have these views/tables ready in `churn_analysis`:

- `v_overall_churn`
- `v_churn_by_contract`
- `v_churn_by_tenure`
- `v_churn_by_payment`
- `v_churn_by_support`
- `v_cltv_by_contract`
- `v_revenue_at_risk`
- `v_revenue_at_risk_by_contract`
- `customer_risk_flags`
- `recommendation_playbook`
- `v_customer_recommendations`  ← this is the key one for the prescriptive feature

---

## Connecting to MySQL

**Power BI:**
Get Data → More → Database → MySQL database → enter server (`localhost`), database `churn_analysis` → provide your MySQL username/password → Import mode (not DirectQuery, dataset is small).
Note: Power BI needs the **MySQL Connector/NET** driver installed on your machine for this to work — if the connector doesn't appear, download it from dev.mysql.com/downloads/connector/net/ first.

**Tableau:**
Connect → To a Server → MySQL → enter server (`localhost`), port `3306`, database `churn_analysis`, credentials → drag in the views listed above.
Note: Tableau needs the **MySQL ODBC driver** — if MySQL doesn't appear as an option, download the connector from tableau.com/support/drivers first.

---

## Page 1: Executive Summary

- KPI cards: Total Customers, Overall Churn Rate, MRR Lost to Churn, % Revenue at Risk (from `v_overall_churn`, `v_revenue_at_risk`)
- Bar chart: Churn rate by Contract type (`v_churn_by_contract`)
- Line/bar chart: Churn rate by Tenure bucket (`v_churn_by_tenure`) — shows the early-tenure risk window visually
- Donut: Churn rate by Payment Method (`v_churn_by_payment`)

## Page 2: Segment Deep-Dive

- Matrix/heatmap: Churn rate by InternetService × TechSupport (`v_churn_by_support`)
- Table: CLTV by contract type (`v_cltv_by_contract`)
- Bar chart: Revenue at risk by contract (`v_revenue_at_risk_by_contract`)

## Page 3: At-Risk Customer List + Recommendation Panel (the prescriptive feature)

This is the page that makes the project stand out. Build it as follows:

1. **Table/list visual**: pull from `customer_risk_flags`, sorted descending by `risk_score`. Columns: customerID, Contract, tenure, MonthlyCharges, risk_score.
2. **Filter/slicer**: risk_score (let the viewer filter to only "high risk" customers, e.g. risk_score >= 3)
3. **Detail panel**: when a customer row is selected/clicked, show a filtered table from `v_customer_recommendations` for that `customerID` — this displays:
   - Observation
   - Likely Cause
   - Recommended Action
   - Expected Impact
   - Priority (color-coded: red=High, amber=Medium, green=Low)

   **Power BI:** use a second table visual with a page-level or visual-level filter synced to the selected customerID (this happens automatically via cross-filtering if both visuals are on the same page and share the customerID field — just ensure `v_customer_recommendations` and `customer_risk_flags` are related on `customerID` in the model view).

   **Tableau:** use a dashboard action ("Filter" action) triggered on select, from the customer list sheet to a recommendations sheet built on `v_customer_recommendations`.

4. **Aggregate recommendation summary** (optional but strong addition): a bar chart counting how many customers are affected by each `flag_name` — this shows leadership which single intervention (e.g. "push annual contract upgrades") would have the biggest blanket impact across the whole at-risk population, not just one customer at a time.

## Page 4: What-If Revenue Simulator

Replicate the pattern from your HR project's What-If Cost Calculator:

- A slider/parameter for "% reduction in month-to-month churn"
- Calculated field: `MRR_saved = (v_revenue_at_risk_by_contract for Month-to-month) * (slider % / 100)`
- Display as a single KPI card that updates live as the slider moves: "Projected monthly revenue saved: $X"

**Power BI:** Use a "What if parameter" (Modeling tab → New Parameter → Numeric range 0–100) and a DAX measure referencing `SELECTEDVALUE(ParameterName)`.

**Tableau:** Use a Parameter (0–100, step 1) and a calculated field referencing `[Parameter]`.

---

## Naming convention for your portfolio

Call this feature explicitly in your README/LinkedIn post as a **"Rule-Based Prescriptive Recommendation Engine"** — this phrase signals to recruiters that you went beyond descriptive dashboards, which is exactly the differentiator you're going for.
