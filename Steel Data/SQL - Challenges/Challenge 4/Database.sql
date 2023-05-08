-- 1. Create our database.
CREATE DATABASE STEEL_DATA;
GO

-- 2. Select the database to use.
USE STEEL_DATA;
GO

-- 3. Create our own schema for this challenge.
CREATE SCHEMA Ch4;
GO

-- 4. Create the tables to our schema and database.
-- Create the Customers table

CREATE TABLE [Ch4].[Customers] (
	CustomerID	INT PRIMARY KEY,
	FirstName	VARCHAR(50) NOT NULL,
	LastName	VARCHAR(50) NOT NULL,
	City		VARCHAR(50) NOT NULL,
	State		VARCHAR(2) NOT NULL
);

CREATE TABLE [Ch4].[Branches] (
	BranchID	INT PRIMARY KEY,
	BranchName	VARCHAR(50) NOT NULL,
	City		VARCHAR(50) NOT NULL,
	State		VARCHAR(2) NOT NULL
);

CREATE TABLE [Ch4].[Accounts] (
	AccountID	INT PRIMARY KEY,
	CustomerID	INT NOT NULL,
	BranchID	INT NOT NULL,
	AccountType VARCHAR(50) NOT NULL,
	Balance		DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (CustomerID) REFERENCES [Ch4].[Customers](CustomerID),
	FOREIGN KEY (BranchID) REFERENCES [Ch4].[Branches](BranchID)
);

CREATE TABLE [Ch4].[Transactions] (
	TransactionID	INT PRIMARY KEY,
	AccountID		INT NOT NULL,
	TransactionDate DATE NOT NULL,
	Amount			DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (AccountID) REFERENCES [Ch4].[Accounts](AccountID)
);


-- 5. Insert the values of each tables.
INSERT INTO [Ch4].[Customers] (CustomerID, FirstName, LastName, City, State)
VALUES 
	(1, 'John', 'Doe', 'New York', 'NY'),
	(2, 'Jane', 'Doe', 'New York', 'NY'),
	(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
	(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
	(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
	(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');

INSERT INTO [Ch4].[Branches] (BranchID, BranchName, City, State)
VALUES 
	(1, 'Main', 'New York', 'NY'),
	(2, 'Downtown', 'San Francisco', 'CA'),
	(3, 'West LA', 'Los Angeles', 'CA'),
	(4, 'East LA', 'Los Angeles', 'CA'),
	(5, 'Uptown', 'New York', 'NY'),
	(6, 'Financial District', 'San Francisco', 'CA'),
	(7, 'Midtown', 'New York', 'NY'),
	(8, 'South Bay', 'San Francisco', 'CA'),
	(9, 'Downtown', 'Los Angeles', 'CA'),
	(10, 'Chinatown', 'New York', 'NY'),
	(11, 'Marina', 'San Francisco', 'CA'),
	(12, 'Beverly Hills', 'Los Angeles', 'CA'),
	(13, 'Brooklyn', 'New York', 'NY'),
	(14, 'North Beach', 'San Francisco', 'CA'),
	(15, 'Pasadena', 'Los Angeles', 'CA');

INSERT INTO [Ch4].[Accounts] (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES 
	(1, 1, 5, 'Checking', 1000.00),
	(2, 1, 1, 'Savings', 5000.00),
	(3, 2, 1, 'Checking', 2500.00),
	(4, 2, 7, 'Savings', 10000.00),
	(5, 3, 2, 'Checking', 7500.00),
	(6, 3, 3, 'Savings', 15000.00),
	(7, 4, 8, 'Checking', 5000.00),
	(8, 4, 2, 'Savings', 20000.00),
	(9, 5, 14, 'Checking', 10000.00),
	(10, 5, 4, 'Savings', 50000.00),
	(11, 6, 3, 'Checking', 5000.00),
	(12, 6, 3, 'Savings', 10000.00),
	(13, 1, 12, 'Credit Card', -500.00),
	(14, 2, 6, 'Credit Card', -1000.00),
	(15, 3, 4, 'Credit Card', -2000.00);


INSERT INTO [Ch4].[Transactions] (TransactionID, AccountID, TransactionDate, Amount)
VALUES 
	(1, 1, '2022-01-01', -500.00),
	(2, 1, '2022-01-02', -250.00),
	(3, 2, '2022-01-03', 1000.00),
	(4, 3, '2022-01-04', -1000.00),
	(5, 3, '2022-01-05', 500.00),
	(6, 4, '2022-01-06', 1000.00),
	(7, 4, '2022-01-07', -500.00),
	(8, 5, '2022-01-08', -2500.00),
	(9, 6, '2022-01-09', 500.00),
	(10, 6, '2022-01-10', -1000.00),
	(11, 7, '2022-01-11', -500.00),
	(12, 7, '2022-01-12', -250.00),
	(13, 8, '2022-01-13', 1000.00),
	(14, 8, '2022-01-14', -1000.00),
	(15, 9, '2022-01-15', 500.00);