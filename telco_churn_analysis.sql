USE telco_churn;

SELECT COUNT(*) FROM `telco-customer-churn`;

SELECT * FROM `telco-customer-churn` LIMIT 10;

DESCRIBE `telco-customer-churn`;

#Checking for duplicates
SELECT customerID, COUNT(*) AS count
FROM `telco-customer-churn`
GROUP BY customerID
HAVING COUNT(*) > 1;

#checking null values in key columns
SELECT 
	SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS null_customerID,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS null_churn,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS null_totalcharges,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS null_tenure
FROM `telco-customer-churn`;

SELECT DISTINCT Churn FROM `telco-customer-churn`;

#adds a ChurnFlag column
UPDATE `telco-customer-churn`
SET ChurnFlag = CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END;

#adds a SeniorCitizenFlag column
UPDATE `telco-customer-churn`
SET SeniorCitizenFlag = CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END;

#percentage of customers who have left the platform
SELECT
	COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    COUNT(*) - SUM(ChurnFlag) AS RetainedCustomers,
    ROUND(SUM(ChurnFlag) / COUNT(*) * 100, 2) AS ChurnRate,
    ROUND((COUNT(*) - SUM(ChurnFlag)) / COUNT(*) * 100, 2) AS RetentionRate
FROM `telco-customer-churn`;

#Churn by contract type
SELECT 
	Contract,
    COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    ROUND(SUM(ChurnFlag) / COUNT(*) * 100, 2) AS ChurnRate
FROM `telco-customer-churn`
GROUP BY Contract
ORDER BY ChurnRate DESC;

#Churn by internet service
SELECT
	InternetService,
    COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    ROUND(SUM(ChurnFlag) / COUNT(*) * 100, 2) AS ChurnRate
FROM `telco-customer-churn`
GROUP BY InternetService
ORDER BY ChurnRate DESC;

#Churn by Payment method
SELECT 
	PaymentMethod,
    COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    ROUND(SUM(ChurnFlag) / COUNT(*) * 100, 2) AS ChurnRate
FROM `telco-customer-churn`
GROUP BY PaymentMethod
ORDER BY ChurnRate DESC;

#Churn Rate by senior citizens
SELECT 
	SeniorCitizenFlag,
    COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    ROUND(SUM(ChurnFlag) / COUNT(*) * 100, 2) AS ChurnRate
FROM `telco-customer-churn`
GROUP BY SeniorCitizenFlag
ORDER BY ChurnRate DESC;

#average tenure
SELECT 
	Churn,
    ROUND(AVG(tenure), 2) AS AvgTenure,
    ROUND(MIN(tenure), 2) AS MinTenure,
    ROUND(MAX(tenure), 2) AS MaxTenure
FROM `telco-customer-churn`
GROUP BY Churn;

#Adding the tenure group in the database
ALTER TABLE `telco-customer-churn`
ADD COLUMN TenureGroup TEXT;

UPDATE `telco-customer-churn`
SET TenureGroup = CASE
		WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 Months'
        ELSE '61+ Months'
	END;

#Adding the ChargesGroup in the database
ALTER TABLE `telco-customer-churn`
ADD COLUMN ChargesGroup TEXT;

UPDATE `telco-customer-churn`
SET ChargesGroup = CASE
	WHEN MonthlyCharges BETWEEN 0 AND 30 THEN 'Low ($0-$30)'
    WHEN MonthlyCharges BETWEEN 31 AND 60 THEN 'Medium ($31-$60)'
    WHEN MonthlyCharges BETWEEN 61 AND 90 THEN 'High ($61-$90)'
    ELSE 'Very high ($90+)'
END;

