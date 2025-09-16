SELECT *
FROM telco_churn;

-- KPI #1: CHURN RATE
-- BQ: What percentage of customers have churned compared to those who stayed?
SELECT Churn,
		COUNT(*) AS customer_count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn), 2) AS percentage
FROM telco_churn
GROUP BY Churn;

-- KPI #2: CUSTOMER DEMOGRAPHICS
-- BQ: Do men or women churn more often?
-- BQ: Are senior citizents more likely to churn than non-seniors?
-- BQ: Does having a partner or dependents reduce churn?

-- 1. Churn by Gender
SELECT gender,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY gender, Churn
ORDER BY gender, Churn;

-- 2. Churn by SeniorCitizen
SELECT SeniorCitizen,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY SeniorCitizen, Churn
ORDER BY SeniorCitizen, Churn;

-- 3. Churn by Partner
SELECT Partner,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY Partner, Churn
ORDER BY Partner, Churn;

-- 4. Churn by Dependents
SELECT Dependents,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY Dependents, Churn
ORDER BY Dependents, Churn;

-- KPI #3: TENURE ANALYSIS
-- BQ1: What the average tenure (in months) of customers who churned vs those who stayed?
-- BQ2: Are customers with shorter tenure more likely to churn compared to long-tenured customers?

-- 1. Average Tenure by Churn
SELECT Churn,
		ROUND(AVG(tenure), 2) AS avg_tenure,
        MIN(tenure) AS min_tenure,
        MAX(tenure) AS max_tenure
FROM telco_churn
GROUP BY Churn;

-- 2. Churn by Tenure Groups (e.g, buckets)
SELECT CASE
			WHEN tenure BETWEEN 0 AND 12 THEN "0-12 months"
            WHEN tenure BETWEEN 13 AND 24 THEN "13-24 months"
            WHEN tenure BETWEEN 25 AND 48 THEN "25-48 months"
            ELSE "49+ months"
            END AS tenure_group,
            CHURN,
            COUNT(*) AS Customer_count
FROM telco_churn
GROUP BY tenure_group, Churn
ORDER BY tenure_group, Churn;


-- KPI #4: SERVICES ANALYSIS
-- BQ1: Does the type of internet service affect churn?
-- BQ2: Do customers with extra services (like OnlineSecurity, TechSupport, DeviceProtection, etc.) churn less?
-- BQ3: Are standing services (TV, Movies) linked to higher or lower churn?

-- 1. Churn by Internet Service
SELECT InternetService,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY InternetService, Churn
ORDER BY InternetService, Churn;

-- 2. Churn by TechSupport
SELECT TechSupport,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY TechSupport, Churn
ORDER BY TechSupport, Churn;

-- 3. Churn by OnlineSecurity
SELECT OnlineSecurity,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY OnlineSecurity, Churn
ORDER BY OnlineSecurity, Churn;

-- 4. Churn by DeviceProtection
SELECT DeviceProtection,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY DeviceProtection, Churn
ORDER BY DeviceProtection, Churn;

-- 5. Churn by Streaming Services
SELECT StreamingTV,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY StreamingTV, Churn
ORDER BY StreamingTV, Churn;

SELECT StreamingMovies,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY StreamingMovies, Churn
ORDER BY StreamingMovies, Churn;

-- KPI #5: CONTRACT & BILLING
-- BQ1: Which contract type has the highest churn rate: Month-to-month, one year, or two years?
-- BQ2: Does paperless billing impact churn?
-- BQ3: Does the choice of payment method affect churn (e.g, Electronic check vs. Bank transfer)?

-- 1. Churn by Contract type
SELECT Contract,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY Contract, Churn
ORDER BY Contract, Churn;

-- 2. Churn by Paperless Billing
SELECT PaperlessBilling,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY PaperlessBilling, Churn
ORDER BY PaperlessBilling, Churn;

-- 3. Churn by Payment Method
SELECT PaymentMethod,
		Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY PaymentMethod, Churn
ORDER BY PaymentMethod, Churn;

-- KPI #6: FINANCIAL METRICS
-- BQ1: What is the average MonthlyCharges of churned vs retained customers?
-- BQ2: What is the average TotalCharges of churned vs retained customers?
-- BQ3: How does revenue (MonthlyCharges x number of customers) differ between churned and non-churned customers?
-- BQ4: Which contract type generates the highest revenue?

-- 1. Average MonthlyCharges by Churn
SELECT Churn,
		ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
        ROUND(MIN(MonthlyCharges), 2) AS min_monthly_charges,
        ROUND(MAX(MonthlyCharges), 2) AS max_monthly_charges
FROM telco_churn
GROUP BY Churn;

-- 2. Average TotalCharges by Churn
SELECT Churn,
		ROUND(AVG(CAST(TotalCharges AS DECIMAL(10,2))), 2) AS avg_total_charges,
        ROUND(MIN(CAST(TotalCharges AS DECIMAL(10,2))), 2) AS min_total_charges,
        ROUND(MAX(CAST(TotalCharges AS DECIMAL(10,2))), 2) AS max_total_charges
FROM telco_churn
WHERE TotalCharges != " "
GROUP BY Churn;

-- 3. Revenue Contribution by Churn
SELECT Churn,
		ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue
FROM telco_churn
GROUP BY Churn;

-- 4. Revenue by Contract Type
SELECT Contract,
		ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
        ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM telco_churn
GROUP BY Contract
ORDER BY total_monthly_revenue DESC;

-- KPI #7: HIGH-RISK SEGMENTS
-- BQ1: Which customer segments (contract type + payment method + internet service) have the highest churn rates?
-- BQ2: Do customers with specific service combinations (e.g, Fiber optic + No TechSupport) churn more?
-- BQ3: Can we identify the top risky profiles that the business should focus retention efforts on?

-- 1. Churn by Contract + Payment Method
SELECT Contract,
		PaymentMethod,
        Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY Contract, PaymentMethod, Churn
ORDER BY Contract, PaymentMethod, Churn;

-- 2. Churn by InternetService + TechSupport
SELECT InternetService,
		TechSupport,
        Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY InternetService, TechSupport, Churn
ORDER BY InternetService, TechSupport, Churn;

-- 3. High-Risk Segments Summary
SELECT Contract,
		InternetService,
        TechSupport,
        Churn,
        COUNT(*) AS customer_count
FROM telco_churn
GROUP BY Contract, InternetService, TechSupport, Churn
ORDER BY customer_count DESC;

-- DONE!




