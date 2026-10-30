-- =====================================================
-- QUERY 1
-- =====================================================
SELECT
    power_plant_name,
    country_name,
    start_year,
    (2026 - start_year) AS "Years Operational"
FROM
    Power_Plant
WHERE
    power_plant_status = 'Operational'
    AND (2026 - start_year) > 30
ORDER BY
    "Years Operational" DESC;

-- VALIDATION 1
SELECT
    owner_ AS "Company Name",
    power_plant_name AS "Power Plant Name",
    start_year AS "Start Year",
    power_plant_status AS "Current Status"
FROM
    Power_Plant
WHERE
    start_year <= 1995
ORDER BY
    start_year DESC, "Company Name" ASC;

-- =====================================================
-- QUERY 2
-- =====================================================
SELECT
    owner_ AS "Company Name",
    COUNT(power_plant_name) AS "Number of Power Plants"
FROM
    Power_Plant
WHERE
    owner_ IS NOT NULL
GROUP BY
    owner_
HAVING
    COUNT(power_plant_name) > 3
ORDER BY
    "Number of Power Plants" DESC;

-- VALIDATION 2
SELECT
    owner_ AS "Company Name",
    power_plant_name AS "Power Plant Name",
    country_name AS "Country Location"
FROM
    Power_Plant
WHERE
    owner_ = 'Smith Inc'
ORDER BY
    power_plant_name ASC;

-- =====================================================
-- QUERY 3
-- =====================================================
SELECT c.country_name
FROM Country c
JOIN yearly_energy_records yer ON c.country_name = yer.country_name
WHERE yer.year_number = 2015
GROUP BY c.country_name
HAVING SUM(yer.energy_production) > SUM(yer.energy_consumption);

-- VALIDATION 3
SELECT
    c.country_name,
    SUM(yer.energy_production) AS total_production,
    SUM(yer.energy_consumption) AS total_consumption,
    SUM(yer.energy_production) - SUM(yer.energy_consumption) AS surplus
FROM Country c
JOIN yearly_energy_records yer ON c.country_name = yer.country_name
WHERE yer.year_number = 2015
GROUP BY c.country_name
HAVING SUM(yer.energy_production) > SUM(yer.energy_consumption)
ORDER BY surplus DESC;

-- =====================================================
-- QUERY 4
-- =====================================================
SELECT yer.type_name
FROM yearly_energy_records yer
WHERE yer.type_name != 'all_energy_types'
GROUP BY yer.type_name
ORDER BY AVG(yer.co2_emission) DESC
FETCH FIRST 1 ROWS ONLY;

-- VALIDATION 4
SELECT
    yer.type_name,
    AVG(yer.co2_emission) AS avg_co2
FROM yearly_energy_records yer
WHERE yer.type_name != 'all_energy_types'
GROUP BY yer.type_name
ORDER BY avg_co2 DESC;

-- =====================================================
-- QUERY 5
-- =====================================================
SELECT
    actual.country_name AS "Country Name"
FROM Yearly_Energy_Records actual
LEFT JOIN Yearly_Energy_Records previo
  ON actual.country_name = previo.country_name
  AND actual.type_name = previo.type_name
  AND actual.year_number = previo.year_number + 1
WHERE actual.type_name = 'all_energy_types'
  AND actual.year_number BETWEEN 2010 AND 2019
GROUP BY actual.country_name
HAVING COUNT(actual.year_number) = 10
   AND SUM(
       CASE
           WHEN previo.energy_consumption IS NOT NULL AND actual.energy_consumption <= previo.energy_consumption THEN 1
           ELSE 0
       END
   ) = 0
ORDER BY "Country Name" ASC;

-- VALIDATION 5
SELECT
    actual.country_name AS "Country",
    actual.year_number AS "Year",
    actual.energy_consumption AS "Current Consumption",
    previo.energy_consumption AS "Previous Consumption"
FROM Yearly_Energy_Records actual
LEFT JOIN Yearly_Energy_Records previo
  ON actual.country_name = previo.country_name
  AND actual.type_name = previo.type_name
  AND actual.year_number = previo.year_number + 1
WHERE actual.type_name = 'all_energy_types'
  AND actual.year_number BETWEEN 2010 AND 2019
  AND actual.country_name IN ('Bangladesh', 'India', 'Peru')
ORDER BY actual.country_name ASC, actual.year_number ASC;

-- =====================================================
-- QUERY 6
-- =====================================================
SELECT ys.country_name
FROM yearly_stats ys
WHERE ys.year_number = 2015
AND ys.gdp > (
    SELECT AVG(ys2.gdp)
    FROM yearly_stats ys2
    WHERE ys2.year_number = 2015
    AND ys2.country_name != 'World'
)
AND ys.country_name != 'World'
ORDER BY ys.gdp DESC;

-- VALIDATION 6
SELECT
    ys.country_name,
    ys.gdp,
    (SELECT AVG(ys2.gdp)
     FROM yearly_stats ys2
     WHERE ys2.year_number = 2015
     AND ys2.country_name != 'World') AS world_avg_gdp
FROM yearly_stats ys
WHERE ys.year_number = 2015
AND ys.country_name != 'World'
AND ys.gdp IS NOT NULL
ORDER BY ys.gdp DESC;

-- =====================================================
-- QUERY 7
-- =====================================================
SELECT pp.country_name
FROM Power_Plant pp
GROUP BY pp.country_name
HAVING COUNT(pp.power_plant_name) > 5
ORDER BY COUNT(pp.power_plant_name) DESC;

-- VALIDATION 7
SELECT
    pp.country_name,
    COUNT(pp.power_plant_name) AS total_plants
FROM Power_Plant pp
GROUP BY pp.country_name
HAVING COUNT(pp.power_plant_name) > 5
ORDER BY total_plants DESC;

-- =====================================================
-- QUERY 8
-- =====================================================
SELECT pp.plant_type,
    AVG(pp.capacity_MW) AS avg_capacity
FROM Power_Plant pp
GROUP BY pp.plant_type
ORDER BY avg_capacity DESC;

-- VALIDATION 8
SELECT
    pp.plant_type,
    COUNT(pp.power_plant_name) AS total_plants,
    MIN(pp.capacity_MW) AS min_capacity,
    MAX(pp.capacity_MW) AS max_capacity,
    AVG(pp.capacity_MW) AS avg_capacity
FROM Power_Plant pp
GROUP BY pp.plant_type
ORDER BY avg_capacity DESC;

-- =====================================================
-- QUERY 9
-- =====================================================
SELECT
    power_plant_name AS "Power Plant Name",
    AVG(annual_generation_gwh) AS "Average Annual Generation"
FROM Power_Plant
WHERE annual_generation_gwh IS NOT NULL
GROUP BY power_plant_name
HAVING AVG(annual_generation_gwh) > (
    SELECT AVG(annual_generation_gwh) FROM Power_Plant
)
ORDER BY "Average Annual Generation" DESC;

-- VALIDATION 9
SELECT AVG(annual_generation_gwh) AS "Global Average Generation"
FROM Power_Plant;

-- =====================================================
-- QUERY 10
-- =====================================================
SELECT city_name AS "City"
FROM City
WHERE cost_of_living_index > 80
INTERSECT
SELECT city_name AS "City"
FROM Registers
GROUP BY city_name
HAVING AVG(pm2_5) > 30
ORDER BY "City" ASC;

-- VALIDATION 10
SELECT
    c.city_name AS "City",
    c.cost_of_living_index AS "Cost of Living Index",
    ROUND(AVG(r.pm2_5), 2) AS "Average PM2.5"
FROM City c
INNER JOIN Registers r
  ON c.city_name = r.city_name
  AND c.country_name = r.country_name
WHERE c.city_name IN ('London', 'Paris', 'New York')
GROUP BY c.city_name, c.cost_of_living_index
HAVING c.cost_of_living_index > 80 AND AVG(r.pm2_5) > 30
ORDER BY "City" ASC;

-- =====================================================
-- QUERY 11
-- =====================================================
SELECT
    country_name AS "Country",
    energy_intensity_per_capita AS "Energy Intensity per Capita (2015)"
FROM
    Yearly_Stats
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND energy_intensity_per_capita > (
        SELECT AVG(energy_intensity_per_capita)
        FROM Yearly_Stats
        WHERE year_number = 2015 AND country_name != 'World'
    )
ORDER BY
    "Energy Intensity per Capita (2015)" DESC;

-- VALIDATION 11
SELECT
    AVG(energy_intensity_per_capita) AS "Calculated Global Average 2015"
FROM
    Yearly_Stats
WHERE
    year_number = 2015
    AND country_name != 'World';

-- =====================================================
-- QUERY 12
-- =====================================================
SELECT
    e2015.country_name AS "Country",
    e2015.co2_from_electricity_and_heat AS "Emissions (2015)",
    e2019.co2_from_electricity_and_heat AS "Emissions (2019)"
FROM
    Yearly_Emits e2015
JOIN
    Yearly_Emits e2019
    ON e2015.country_name = e2019.country_name
WHERE
    e2015.year_number = 2015
    AND e2019.year_number = 2019
    AND e2015.country_name != 'World'
    AND e2019.co2_from_electricity_and_heat < e2015.co2_from_electricity_and_heat
ORDER BY
    "Country" ASC;

-- VALIDATION 12
SELECT
    e2015.country_name,
    e2015.co2_from_electricity_and_heat AS "Emissions 2015",
    e2019.co2_from_electricity_and_heat AS "Emissions 2019"
FROM
    Yearly_Emits e2015
JOIN
    Yearly_Emits e2019
    ON e2015.country_name = e2019.country_name
WHERE
    e2015.year_number = 2015
    AND e2019.year_number = 2019
    AND e2015.country_name != 'World'
    AND e2019.co2_from_electricity_and_heat > e2015.co2_from_electricity_and_heat;

-- =====================================================
-- QUERY 13
-- =====================================================
SELECT
    country_name AS "Country",
    co2_from_transport AS "Transport Emissions (2015)"
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND co2_from_transport IS NOT NULL
ORDER BY
    co2_from_transport DESC
FETCH FIRST 1 ROWS ONLY;

-- VALIDATION 13
SELECT
    country_name,
    co2_from_transport
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND co2_from_transport IS NOT NULL
ORDER BY
    co2_from_transport DESC
FETCH FIRST 5 ROWS ONLY;

-- =====================================================
-- QUERY 14
-- =====================================================
SELECT
    country_name AS "Country",
    co2_from_industry AS "Industry Emissions (2010)"
FROM
    Yearly_Emits
WHERE
    year_number = 2010
    AND country_name != 'World'
    AND co2_from_industry > (
        SELECT AVG(co2_from_industry)
        FROM Yearly_Emits
        WHERE year_number = 2010 AND country_name != 'World'
    )
ORDER BY
    co2_from_industry DESC;

-- VALIDATION 14
SELECT
    AVG(co2_from_industry) AS "Calculated Global Average (2010)"
FROM Yearly_Emits
WHERE year_number = 2010 AND country_name != 'World';

SELECT
    MIN(co2_from_industry) AS "Lowest Value in Target Group"
FROM Yearly_Emits
WHERE year_number = 2010 AND country_name != 'World'
  AND co2_from_industry > (SELECT AVG(co2_from_industry) FROM Yearly_Emits WHERE year_number = 2010 AND country_name != 'World');

-- =====================================================
-- QUERY 15
-- =====================================================
SELECT
    country_name AS "Country",
    (co2_from_electricity_and_heat + co2_from_transport + co2_from_industry) AS "Total Sector Emissions (2015)"
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND country_name != 'High-income countries'
    AND co2_from_electricity_and_heat IS NOT NULL
    AND co2_from_transport IS NOT NULL
    AND co2_from_industry IS NOT NULL
ORDER BY
    "Total Sector Emissions (2015)" DESC;

-- VALIDATION 15
SELECT
    country_name,
    co2_from_electricity_and_heat,
    co2_from_transport,
    co2_from_industry
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name = 'China';

-- =====================================================
-- QUERY 16
-- =====================================================
SELECT
    country_name AS "Country",
    co2_from_electricity_and_heat AS "Electricity & Heat Emissions",
    co2_from_transport AS "Transport Emissions"
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND country_name != 'High-income countries'
    AND country_name != 'Upper-middle-income countries'
    AND country_name != 'Lower-middle-income countries'
    AND country_name != 'Low-income countries'
    AND country_name != 'Europe'
    AND country_name != 'Asia'
    AND country_name != 'North America'
    AND country_name != 'South America'
    AND country_name != 'Africa'
    AND country_name != 'Oceania'
    AND country_name != 'European Union (27)'
    AND co2_from_electricity_and_heat IS NOT NULL
    AND co2_from_transport IS NOT NULL
    AND co2_from_electricity_and_heat > co2_from_transport
ORDER BY
    "Country" ASC;

-- VALIDATION 16
SELECT
    MIN(co2_from_electricity_and_heat - co2_from_transport) AS "Smallest Positive Margin"
FROM
    Yearly_Emits
WHERE
    year_number = 2015
    AND country_name != 'World'
    AND country_name != 'Europe'
    AND co2_from_electricity_and_heat IS NOT NULL
    AND co2_from_transport IS NOT NULL
    AND co2_from_electricity_and_heat > co2_from_transport;

-- =====================================================
-- QUERY 17
-- =====================================================
SELECT
    CITY,
    AVG(PM2_5) AS "Average PM2.5 Level"
FROM
    GLOBAL_AIR_QUALITY_DATA_10000
WHERE
    PM2_5 IS NOT NULL
GROUP BY
    CITY
ORDER BY
    "Average PM2.5 Level" DESC
FETCH FIRST 1 ROWS ONLY;

-- VALIDATION 17
SELECT
    CITY,
    PM2_5
FROM
    GLOBAL_AIR_QUALITY_DATA_10000
WHERE
    CITY = 'Dubai'
    AND PM2_5 IS NOT NULL;

-- =====================================================
-- QUERY 18
-- =====================================================
SELECT c.country_name AS "Country Name", AVG(r.no2) AS "Average NO2 Level"
FROM City c
JOIN Registers r ON c.city_name = r.city_name
GROUP BY c.country_name
HAVING AVG(r.no2) > 50
ORDER BY "Average NO2 Level" DESC;

-- VALIDATION 18
SELECT r.country_name AS "Country Name", COUNT(*) AS "Total Records", COUNT(r.no2) AS "NO2 Records Used", AVG(r.no2) AS "Average NO2 Level"
FROM Registers r
GROUP BY r.country_name
HAVING AVG(r.no2) > 50
ORDER BY "Average NO2 Level" DESC;

-- =====================================================
-- QUERY 19
-- =====================================================
SELECT r.city_name AS "City Name", AVG(r.humidity) AS "Average Humidity", AVG(r.pm10) AS "Average PM10"
FROM Registers r
GROUP BY r.city_name
HAVING AVG(r.humidity) > 80 AND AVG(r.pm10) > 100
ORDER BY "Average Humidity" DESC, "Average PM10" DESC;

-- VALIDATION 19
SELECT r.city_name AS "City Name", r.humidity AS "Humidity", r.pm10 AS "PM10"
FROM Registers r
WHERE r.city_name IN (
    SELECT r2.city_name
    FROM Registers r2
    GROUP BY r2.city_name
    HAVING AVG(r2.humidity) > 80 AND AVG(r2.pm10) > 100
)
ORDER BY r.city_name ASC, r.humidity DESC, r.pm10 DESC;

-- =====================================================
-- QUERY 20
-- =====================================================
SELECT r.city_name AS "City Name", AVG(r.temperature) AS "Average Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL
GROUP BY r.city_name
ORDER BY "Average Temperature" DESC
FETCH FIRST 1 ROW ONLY;

-- VALIDATION 20
SELECT r.city_name AS "City Name", COUNT(r.temperature) AS "Temperature Records", AVG(r.temperature) AS "Average Temperature", MAX(r.temperature) AS "Maximum Recorded Temperature", MIN(r.temperature) AS "Minimum Recorded Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL
GROUP BY r.city_name
ORDER BY "Average Temperature" DESC;

-- =====================================================
-- QUERY 21
-- =====================================================
SELECT r.city_name AS "City Name", AVG(r.temperature) AS "Average July Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL AND r.month_number = 7
GROUP BY r.city_name
ORDER BY "Average July Temperature" DESC
FETCH FIRST 1 ROW ONLY;

-- VALIDATION 21
SELECT r.city_name AS "City Name", COUNT(r.temperature) AS "July Temperature Records", AVG(r.temperature) AS "Average July Temperature", MAX(r.temperature) AS "Maximum July Temperature", MIN(r.temperature) AS "Minimum July Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL AND r.month_number = 7
GROUP BY r.city_name
ORDER BY "Average July Temperature" DESC;

-- =====================================================
-- QUERY 22
-- =====================================================
SELECT r.country_name AS "Country Name", AVG(r.temperature) AS "Average Winter Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL AND r.month_number IN (12, 1, 2)
GROUP BY r.country_name
ORDER BY "Average Winter Temperature" DESC
FETCH FIRST 1 ROW ONLY;

-- VALIDATION 22
SELECT r.country_name AS "Country Name", COUNT(r.temperature) AS "Winter Temperature Records", AVG(r.temperature) AS "Average Winter Temperature", MAX(r.temperature) AS "Maximum Winter Temperature", MIN(r.temperature) AS "Minimum Winter Temperature"
FROM Registers r
WHERE r.temperature IS NOT NULL AND r.month_number IN (12, 1, 2)
GROUP BY r.country_name
ORDER BY "Average Winter Temperature" DESC;

-- =====================================================
-- QUERY 23
-- =====================================================
SELECT c.city_name AS "City Name", c.country_name AS "Country Name", c.cost_of_living_index AS "Cost Of Living Index"
FROM City c
WHERE c.cost_of_living_index > (
    SELECT AVG(c2.cost_of_living_index)
    FROM City c2
    WHERE c2.cost_of_living_index IS NOT NULL
)
ORDER BY c.cost_of_living_index DESC;

-- VALIDATION 23
SELECT AVG(c.cost_of_living_index) AS "Average Cost Of Living Index"
FROM City c
WHERE c.cost_of_living_index IS NOT NULL;

-- =====================================================
-- QUERY 24
-- =====================================================
SELECT c.country_name AS "Country Name"
FROM City c
WHERE c.country_name IS NOT NULL
MINUS
SELECT gp.country_name AS "Country Name"
FROM Government_Policy gp
WHERE gp.country_name IS NOT NULL
ORDER BY "Country Name";

-- VALIDATION 24
SELECT c.country_name AS "Country Name", COUNT(gp.policy_id) AS "Total Policies"
FROM City c
LEFT JOIN Government_Policy gp ON c.country_name = gp.country_name
GROUP BY c.country_name
HAVING COUNT(gp.policy_id) = 0
ORDER BY c.country_name;

-- =====================================================
-- QUERY 25
-- =====================================================
SELECT c.city_name AS "City Name", c.country_name AS "Country Name", c.local_purchasing_power_index AS "Local Purchasing Power Index"
FROM City c
WHERE c.local_purchasing_power_index IS NOT NULL
ORDER BY c.local_purchasing_power_index DESC
FETCH FIRST 5 ROWS ONLY;

-- VALIDATION 25
SELECT c.city_name AS "City Name", c.country_name AS "Country Name", c.local_purchasing_power_index AS "Local Purchasing Power Index"
FROM City c
WHERE c.local_purchasing_power_index IS NOT NULL
ORDER BY c.local_purchasing_power_index DESC;

-- =====================================================
-- QUERY 26
-- =====================================================
SELECT gp.country_name AS "Country Name", COUNT(*) AS "Active Policies"
FROM Government_Policy gp
WHERE gp.policy_status = 'Active'
GROUP BY gp.country_name
HAVING COUNT(*) > 3
ORDER BY "Active Policies" DESC;

-- VALIDATION 26
SELECT gp.country_name AS "Country Name", gp.policy_id AS "Policy ID", gp.policy_name AS "Policy Name", gp.policy_status AS "Policy Status"
FROM Government_Policy gp
WHERE gp.policy_status = 'Active'
ORDER BY gp.country_name ASC, gp.policy_id ASC;

-- =====================================================
-- QUERY 27
-- =====================================================
SELECT DISTINCT c.country_name
FROM Country c
JOIN Government_Policy gp ON c.country_name = gp.country_name
WHERE gp.budget_million_usd > (
    SELECT AVG(gp2.budget_million_usd)
    FROM Government_Policy gp2
)
ORDER BY c.country_name;

-- VALIDATION 27
SELECT
    c.country_name,
    gp.name_policy,
    gp.budget_million_usd,
    (SELECT AVG(gp2.budget_million_usd)
     FROM Government_Policy gp2) AS avg_budget
FROM Country c
JOIN Government_Policy gp ON c.country_name = gp.country_name
WHERE gp.budget_million_usd > (
    SELECT AVG(gp2.budget_million_usd)
    FROM Government_Policy gp2
)
ORDER BY gp.budget_million_usd DESC;

-- =====================================================
-- QUERY 28
-- =====================================================
SELECT yer.country_name AS "Country Name"
FROM Yearly_Energy_Records yer
WHERE yer.year_number = 2015 AND yer.type_name = 'all_energy_types' AND yer.country_name != 'World' AND yer.co2_emission > (
    SELECT AVG(yer2.co2_emission)
    FROM Yearly_Energy_Records yer2
    WHERE yer2.year_number = 2015 AND yer2.type_name = 'all_energy_types' AND yer2.country_name != 'World')
INTERSECT
SELECT gp.country_name AS "Country Name"
FROM Government_Policy gp
WHERE gp.policy_status = 'Active' AND gp.policy_type = 'Emissions Reduction'
ORDER BY "Country Name";

-- VALIDATION 28
SELECT gp.country_name AS "Country Name", COUNT(gp.policy_id) AS "Active Reduction Policies"
FROM Government_Policy gp
WHERE gp.policy_status = 'Active' AND gp.policy_type = 'Emissions Reduction' AND gp.country_name IN (
    SELECT yer.country_name
    FROM Yearly_Energy_Records yer
    WHERE yer.year_number = 2015 AND yer.type_name = 'all_energy_types' AND yer.country_name != 'World' AND yer.co2_emission > (
        SELECT AVG(yer2.co2_emission)
        FROM Yearly_Energy_Records yer2
        WHERE yer2.year_number = 2015 AND yer2.type_name = 'all_energy_types' AND yer2.country_name != 'World')
)
GROUP BY gp.country_name
ORDER BY gp.country_name;

-- =====================================================
-- QUERY 29
-- =====================================================
SELECT ys.country_name AS "Country Name", 'High GDP' AS "Category", ys.gdp AS "Value"
FROM Yearly_Stats ys
WHERE ys.year_number = 2015 AND ys.country_name != 'World' AND ys.gdp > (
    SELECT AVG(ys2.gdp)
    FROM Yearly_Stats ys2
    WHERE ys2.year_number = 2015 AND ys2.country_name != 'World')
UNION ALL
SELECT yer.country_name AS "Country Name", 'High CO2 Emission' AS "Category", yer.co2_emission AS "Value"
FROM Yearly_Energy_Records yer
WHERE yer.year_number = 2015 AND yer.type_name = 'all_energy_types' AND yer.country_name != 'World' AND yer.co2_emission > (
    SELECT AVG(yer2.co2_emission)
    FROM Yearly_Energy_Records yer2
    WHERE yer2.year_number = 2015 AND yer2.type_name = 'all_energy_types' AND yer2.country_name != 'World')
ORDER BY "Country Name", "Category";

-- VALIDATION 29
SELECT 'High GDP' AS "Category", COUNT(*) AS "Total Rows"
FROM Yearly_Stats ys
WHERE ys.year_number = 2015 AND ys.country_name != 'World' AND ys.gdp > (
    SELECT AVG(ys2.gdp)
    FROM Yearly_Stats ys2
    WHERE ys2.year_number = 2015 AND ys2.country_name != 'World')
UNION ALL
SELECT 'High CO2 Emission' AS "Category", COUNT(*) AS "Total Rows"
FROM Yearly_Energy_Records yer
WHERE yer.year_number = 2015 AND yer.type_name = 'all_energy_types' AND yer.country_name != 'World' AND yer.co2_emission > (
    SELECT AVG(yer2.co2_emission)
    FROM Yearly_Energy_Records yer2
    WHERE yer2.year_number = 2015 AND yer2.type_name = 'all_energy_types' AND yer2.country_name != 'World');

-- =====================================================
-- QUERY 30
-- =====================================================
SELECT c.country_name
FROM Country c
WHERE c.country_name NOT IN (
    SELECT DISTINCT gp.country_name
    FROM Government_Policy gp
)
AND c.country_name NOT IN (
    'World', 'Africa', 'Asia', 'Europe', 'European Union (27)',
    'North America', 'South America', 'Oceania', 'Antarctica',
    'Former U.S.S.R.', 'Former Yugoslavia', 'Former Czechoslovakia',
    'Former Serbia and Montenegro'
)
ORDER BY c.country_name;

-- VALIDATION 30
SELECT c.country_name, COUNT(gp.policy_id) AS total_policies
FROM Country c
LEFT JOIN Government_Policy gp ON c.country_name = gp.country_name
WHERE c.country_name NOT IN (
    'World', 'Africa', 'Asia', 'Europe', 'European Union (27)',
    'North America', 'South America', 'Oceania', 'Antarctica',
    'Former U.S.S.R.', 'Former Yugoslavia', 'Former Czechoslovakia',
    'Former Serbia and Montenegro'
)
GROUP BY c.country_name
HAVING COUNT(gp.policy_id) = 0
ORDER BY c.country_name;

-- =====================================================
-- TRIGGER 1: AUDIT PLANT STATUS
-- =====================================================
CREATE TABLE Power_Plant_Audit (
    power_plant_name VARCHAR2(255),
    old_status VARCHAR2(100),
    new_status VARCHAR2(100),
    change_date DATE
);

CREATE TRIGGER trg_audit_plant_status
AFTER UPDATE OF power_plant_status ON Power_Plant
FOR EACH ROW
WHEN (OLD.power_plant_status != NEW.power_plant_status)
BEGIN
    INSERT INTO Power_Plant_Audit (
        power_plant_name,
        old_status,
        new_status,
        change_date
    )
    VALUES (
        :OLD.power_plant_name,
        :OLD.power_plant_status,
        :NEW.power_plant_status,
        SYSDATE
    );
END;
/

-- VALIDATION TRIGGER 1
SELECT * FROM POWER_PLANT WHERE POWER_PLANT_NAME = 'Stephens-Mccoy';

UPDATE Power_Plant
SET power_plant_status = 'Decommissioned'
WHERE power_plant_name = 'Stephens-Mccoy';

SELECT * FROM Power_Plant_Audit WHERE power_plant_name = 'Stephens-Mccoy';

-- =====================================================
-- TRIGGER 2: POLICY BUDGET ALERT
-- =====================================================
CREATE TABLE Policy_Budget_Alert (
    policy_id                NUMBER,
    name_policy              VARCHAR2(255),
    budget_million_usd       NUMBER,
    avg_budget_at_insert     NUMBER,
    target_reduction_percent NUMBER,
    alert_date               DATE,
    country_name             VARCHAR2(255),
    country_alert_count      NUMBER
);

CREATE OR REPLACE TRIGGER trg_policy_budget_alert
BEFORE INSERT ON Government_Policy
FOR EACH ROW
DECLARE
    v_avg_budget  NUMBER;
    v_alert_count NUMBER;
BEGIN
    SELECT AVG(budget_million_usd)
    INTO v_avg_budget
    FROM Government_Policy;

    IF :NEW.budget_million_usd > v_avg_budget
    AND :NEW.target_reduction_percent > 20 THEN

        SELECT COUNT(*) + 1
        INTO v_alert_count
        FROM Policy_Budget_Alert
        WHERE country_name = :NEW.country_name;

        INSERT INTO Policy_Budget_Alert (
            policy_id,
            name_policy,
            budget_million_usd,
            avg_budget_at_insert,
            target_reduction_percent,
            alert_date,
            country_name,
            country_alert_count
        )
        VALUES (
            :NEW.policy_id,
            :NEW.name_policy,
            :NEW.budget_million_usd,
            v_avg_budget,
            :NEW.target_reduction_percent,
            SYSDATE,
            :NEW.country_name,
            v_alert_count
        );
    END IF;
END;
/

-- VALIDATION TRIGGER 2
INSERT INTO Government_Policy (policy_id, name_policy, budget_million_usd, target_reduction_percent, policy_status, start_policy_year, policy_type, country_name)
VALUES (9999, 'Test Policy Low', 10, 5, 'Active', 2020, 'Fiscal Incentive', 'Spain');
SELECT * FROM Policy_Budget_Alert WHERE policy_id = 9999;

INSERT INTO Government_Policy (policy_id, name_policy, budget_million_usd, target_reduction_percent, policy_status, start_policy_year, policy_type, country_name)
VALUES (10000, 'Test Policy High Low Target', 999999, 5, 'Active', 2021, 'Emissions Reduction', 'Spain');
SELECT * FROM Policy_Budget_Alert WHERE policy_id = 10000;

INSERT INTO Government_Policy (policy_id, name_policy, budget_million_usd, target_reduction_percent, policy_status, start_policy_year, policy_type, country_name)
VALUES (10003, 'Test Policy High', 999999, 50, 'Active', 2021, 'Emissions Reduction', 'Spain');
SELECT * FROM Policy_Budget_Alert WHERE policy_id = 10003;

INSERT INTO Government_Policy (policy_id, name_policy, budget_million_usd, target_reduction_percent, policy_status, start_policy_year, policy_type, country_name)
VALUES (10004, 'Test Policy High 2', 999999, 50, 'Active', 2022, 'Emissions Reduction', 'Spain');
SELECT * FROM Policy_Budget_Alert WHERE country_name = 'Spain' ORDER BY alert_date;

-- =====================================================
-- TRIGGER 3: ENVIRONMENTAL CLASSIFICATION
-- =====================================================
CREATE TABLE Environmental_Classification (
    classification_id INT GENERATED BY DEFAULT AS IDENTITY,
    city_name VARCHAR2(100),
    country_name VARCHAR2(100),
    day_number INT,
    month_number INT,
    year_number INT,
    pollution_level VARCHAR2(50),
    classification_date DATE,
    CONSTRAINT pk_environmental_classification PRIMARY KEY (classification_id)
);

CREATE TRIGGER trg_environmental_classification
AFTER INSERT ON Registers
FOR EACH ROW
DECLARE
    v_pollution_level VARCHAR2(50);
BEGIN
    IF :NEW.pm10 >= 150 OR :NEW.no2 >= 100 OR :NEW.o3 >= 180 THEN
        v_pollution_level := 'Critical Pollution';
    ELSIF :NEW.pm10 >= 80 OR :NEW.no2 >= 50 OR :NEW.o3 >= 120 THEN
        v_pollution_level := 'Moderate Pollution';
    ELSE
        v_pollution_level := 'Low Pollution';
    END IF;

    INSERT INTO Environmental_Classification (
        city_name,
        country_name,
        day_number,
        month_number,
        year_number,
        pollution_level,
        classification_date
    )
    VALUES (
        :NEW.city_name,
        :NEW.country_name,
        :NEW.day_number,
        :NEW.month_number,
        :NEW.year_number,
        v_pollution_level,
        SYSDATE
    );
END;
/

-- VALIDATION TRIGGER 3
INSERT INTO Registers (city_name, country_name, day_number, month_number, year_number, pm10, no2, o3)
VALUES ('Bangkok', 'Thailand', 26, 4, 2023, 30.0, 20.0, 50.0);

INSERT INTO Registers (city_name, country_name, day_number, month_number, year_number, pm10, no2, o3)
VALUES ('Bangkok', 'Thailand', 18, 6, 2023, 90.0, 40.0, 80.0);

INSERT INTO Registers (city_name, country_name, day_number, month_number, year_number, pm10, no2, o3)
VALUES ('Bangkok', 'Thailand', 15, 5, 2023, 200.0, 120.0, 250.0);

SELECT city_name, country_name, day_number, month_number, year_number, pollution_level, classification_date
FROM Environmental_Classification;
