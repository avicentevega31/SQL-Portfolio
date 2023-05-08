-- Select the database to use.
USE STEEL_DATA;
GO

-- Preview of the main tables of the schema.
SELECT * FROM Ch4.Accounts;
SELECT * FROM Ch4.Branches;
SELECT * FROM Ch4.Customers;
SELECT * FROM Ch4.Transactions;
GO


-- 1. What are the names of all the customers who live in New York?
SELECT DISTINCT CONCAT_WS(', ', LastName, FirstName) AS [Customer Name] 
FROM Ch4.Customers
WHERE TRIM(UPPER(CITY)) = N'NEW YORK';
GO

-- 2. What is the total number of accounts in the Accounts table?
SELECT COUNT(DISTINCT AccountID) AS [Total N° of Accounts] 
FROM Ch4.Accounts;
GO

-- 3. What is the total balance of all checking accounts?
SELECT CAST(SUM(Balance) AS MONEY) AS [Total Balance] 
FROM Ch4.Accounts
WHERE TRIM(UPPER(AccountType)) = N'CHECKING';
GO

-- 4. What is the total balance of all accounts associated with customers who live in Los Angeles?
SELECT CAST(SUM(A.Balance) AS MONEY) AS [Total Balance]
FROM Ch4.Accounts AS A
LEFT JOIN (SELECT * FROM Ch4.Customers) AS C
ON (A.CustomerID = C.CustomerID)
WHERE TRIM(UPPER(C.City)) = N'LOS ANGELES';
GO

SELECT CAST(SUM(Balance) AS MONEY) AS [Total Balance] FROM ( 
	SELECT A.* FROM Ch4.Accounts AS A
	LEFT JOIN (SELECT * FROM Ch4.Customers) AS C
	ON (A.CustomerID = C.CustomerID)
	WHERE TRIM(UPPER(C.City)) = N'LOS ANGELES'
) AS A;
GO

-- 5. Which branch has the highest average account balance?
SELECT B.*, A.[Avg. Account Balance] AS [Avg. Account Balance] 
FROM Ch4.Branches B 
INNER JOIN (
	SELECT TOP 1 BranchID, CAST(ROUND(AVG(Balance), 2) AS MONEY) AS [Avg. Account Balance] 
	FROM Ch4.Accounts
	GROUP BY BranchID 
	ORDER BY 2 DESC
) A
ON (B.BranchID = A.BranchID);
GO

SELECT TOP 1 B.BranchName, CAST(ROUND(AVG(A.Balance), 2) AS MONEY) AS [Avg. Account Balance]
FROM Ch4.Branches AS B
INNER JOIN Ch4.Accounts AS A
ON (B.BranchID = A.BranchID)
GROUP BY B.BranchName
ORDER BY 2 DESC;
GO

-- 6. Which customer has the highest current balance in their accounts?
SELECT CONCAT_WS(', ', C.LastName, C.FirstName) AS [Customer Name], A.[Current Balance] AS [Current Balance] 
FROM Ch4.Customers C 
INNER JOIN (
	SELECT TOP 1 CustomerID, CAST(ROUND(SUM(Balance), 2) AS MONEY) AS [Current Balance] 
	FROM Ch4.Accounts
	GROUP BY CustomerID 
	ORDER BY 2 DESC
) A
ON (C.CustomerID = A.CustomerID);
GO

SELECT C.*, A.CurrentBalance AS MaxCurrentBalance FROM Ch4.Customers C 
INNER JOIN (
	SELECT TOP 1 CustomerID, CAST(ROUND(SUM(NetBalance), 2) AS MONEY) AS CurrentBalance 
	FROM Ch4.NetAccounts
	GROUP BY CustomerID 
	ORDER BY 2 DESC
) A
ON (C.CustomerID = A.CustomerID);
GO

-- 7. Which customer has made the most transactions in the Transactions table?
WITH 
T1 AS (
	SELECT 
		C.CustomerID,
		CONCAT_WS(', ', C.LastName, C.FirstName) AS [Customer Name],
		COUNT(T.TransactionID) AS [N° of Transactions],
		DENSE_RANK() OVER(ORDER BY COUNT(T.TransactionID) DESC) AS [Ranking]
	FROM Ch4.Transactions AS T
	INNER JOIN Ch4.Accounts AS A
	ON (T.AccountID = A.AccountID)
	INNER JOIN Ch4.Customers AS C
	ON (C.CustomerID = A.CustomerID)
	GROUP BY CONCAT_WS(', ', C.LastName, C.FirstName), C.CustomerID
)
SELECT [Customer Name], [N° of Transactions]  
FROM T1 
WHERE Ranking = 1 
ORDER BY CustomerID ASC;
GO

WITH 
T1 AS (
	SELECT CustomerID, COUNT(TransactionID) AS QTransaction FROM (
		SELECT T.TransactionID, T.AccountID, A.CustomerID FROM Ch4.Transactions T
		LEFT JOIN (SELECT * FROM Ch4.Accounts) A
		ON (T.AccountID = A.AccountID)
	) AS X
	GROUP BY CustomerID
),
T2 AS (	
	SELECT * FROM T1
	WHERE QTransaction = (SELECT MAX(QTransaction) FROM T1)
)
SELECT C.* FROM Ch4.Customers AS C 
INNER JOIN (SELECT * FROM T2) T2
ON (C.CustomerID = T2.CustomerID)
GO

-- 8.Which branch has the highest total balance across all of its accounts?
SELECT B.BranchName, A.[Total Balance] 
FROM  Ch4.Branches AS B
INNER JOIN (
	SELECT TOP 1 A.BranchID, CAST(SUM(A.Balance) AS MONEY) AS [Total Balance]
	FROM Ch4.Accounts AS A GROUP BY A.BranchID ORDER BY 2 DESC
) AS A
ON (B.BranchID = A.BranchID);
GO

-- 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
SELECT C.CustomerID, CONCAT_WS(', ', C.LastName, C.FirstName) AS [Customer Name]
FROM Ch4.Customers AS C
INNER JOIN (
	SELECT TOP 1 A.CustomerID, CAST(SUM(A.Balance) AS MONEY) AS [Total Balance]
	FROM Ch4.Accounts AS A
	WHERE TRIM(UPPER(A.AccountType)) IN (N'SAVINGS', N'CHECKING')
	GROUP BY A.CustomerID
	ORDER BY CAST(SUM(A.Balance) AS MONEY) DESC
) AS A
ON (C.CustomerID = A.CustomerID);
GO

-- 10. Which branch has the highest number of transactions in the Transactions table?
WITH T1 AS (
	SELECT TOP 1 A.BranchID, COUNT(DISTINCT T.TransactionID) AS [N° Transactions]
	FROM Ch4.Transactions AS T
	LEFT JOIN Ch4.Accounts AS A
	ON (T.AccountID = A.AccountID)
	GROUP BY A.BranchID
	ORDER BY 2 DESC, 1 ASC
)
SELECT B.BranchID, B.BranchName 
FROM Ch4.Branches AS B 
INNER JOIN T1 AS A 
ON (B.BranchID = A.BranchID);
GO

SELECT A.BranchID, SUM([N° Transactions]) AS [N° Transactions],
DENSE_RANK() OVER(ORDER BY SUM([N° Transactions]) DESC, A.BranchID ASC) AS RNK
FROM Ch4.Accounts AS A
INNER JOIN (
	SELECT AccountID, COUNT(TransactionID) AS [N° Transactions]
	FROM Ch4.Transactions AS T
	GROUP BY AccountID
) AS T
ON (A.AccountID = T.AccountID)
GROUP BY A.BranchID
ORDER BY 2 DESC;