SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM insightiq.customers;


SELECT
    COUNT(*) AS churned_customers,
    SUM(MonthlyCharges) AS monthly_charges_of_churned_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge_churned
FROM insightiq.customers
WHERE Churn = 'Yes';


SELECT
    Contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM insightiq.customers
GROUP BY Contract
ORDER BY churn_pct DESC, Contract;


SELECT
    tenure_band,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM insightiq.customers
GROUP BY tenure_band_order, tenure_band
ORDER BY tenure_band_order;


SELECT
    InternetService,
    TechSupport,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM insightiq.customers
WHERE InternetService IN ('DSL', 'Fiber optic')
GROUP BY InternetService, TechSupport
ORDER BY InternetService, TechSupport;


SELECT
    PaymentMethod,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM insightiq.customers
GROUP BY PaymentMethod
ORDER BY churn_pct DESC, PaymentMethod;


WITH charge_groups AS (
    SELECT Churn,
        CASE
            WHEN MonthlyCharges < 35 THEN 'Below 35'
            WHEN MonthlyCharges < 70 THEN '35 to <70'
            WHEN MonthlyCharges < 100 THEN '70 to <100'
            ELSE '100+'
        END AS monthly_charge_band,
        CASE
            WHEN MonthlyCharges < 35 THEN 1
            WHEN MonthlyCharges < 70 THEN 2
            WHEN MonthlyCharges < 100 THEN 3
            ELSE 4
        END AS charge_band_order
    FROM insightiq.customers
)
SELECT
    monthly_charge_band,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS churn_pct
FROM charge_groups
GROUP BY charge_band_order, monthly_charge_band
ORDER BY charge_band_order;


WITH segment_summary AS (
    SELECT
        Contract,
        tenure_band,
        tenure_band_order,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS monthly_charges_churned
    FROM insightiq.customers
    GROUP BY Contract, tenure_band, tenure_band_order
)
SELECT
    RANK() OVER (ORDER BY monthly_charges_churned DESC) AS charges_rank,
    Contract,
    tenure_band,
    customers,
    churned_customers,
    ROUND(100.0 * churned_customers / NULLIF(customers, 0), 2) AS churn_pct,
    monthly_charges_churned
FROM segment_summary
ORDER BY monthly_charges_churned DESC, Contract, tenure_band_order;

WITH contract_churn AS (
    SELECT
        Contract,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
    FROM insightiq.customers
    GROUP BY Contract
)
SELECT
    Contract,
    churned_customers,
    ROUND(100.0 * churned_customers / NULLIF(SUM(churned_customers) OVER (), 0), 2) AS pct_of_all_churn
FROM contract_churn
ORDER BY churned_customers DESC, Contract;
