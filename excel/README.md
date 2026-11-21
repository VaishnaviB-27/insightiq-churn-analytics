# Excel validation

Status: the validation workbook itself is intentionally not in the repository yet.

The workbook was built from the full dataset, and Excel files can keep row-level data
inside pivot caches even after a source sheet is deleted, so it stays local until it
can be checked properly.

What it contains locally: independent recomputation of the SQL results from the
original CSV (pivots and formulas) and a `Validation_Log` sheet reconciling the two
(metric, SQL value, Excel value, difference, status).

A values-only validation summary (aggregate metrics only, no customer rows) is in
`validation-summary.md` next to this file.
