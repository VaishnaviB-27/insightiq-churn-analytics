# Test records

`test_log.csv` - one row per check, with its method/source so nothing reads as more
than it was. TC01-TC07 ran inside the local Excel validation workbook (saved 17 Nov
2026, PASS values recorded there); TC01-TC05 were additionally re-verified from the
CSVs on 20 Nov 2026 (including a cell-by-cell audit of all 147,903 original values).
TC08-TC10 ran on the project laptop on 18 Nov 2026 with photo evidence. TC14-TC15 are
analysis-figure verifications re-run in a SQLite stand-in against the verified clean
CSV on 20 Nov 2026 - not fresh MySQL executions. TC11-TC13 are planned Power BI
checks and stay NOT RUN until executed; the log is updated only with real results.

`defect_log.csv` - real defects only. An empty log is a good outcome. The one entry
was found during on-laptop dashboard testing on 18 Nov 2026, fixed the same day, and
re-verified with photo evidence.
