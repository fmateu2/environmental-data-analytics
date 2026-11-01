-- Run after schema.sql and the trigger definitions in a dedicated Oracle development schema.
-- No DDL or COMMIT: all fixture rows are rolled back on success or failure.
SET SERVEROUTPUT ON

DECLARE
    v_count NUMBER;
    v_baseline NUMBER;
    v_budget NUMBER;
    v_alerts NUMBER;
    v_min_count NUMBER;
    v_max_count NUMBER;
    v_min_avg NUMBER;
    v_max_avg NUMBER;
    c_country CONSTANT VARCHAR2(255) := '__portfolio_policy_trigger_test__';
BEGIN
    SAVEPOINT portfolio_policy_trigger_test;

    SELECT COUNT(*) INTO v_count
    FROM USER_OBJECTS
    WHERE OBJECT_TYPE = 'TRIGGER'
      AND OBJECT_NAME = 'TRG_POLICY_BUDGET_ALERT'
      AND STATUS = 'VALID';
    IF v_count <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Policy alert trigger is missing or invalid.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM Country WHERE country_name = c_country;
    IF v_count <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Reserved fixture country already exists.');
    END IF;
    SELECT COUNT(*) INTO v_count FROM Government_Policy
    WHERE policy_id IN (-987654321, -987654322, -987654323);
    IF v_count <> 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Reserved fixture policy IDs already exist.');
    END IF;

    INSERT INTO Country (country_name) VALUES (c_country);
    -- Ensure that AVG has a non-NULL baseline even in a fresh schema.
    INSERT INTO Government_Policy
        (policy_id, name_policy, budget_million_usd, target_reduction_percent, country_name)
    VALUES (-987654321, 'Baseline fixture', 0, 0, c_country);

    SELECT AVG(budget_million_usd) INTO v_baseline FROM Government_Policy;
    v_budget := CEIL(GREATEST(v_baseline, 0)) + 1000;

    -- A single statement inserts two rows; the original row trigger queried a mutating table.
    INSERT INTO Government_Policy
        (policy_id, name_policy, budget_million_usd, target_reduction_percent, country_name)
    SELECT -987654322, 'Multi-row fixture A', v_budget, 50, c_country FROM dual
    UNION ALL
    SELECT -987654323, 'Multi-row fixture B', v_budget, 50, c_country FROM dual;

    SELECT COUNT(*), MIN(country_alert_count), MAX(country_alert_count),
           MIN(avg_budget_at_insert), MAX(avg_budget_at_insert)
    INTO v_alerts, v_min_count, v_max_count, v_min_avg, v_max_avg
    FROM Policy_Budget_Alert
    WHERE country_name = c_country;

    IF v_alerts <> 2 OR v_min_count <> 1 OR v_max_count <> 2
       OR v_min_avg <> v_baseline OR v_max_avg <> v_baseline THEN
        RAISE_APPLICATION_ERROR(-20004, 'Unexpected alerts, baseline or per-country counts.');
    END IF;

    ROLLBACK TO portfolio_policy_trigger_test;
    DBMS_OUTPUT.PUT_LINE('PASS: multi-row insert, shared baseline, alert counts and fixture rollback.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO portfolio_policy_trigger_test;
        RAISE;
END;
/
