# Excel validation summary (values only, no customer rows)

The validation workbook stays local (see `excel/README.md`: Excel pivot caches can
retain row-level data). This file is the values-only record of what it checked.

Source workbooks (local, saved 17 Nov 2026): `InsightIQ_Repair_Diagnostic.xlsx` and
`InsightIQ_Validation_Corrected-e24a69f3.xlsx`. The Excel results are computed from an
independent import of the original CSV, not linked to SQL.

## Reconciliation log: SQL vs independent Excel recomputation (all PASS, difference 0)

| Metric | SQL result | Excel result | Status |
| --- | --- | --- | --- |
| Total customers | 7,043 | 7,043 | PASS |
| Churned customers | 1,869 | 1,869 | PASS |
| Retained customers | 5,174 | 5,174 | PASS |
| Churn rate (%) | 26.54 | 26.54 | PASS |
| Missing TotalCharges | 11 | 11 | PASS |
| MonthlyCharges sum | 456,116.60 | 456,116.60 | PASS |
| Known TotalCharges sum | 16,056,168.70 | 16,056,168.70 | PASS |
| Churned monthly charges | 139,130.85 | 139,130.85 | PASS |

Native PivotTables in the same workbook separately re-check the contract and tenure
band breakdowns.

## Data-quality checks in the workbook (all PASS)

- Blank customer IDs: 0
- Rows in duplicate ID groups: 0
- Numeric SeniorCitizen values: 7,043
- Numeric tenure values: 7,043 (range 0-72)
- Numeric MonthlyCharges values: 7,043
- Numeric TotalCharges values: 7,032 (= 7,043 - 11 blanks)
- Numeric churn flags: 7,043, binary 0/1 only
- Invalid Churn labels (anything but Yes/No): 0
- Blank TotalCharges: 11, all belonging to tenure-0 customers, kept blank (not zero-filled)
- Formula/cell errors across the raw data and helper columns: 0

## Independent re-run (20 Nov 2026)

All nine analysis queries in `sql/03_analysis.sql` were re-executed against the
verified cleaned CSV using a SQLite stand-in (not a fresh MySQL run), and a
cell-by-cell audit compared all 147,903 original CSV values against the cleaned
table: every figure matched and no unexplained difference was found.
