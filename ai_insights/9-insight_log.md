# AI-assisted reporting: not implemented as a project feature

Status: not implemented. An optional AI-insight workflow was considered for this
project (exporting aggregate-only summary tables, having an LLM draft plain-English
findings from them under a strict numbers-only prompt, then verifying every quoted
number against SQL and Excel). That workflow is not part of this version: there is no
AI pipeline, API integration, or model anywhere in this repository, and the empty
verification table below is kept only to document the decision.

Separate, honest note: the author built this project with an AI assistant as a guide
(explaining steps, reviewing work, and helping draft prose such as the findings
wording in the README). That is ordinary development assistance, not a project
feature. Every number quoted in this repository was verified against the SQL output
and the independent Excel validation workbook, whatever drafted the sentence around
it.

| Insight | Source table | Verified against SQL/Excel? | Action taken |
| --- | --- | --- | --- |
| (none - workflow not implemented in this version) | | | |
