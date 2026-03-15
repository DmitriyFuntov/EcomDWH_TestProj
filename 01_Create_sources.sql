USE DWH_Testproj;
GO

IF OBJECT_ID('klienti', 'U') IS NOT NULL
    DROP TABLE klienti;
IF OBJECT_ID('tovari', 'U') IS NOT NULL
    DROP TABLE tovari;
IF OBJECT_ID('zakazi', 'U') IS NOT NULL
    DROP TABLE zakazi;
GO


CREATE TABLE klienti(
	customer_id VARCHAR(50) PRIMARY KEY,
	subname NVARCHAR(100),
	name NVARCHAR (100),
	phone_number VARCHAR(20),
	city NVARCHAR(100),
	Registrated_date DATE
);

CREATE TABLE tovari(
	product_id VARCHAR(50) PRIMARY KEY,
	name NVARCHAR (255),
	Description NVARCHAR (MAX), 
	Price DECIMAL (18,2),
	Weight NVARCHAR(20),
	created_at DATETIME 
);

CREATE TABLE zakazi(
	order_id VARCHAR(50) PRIMARY KEY,
	customer_id VARCHAR (50),
	product_id VARCHAR(50),
	quantity INT,
	order_dt DATE,
	amount DECIMAL,
	status VARCHAR(50),
	created_at DATETIME,
	updated_at DATETIME
);