from pathlib import Path
import csv, json
from collections import defaultdict
root = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader((root / "data/telco-churn.csv").open(encoding="utf-8-sig")))
assert len({r["customerID"] for r in rows}) == len(rows)
groups = defaultdict(list)
for r in rows:
    groups[r["Contract"]].append(r)
summary = {"customers": len(rows), "churned": sum(r["Churn"] == "Yes" for r in rows), "blank_total_charges": sum(not r["TotalCharges"].strip() for r in rows), "contracts": {k: {"customers":len(v),"churn_rate":sum(r["Churn"] == "Yes" for r in v)/len(v)} for k,v in groups.items()}}
(root / "reports").mkdir(exist_ok=True)
(root / "reports/summary.json").write_text(json.dumps(summary, indent=2))
print(json.dumps(summary, indent=2))
