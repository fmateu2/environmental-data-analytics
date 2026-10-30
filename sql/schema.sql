CREATE TABLE Country (
    country_name VARCHAR(255) PRIMARY KEY,
    region_name VARCHAR(255),
    country_code VARCHAR(10)
);

CREATE TABLE Company (
    company_name VARCHAR(255) PRIMARY KEY,
    company_website VARCHAR(255)
);

CREATE TABLE Energy_Type (
    type_name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Year_ (
    year_number INT PRIMARY KEY
);

CREATE TABLE Exact_Date_ (
    day_number INT,
    month_number INT,
    year_number INT,
    PRIMARY KEY (day_number, month_number, year_number),
    FOREIGN KEY (year_number) REFERENCES Year_(year_number)
);

CREATE TABLE Government_Policy (
    policy_id INT PRIMARY KEY,
    name_policy VARCHAR(255),
    budget_million_usd INT,
    target_reduction_percent INT,
    policy_status VARCHAR(100),
    start_policy_year INT,
    policy_type VARCHAR(100),
    country_name VARCHAR(255),
    FOREIGN KEY (country_name) REFERENCES Country(country_name)
);

CREATE TABLE City (
    city_name VARCHAR(255),
    country_name VARCHAR(255),
    city_rank INT,
    cost_of_living_index FLOAT,
    rent_index FLOAT,
    groceries_index FLOAT,
    restaurant_price_index FLOAT,
    local_purchasing_power_index FLOAT,
    cost_of_living_plus_rent_index FLOAT,
    PRIMARY KEY (city_name, country_name),
    FOREIGN KEY (country_name) REFERENCES Country(country_name)
);

CREATE TABLE Power_Plant (
    power_plant_name VARCHAR(255) PRIMARY KEY,
    power_plant_location VARCHAR(255),
    start_year INT,
    capacity_MW INT,
    annual_generation_GWh FLOAT,
    lifetime_generation_GWh FLOAT,
    plant_type VARCHAR(100),
    power_plant_status VARCHAR(100),
    country_name VARCHAR(255),
    operator_ VARCHAR(255),
    owner_ VARCHAR(255),
    FOREIGN KEY (country_name) REFERENCES Country(country_name),
    FOREIGN KEY (operator_) REFERENCES Company(company_name),
    FOREIGN KEY (owner_) REFERENCES Company(company_name)
);

CREATE TABLE Yearly_Stats (
    country_name VARCHAR(255),
    year_number INT,
    population FLOAT,
    gdp FLOAT,
    energy_intensity_per_capita FLOAT,
    energy_intensity_by_gdp FLOAT,
    PRIMARY KEY (country_name, year_number),
    FOREIGN KEY (country_name) REFERENCES Country(country_name),
    FOREIGN KEY (year_number) REFERENCES Year_(year_number)
);

CREATE TABLE Yearly_Emits (
    country_name VARCHAR(255),
    year_number INT,
    co2_from_buildings FLOAT,
    co2_from_industry FLOAT,
    co2_from_land_use_change_and_forestry FLOAT,
    co2_from_other_fuel_combustion FLOAT,
    co2_from_transport FLOAT,
    co2_from_manufacturing_and_construction FLOAT,
    fugitive_co2_from_energy_production FLOAT,
    co2_from_electricity_and_heat FLOAT,
    co2_from_bunker_fuels FLOAT,
    PRIMARY KEY (country_name, year_number),
    FOREIGN KEY (country_name) REFERENCES Country(country_name),
    FOREIGN KEY (year_number) REFERENCES Year_(year_number)
);

CREATE TABLE Yearly_Energy_Records (
    country_name VARCHAR(255),
    year_number INT,
    type_name VARCHAR(255),
    energy_consumption FLOAT,
    energy_production FLOAT,
    co2_emission FLOAT,
    PRIMARY KEY (country_name, year_number, type_name),
    FOREIGN KEY (country_name) REFERENCES Country(country_name),
    FOREIGN KEY (year_number) REFERENCES Year_(year_number),
    FOREIGN KEY (type_name) REFERENCES Energy_Type(type_name)
);

CREATE TABLE Registers (
    city_name VARCHAR(255),
    country_name VARCHAR(255),
    day_number INT,
    month_number INT,
    year_number INT,
    avg_temperature FLOAT,
    temperature FLOAT,
    humidity FLOAT,
    wind_speed FLOAT,
    PM2_5 FLOAT,
    PM10 FLOAT,
    NO2 FLOAT,
    SO2 FLOAT,
    CO FLOAT,
    O3 FLOAT,
    PRIMARY KEY (city_name, country_name, day_number, month_number, year_number),
    FOREIGN KEY (city_name, country_name) REFERENCES City(city_name, country_name),
    FOREIGN KEY (day_number, month_number, year_number) REFERENCES Exact_Date_(day_number, month_number, year_number)
);
