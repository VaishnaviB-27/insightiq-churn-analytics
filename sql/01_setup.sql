SELECT version() AS mysql_version, database() AS current_database;
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'insightiq';
CREATE DATABASE insightiq;
USE insightiq;
SELECT DATABASE() AS current_database;
USE insightiq;
SELECT DATABASE() AS current_database;

CREATE TABLE insightiq.telco_raw (
    customerID VARCHAR(255),
    gender VARCHAR(255),
    SeniorCitizen VARCHAR(255),
    Partner VARCHAR(255),
    Dependents VARCHAR(255),
    tenure VARCHAR(255),
    PhoneService VARCHAR(255),
    MultipleLines VARCHAR(255),
    InternetService VARCHAR(255),
    OnlineSecurity VARCHAR(255),
    OnlineBackup VARCHAR(255),
    DeviceProtection VARCHAR(255),
    TechSupport VARCHAR(255),
    StreamingTV VARCHAR(255),
    StreamingMovies VARCHAR(255),
    Contract VARCHAR(255),
    PaperlessBilling VARCHAR(255),
    PaymentMethod VARCHAR(255),
    MonthlyCharges VARCHAR(255),
    TotalCharges VARCHAR(255),
    Churn VARCHAR(255)
) CHARACTER SET utf8mb4;



SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT TRIM(customerID)) AS unique_customer_ids,
       SUM(CASE WHEN customerID IS NULL OR TRIM(customerID) = '' THEN 1 ELSE 0 END) AS blank_customer_ids,
       SUM(CASE WHEN TRIM(customerID) = 'customerID' THEN 1 ELSE 0 END) AS header_rows
FROM insightiq.telco_raw;


SELECT
    SUM(CASE WHEN TotalCharges IS NULL OR TRIM(TotalCharges) = '' THEN 1 ELSE 0 END) AS blank_total_charges,
    SUM(CASE WHEN TRIM(tenure) = '0' THEN 1 ELSE 0 END) AS zero_tenure_customers,
    SUM(CASE WHEN (TotalCharges IS NULL OR TRIM(TotalCharges) = '') AND TRIM(tenure) = '0' THEN 1 ELSE 0 END) AS blanks_with_zero_tenure,
    SUM(CASE WHEN (TotalCharges IS NULL OR TRIM(TotalCharges) = '') AND (tenure IS NULL OR TRIM(tenure) <> '0') THEN 1 ELSE 0 END) AS blanks_other_tenure
FROM insightiq.telco_raw;



SELECT
    SUM(CASE WHEN tenure IS NULL OR NOT REGEXP_LIKE(TRIM(tenure), '^[0-9]{1,3}$') THEN 1 ELSE 0 END) AS invalid_tenure_format,
    SUM(CASE WHEN MonthlyCharges IS NULL OR NOT REGEXP_LIKE(TRIM(MonthlyCharges), '^[0-9]{1,7}([.][0-9]{1,2})?$') THEN 1 ELSE 0 END) AS invalid_monthly_charges_format,
    SUM(CASE WHEN TotalCharges IS NULL OR TRIM(TotalCharges) = '' THEN 0 WHEN NOT REGEXP_LIKE(TRIM(TotalCharges), '^[0-9]{1,8}([.][0-9]{1,2})?$') THEN 1 ELSE 0 END) AS invalid_nonblank_total_charges_format
FROM insightiq.telco_raw;


SELECT
    MIN(CAST(TRIM(tenure) AS UNSIGNED)) AS min_tenure,
    MAX(CAST(TRIM(tenure) AS UNSIGNED)) AS max_tenure,
    MIN(CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2))) AS min_monthly_charges,
    MAX(CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2))) AS max_monthly_charges,
    MIN(CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2))) AS min_total_charges,
    MAX(CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2))) AS max_total_charges
FROM insightiq.telco_raw;

SELECT
    SUM(CASE WHEN Churn IS NULL OR TRIM(Churn) NOT IN ('Yes', 'No') THEN 1 ELSE 0 END) AS invalid_churn,
    SUM(CASE WHEN Contract IS NULL OR TRIM(Contract) NOT IN ('Month-to-month', 'One year', 'Two year') THEN 1 ELSE 0 END) AS invalid_contract,
    SUM(CASE WHEN InternetService IS NULL OR TRIM(InternetService) NOT IN ('DSL', 'Fiber optic', 'No') THEN 1 ELSE 0 END) AS invalid_internet_service,
    SUM(CASE WHEN PaymentMethod IS NULL OR TRIM(PaymentMethod) NOT IN ('Bank transfer (automatic)', 'Credit card (automatic)', 'Electronic check', 'Mailed check') THEN 1 ELSE 0 END) AS invalid_payment_method,
    SUM(CASE WHEN SeniorCitizen IS NULL OR TRIM(SeniorCitizen) NOT IN ('0', '1') THEN 1 ELSE 0 END) AS invalid_senior_citizen,
    SUM(CASE WHEN gender IS NULL OR TRIM(gender) NOT IN ('Female', 'Male') THEN 1 ELSE 0 END) AS invalid_gender
FROM insightiq.telco_raw;


SELECT
    SUM(CASE WHEN Partner IS NULL OR TRIM(Partner) NOT IN ('Yes', 'No') THEN 1 ELSE 0 END) AS invalid_partner,
    SUM(CASE WHEN Dependents IS NULL OR TRIM(Dependents) NOT IN ('Yes', 'No') THEN 1 ELSE 0 END) AS invalid_dependents,
    SUM(CASE WHEN PhoneService IS NULL OR TRIM(PhoneService) NOT IN ('Yes', 'No') THEN 1 ELSE 0 END) AS invalid_phone_service,
    SUM(CASE WHEN PaperlessBilling IS NULL OR TRIM(PaperlessBilling) NOT IN ('Yes', 'No') THEN 1 ELSE 0 END) AS invalid_paperless_billing,
    SUM(CASE WHEN MultipleLines IS NULL OR TRIM(MultipleLines) NOT IN ('Yes', 'No', 'No phone service') THEN 1 ELSE 0 END) AS invalid_multiple_lines,
    SUM(CASE WHEN (TRIM(PhoneService) = 'No' AND TRIM(MultipleLines) IN ('Yes', 'No')) OR (TRIM(PhoneService) = 'Yes' AND TRIM(MultipleLines) = 'No phone service') THEN 1 ELSE 0 END) AS inconsistent_phone_service
FROM insightiq.telco_raw;


WITH service_values AS (
    SELECT 'OnlineSecurity' AS service_name, TRIM(InternetService) AS internet_service, TRIM(OnlineSecurity) AS service_value FROM insightiq.telco_raw
    UNION ALL
    SELECT 'OnlineBackup', TRIM(InternetService), TRIM(OnlineBackup) FROM insightiq.telco_raw
    UNION ALL
    SELECT 'DeviceProtection', TRIM(InternetService), TRIM(DeviceProtection) FROM insightiq.telco_raw
    UNION ALL
    SELECT 'TechSupport', TRIM(InternetService), TRIM(TechSupport) FROM insightiq.telco_raw
    UNION ALL
    SELECT 'StreamingTV', TRIM(InternetService), TRIM(StreamingTV) FROM insightiq.telco_raw
    UNION ALL
    SELECT 'StreamingMovies', TRIM(InternetService), TRIM(StreamingMovies) FROM insightiq.telco_raw
)
SELECT service_name,
    SUM(CASE WHEN service_value IS NULL OR service_value NOT IN ('Yes', 'No', 'No internet service') THEN 1 ELSE 0 END) AS invalid_values,
    SUM(CASE WHEN (internet_service = 'No' AND service_value IN ('Yes', 'No')) OR (internet_service IN ('DSL', 'Fiber optic') AND service_value = 'No internet service') THEN 1 ELSE 0 END) AS inconsistent_internet_service
FROM service_values
GROUP BY service_name
ORDER BY service_name;
