USE company;

UPDATE financial_loan
SET
    last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

ALTER TABLE financial_loan
MODIFY last_credit_pull_date DATE,
MODIFY last_payment_date DATE,
MODIFY next_payment_date DATE;

--We need to calculate the total number of loan applications received during a specified period.
-- Additionally, it is essential to monitor the Month-to-Date (MTD) Loan Applications and track changes Month-over-Month (MoM).

SELECT * FROM financial_loan

SELECT COUNT(id) AS MTD_Loan_Applications 
FROM financial_loan

SELECT COUNT(id) AS MTD_Loan_Applications 
FROM financial_loan
WHERE MONTH(issue_date) = 12

SELECT COUNT(id) AS MOM_Loan_Applications 
FROM financial_loan
WHERE MONTH(issue_date) = 11

--Understanding the total amount of funds disbursed as loans is crucial. We also want to keep an eye on the MTD Total Funded Amount and analyse the Month-over-Month (MoM) changes in this metric.
SELECT SUM(loan_amount) as disbursed_amount
FROM financial_loan

SELECT SUM(loan_amount) as disbursed_amount
FROM financial_loan
WHERE MONTH(issue_date) = 12

SELECT SUM(loan_amount) as disbursed_amount
FROM financial_loan
WHERE MONTH(issue_date) = 11

--Total Amount Received: Tracking the total amount received from borrowers is essential for assessing the bank's cash flow and loan repayment. We should analyse the Month-to-Date (MTD) Total Amount Received and observe the Month-over-Month (MoM) changes.
SELECT SUM(total_payment) as amount_received
FROM financial_loan

SELECT SUM(total_payment) as amount_received
FROM financial_loan
WHERE MONTH(issue_date) = 12

SELECT SUM(total_payment) as amount_received
FROM financial_loan
WHERE MONTH(issue_date) = 11

--Average Interest Rate: Calculating the average interest rate across all loans, MTD, and monitoring the Month-over-Month (MoM) variations in interest rates will provide insights into our lending portfolio's overall cost.
SELECT AVG(int_rate)*100 as avg_interest_rate
FROM financial_loan

SELECT AVG(int_rate)*100 as avg_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = 12

SELECT AVG(int_rate)*100 as avg_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = 11

-- Evaluating the average DTI for our borrowers helps us gauge their financial health. We need to compute the average DTI for all loans, MTD, and track Month-over-Month (MoM) fluctuations.

SELECT AVG(dti)*100 AS Average_DTI
FROM financial_loan

SELECT AVG(dti)*100 AS Average_DTI
FROM financial_loan
WHERE MONTH(issue_date) = 12


SELECT AVG(dti)*100 AS Average_DTI
FROM financial_loan
WHERE MONTH(issue_date) = 11

--Good Loan KPIs:
--We need to calculate the percentage of loan applications classified as 'Good Loans.' This category includes loans with a loan status of 'Fully Paid' and 'Current.'
SELECT loan_status
FROM financial_loan

SELECT ((COUNT( CASE 
    WHEN loan_status = "Fully Paid" OR loan_status = "Current" THEN id END)
    / COUNT(id))*100) as Good_loan_applications
FROM financial_loan

--Identifying the total number of loan applications falling under the 'Good Loan' category, which consists of loans with a loan status of 'Fully Paid' and 'Current.'

SELECT COUNT(CASE 
    WHEN loan_status = "Fully Paid" OR loan_status = "Current" THEN id END) as Good_loan_applications
FROM financial_loan

--Determining the total amount of funds disbursed as 'Good Loans.' This includes the principal amounts of loans with a loan status of 'Fully Paid' and 'Current.'

SELECT SUM(loan_amount) AS total_disbursed_amount
FROM financial_loan
WHERE loan_status = "Fully Paid" OR loan_status = "Current"

--Tracking the total amount received from borrowers for 'Good Loans,' which encompasses all payments made on loans with a loan status of 'Fully Paid' and 'Current.'

SELECT SUM(total_payment) AS total_amount
FROM financial_loan

-- Calculating the percentage of loan applications categorized as 'Bad Loans.' This category specifically includes loans with a loan status of 'Charged Off.'
SELECT ((COUNT(CASE
    WHEN loan_status = "Charged Off" THEN id 
END))/COUNT(id)*100) as Bad_loan_applications
FROM financial_loan

-- Identifying the total number of loan applications categorized as 'Bad Loans,' which consists of loans with a loan status of 'Charged Off.'
SELECT COUNT(loan_status) as total_bad_loan_applications
FROM financial_loan
WHERE loan_status = "Charged Off"

--Determining the total amount of funds disbursed as 'Bad Loans.' This comprises the principal amounts of loans with a loan status of 'Charged Off.'
SELECT SUM(loan_amount) as total_bad_loan_disbursed
FROM financial_loan
WHERE loan_status = "Charged Off"

--Tracking the total amount received from borrowers for 'Bad Loans,' which includes all payments made on loans with a loan status of 'Charged Off.'
SELECT SUM(total_payment) as total_bad_loan_applications
FROM financial_loan
WHERE loan_status = "Charged Off"

--Loan Status Grid View
SELECT *
FROM financial_loan

SELECT  
        loan_status,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received,
        (AVG(int_rate)*100) AS Average_Interest_Rate,
        (AVG(dti)*100) AS Average_DTI 
FROM financial_loan
GROUP BY loan_status

--Month-to-Date (MTD) Funded Amount,MTD Amount Received
SELECT 
      loan_status,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
WHERE month(issue_date) = 12
GROUP BY loan_status

--DASHBOARD 2: OVERVIEW

--Monthly Trends by Issue Date
SELECT 
      MONTH(issue_date) AS Month_Number,
      MONTHNAME(issue_date) AS Month_Name,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY  MONTHNAME(issue_date), MONTH(issue_date)
ORDER BY  MONTH(issue_date)

--Regional Analysis by State

SELECT 
        address_state AS State,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY address_state
ORDER BY  State

-- Loan Term Analysis

SELECT 
        term as loan_term,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY loan_term
ORDER BY loan_term

--Employee Length Analysis

SELECT 
        emp_length as Employee_Length,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY Employee_Length
ORDER BY COUNT(id) DESC

--  Loan Purpose Breakdown

SELECT 
        purpose AS Loan_Purpose,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC

--Home Ownership Analysis
SELECT 
        home_ownership,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC
