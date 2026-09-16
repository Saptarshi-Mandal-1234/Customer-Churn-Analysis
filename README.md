# Customer Churn Analytics & Prescriptive Recommendation Engine

An end-to-end data analytics project that goes beyond descriptive reporting: it identifies *why* customers churn, scores every customer's individual risk, and automatically prescribes specific retention actions — at both the individual-customer and strategic-portfolio level.

**Stack:** Kaggle (data source) → MySQL (data modeling) → Power BI (visualization)

---

## The Problem

Most churn analysis projects stop at "here's the churn rate by segment." This project asks the next question every business actually needs answered: **for each at-risk customer or systemic risk factor, what should we specifically do about it, and what's the dollar value of fixing it?**

## Dataset

[Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (IBM Sample Data Set via Kaggle) — 7,043 telecom customers, 21 features covering demographics, account details, subscribed services, and churn status.

## What This Project Does

1. **Data Pipeline** — Raw CSV imported into MySQL, cleaned (handling edge cases like blank `TotalCharges` for zero-tenure customers), and modeled into analysis-ready views.

2. **Risk Scoring Engine** — Every customer is tagged against 7 evidence-based risk flags (e.g. month-to-month contract, no tech support, electronic check payment) and assigned a composite risk score (0-7). Validated against actual churn: customers at risk score 7 churn at **78.5%**, vs. **3%** at risk score 0 — proof the flags are genuinely predictive, not arbitrary.

3. **Prescriptive Recommendation Playbook** — Each risk flag maps to a specific diagnosis and recommended retention action in a structured playbook table, automatically joined to every customer via SQL views.

4. **Six-Page Interactive Dashboard**:
   - **Executive Summary** — top-line KPIs and churn drivers
   - **Segment Deep-Dive** — churn heatmaps, CLTV analysis, demographic breakdowns
   - **At-Risk Customer List + Recommendation Panel** — click any customer to see their personalized, matched retention recommendations
   - **Revenue Impact Simulator** — a live slider that models projected monthly/annual revenue savings from reducing month-to-month churn
   - **Strategic Summary** — ranks all 7 risk factors by revenue exposure, not just churn rate, surfacing where the real dollar impact hides
   - **Prioritized Action Plan** — a phased 90-day rollout plan derived directly from the data

## Key Findings

| Finding | Detail |
|---|---|
| Highest churn segment | Fiber optic customers with no tech support: **49.4%** churn rate |
| Highest revenue exposure | Missing online security add-on: **$264.8K/month** at risk |
| Contract effect | Month-to-month churn (**42.7%**) is ~15x higher than two-year contracts (**2.8%**) |
| CLTV gap | Month-to-month customers: **$1,197** lifetime value vs. **$3,448** for two-year customers |
| Combined opportunity | Addressing the top 3 risk factors alone resolves **$781K** (≈65%) of total identified revenue risk |

## Repository Structure

```
├── README.md
├── sql/
│   ├── 01_create_raw_table.sql        # staging table + import notes
│   ├── 02_clean_data.sql              # cleaning, type casting, tenure buckets
│   ├── 03_analysis_queries.sql        # churn rate, CLTV, revenue-at-risk views
│   ├── 04_risk_flags.sql              # per-customer risk scoring (validated)
│   ├── 05_recommendation_playbook.sql # the prescriptive engine
│   └── 06_strategic_recommendations.sql # portfolio-level flag aggregation
└── docs/
    └── screenshots/                   # dashboard page screenshots
```

## Tools Used

- **MySQL 8.0** — data cleaning, transformation, and view-based modeling
- **Power BI** — dashboard, DAX measures, what-if parameters
- **Kaggle** — source dataset

## Author

**Saptarshi Mandal** — B.Tech Computer Science (Data Analytics focus), Institute of Engineering and Management, Kolkata
[LinkedIn](https://www.linkedin.com/in/saptarshi-mandal-cs) · [GitHub](https://github.com/Saptarshi-Mandal-1234)
