# Environmental Data Analytics

### From environmental CSVs to a relational model and analytical SQL.

An academic Oracle database project combining climate, energy, emissions, air-quality and policy data. Original assignment: **Databases 2025–2026 — Choose Your Adventure / Environment, Group 5**.

**Team:** Francesc Mateu Vallespín, Jan Francesc Porcar Guillen and Giovanni Luca Giraldo Cabana.

## At a glance

| Deliverable | Included scope |
| --- | --- |
| Core schema | 12 tables with primary and foreign keys |
| Analytical questions | 30 numbered queries |
| Validation material | Companion validation statements for the 30 queries |
| Database logic | 3 trigger definitions and 3 auxiliary tables |
| Design | Conceptual and relational diagrams |
| Documentation | Original 109-page report and presentation in `docs/` |

The work connects country, city, year and exact-date dimensions with energy records, sector emissions, air-quality observations, power plants, companies and government policies.

## Francesc's contribution

According to the original team report, Francesc contributed to the conceptual and relational models, managed schema execution and imports for assigned entities in Oracle, developed a share of the advanced SQL queries and validation statements, implemented triggers and contributed to the report. Specific query or trigger ownership is not inferred beyond that account.

## Files

| Path | Contents |
| --- | --- |
| `sql/schema.sql` | Original physical model: 12 core `CREATE TABLE` statements |
| `sql/import.sql` | Transformations and inserts from CSV staging tables |
| `sql/queries-and-triggers.sql` | 30 queries, validations, auxiliary tables, triggers and example DML |
| `models/conceptual-model.jpg` | Original conceptual model |
| `models/relational-model.jpg` | Original relational model |

The complete [academic report](docs/technical-report.pdf) and [presentation](docs/presentation.pdf) are included in `docs/`. The original data models can be inspected in [models/](models/README.md).

## Reproduction sequence

Use a dedicated Oracle development schema and a SQL client compatible with the course scripts.

1. Obtain the original Environment CSV dataset and the team's government-policy CSV. These raw data files are **not included** in the supplied archive.
2. Import the CSVs into the staging tables referenced by `sql/import.sql`, preserving the expected column names and data types. The original work used Oracle's import wizard.
3. Execute `sql/schema.sql` to create the core tables in an empty development schema.
4. Review and run the import statements in their original dependency order. Check date conversions, quoted column names and source-key consistency before loading.
5. Run selected analytical queries alongside their companion validation statements and compare their meaning and results.
6. Review the trigger sections separately. They create auxiliary tables and include example writes; the combined file is not a read-only query script.

The staging sources referenced by the import script include `CO_EMISSIONS_BY_SECTOR`, `CITY_TEMPERATURE`, `NUCLEAR_POWER_DATASET`, `ENERGY`, `GLOBAL_AIR_QUALITY_DATA_10000`, `GOVERNMENT_POLICY_1` and the cost-of-living source. Use the actual identifiers in the script as the authority when preparing staging tables.

## Query techniques

Examples use joins, grouping, `HAVING`, aggregate comparisons, scalar subqueries, year-to-year joins, `INTERSECT`, `UNION ALL` and exclusion logic. The portfolio browser displays four original queries and their companion validation statements. It does not execute SQL or fabricate query results.

The selected queries examine:

- Energy production versus consumption in 2015.
- Cities meeting both cost-of-living and average PM2.5 thresholds.
- Countries with above-average 2015 emissions and policy records marked active.
- Two labelled sets: above-average GDP and above-average emissions in 2015.

In the policy example, the original SQL filters the emissions year but does not establish that the policy was active in that same year. The portfolio description keeps that distinction explicit.

## Trigger definitions

- `trg_audit_plant_status`: records changes to power-plant status.
- `trg_policy_budget_alert`: records qualifying policy alerts against the average budget captured before the insert statement. A compound trigger avoids querying the changing policy table from a row trigger.
- `trg_environmental_classification`: classifies inserted environmental observations using the scripted conditions.

The budget-alert trigger includes a correction to the original academic implementation: it captures the average once before the statement and applies that baseline to each inserted row. An empty baseline still produces no alerts. The other trigger definitions retain the original academic logic. Oracle compilation and execution have not been verified in this environment; run the regression script below in a dedicated development schema.

## Budget-alert regression check

After creating the schema and triggers in a dedicated Oracle development schema, run `sql/tests/policy-budget-alert.sql`. It checks a multi-row insert, a shared pre-statement average and per-country alert counts, then rolls back its fixture rows. Do not run the combined queries-and-triggers file against a production schema.

## Verification and interpretation

The portfolio checks the source structure, extracts the displayed SQL directly from the original script and verifies local links and source-package integrity. The supplied archive contains the SQL and project documents, but neither the raw CSV dataset nor an Oracle instance.

No fresh database execution, performance benchmark or independent reproduction of the report's result sets is claimed. The validation statements are part of the original project, not evidence that every query passed a new automated test suite.

Potential follow-up work includes reproducible staging-table creation, explicit dataset provenance, date and key validation, reviewing aggregate energy rows before summation, testing policy time alignment and verifying trigger behavior under multi-row operations.

## Credits and reuse

Original SQL and diagrams are retained. Packaging changes filenames and adds this README; the portfolio's schema and SQL explorers are presentation additions.

No new licence is assigned to the original project or dataset. Consult the authors and source-data terms before reuse.

