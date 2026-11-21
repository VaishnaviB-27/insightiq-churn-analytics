CREATE TABLE insightiq.customers (
    customerID VARCHAR(255) NOT NULL PRIMARY KEY,
    gender VARCHAR(32) NOT NULL,
    SeniorCitizen TINYINT UNSIGNED NOT NULL,
    Partner VARCHAR(32) NOT NULL,
    Dependents VARCHAR(32) NOT NULL,
    tenure SMALLINT UNSIGNED NOT NULL,
    PhoneService VARCHAR(32) NOT NULL,
    MultipleLines VARCHAR(32) NOT NULL,
    InternetService VARCHAR(32) NOT NULL,
    OnlineSecurity VARCHAR(32) NOT NULL,
    OnlineBackup VARCHAR(32) NOT NULL,
    DeviceProtection VARCHAR(32) NOT NULL,
    TechSupport VARCHAR(32) NOT NULL,
    StreamingTV VARCHAR(32) NOT NULL,
    StreamingMovies VARCHAR(32) NOT NULL,
    Contract VARCHAR(32) NOT NULL,
    PaperlessBilling VARCHAR(32) NOT NULL,
    PaymentMethod VARCHAR(64) NOT NULL,
    MonthlyCharges DECIMAL(10,2) NOT NULL,
    TotalCharges DECIMAL(10,2) NULL,
    Churn VARCHAR(32) NOT NULL,
    tenure_band VARCHAR(32) NOT NULL,
    tenure_band_order TINYINT UNSIGNED NOT NULL
) CHARACTER SET utf8mb4;

INSERT INTO insightiq.customers (
    customerID, gender, SeniorCitizen, Partner, Dependents, tenure,
    PhoneService, MultipleLines, InternetService, OnlineSecurity,
    OnlineBackup, DeviceProtection, TechSupport, StreamingTV,
    StreamingMovies, Contract, PaperlessBilling, PaymentMethod,
    MonthlyCharges, TotalCharges, Churn, tenure_band, tenure_band_order
)
SELECT
    TRIM(customerID),
    TRIM(gender),
    CAST(TRIM(SeniorCitizen) AS UNSIGNED),
    TRIM(Partner),
    TRIM(Dependents),
    CAST(TRIM(tenure) AS UNSIGNED),
    TRIM(PhoneService),
    TRIM(MultipleLines),
    TRIM(InternetService),
    TRIM(OnlineSecurity),
    TRIM(OnlineBackup),
    TRIM(DeviceProtection),
    TRIM(TechSupport),
    TRIM(StreamingTV),
    TRIM(StreamingMovies),
    TRIM(Contract),
    TRIM(PaperlessBilling),
    TRIM(PaymentMethod),
    CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2)),
    CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2)),
    TRIM(Churn),
    CASE
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 12 THEN '0-12 months'
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 24 THEN '13-24 months'
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END,
    CASE
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 12 THEN 1
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 24 THEN 2
        WHEN CAST(TRIM(tenure) AS UNSIGNED) <= 48 THEN 3
        ELSE 4
    END
FROM insightiq.telco_raw;



SELECT
    COUNT(*) AS clean_customers,
    COUNT(DISTINCT customerID) AS unique_customer_ids,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS null_total_charges,
    SUM(MonthlyCharges) AS sum_monthly_charges,
    SUM(TotalCharges) AS sum_nonnull_total_charges
FROM insightiq.customers;




SELECT
    tenure_band_order,
    tenure_band,
    COUNT(*) AS customers,
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure
FROM insightiq.customers
GROUP BY tenure_band_order, tenure_band
ORDER BY tenure_band_order;

