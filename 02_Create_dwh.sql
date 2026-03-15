USE DWH_Testproj;
GO

IF OBJECT_ID('customer', 'U') IS NOT NULL
    DROP TABLE customer;
IF OBJECT_ID('products', 'U') IS NOT NULL
    DROP TABLE products;
IF OBJECT_ID('orders', 'U') IS NOT NULL
    DROP TABLE orders;
GO

CREATE TABLE customer(
	dwh_customer_id INT IDENTITY(1,1) PRIMARY KEY,
	customer_id VARCHAR(50),
	subname VARCHAR(100),
	name NVARCHAR(100),
	phone_number VARCHAR(20),
	city NVARCHAR(100),
	Registrated_date DATE
);

CREATE TABLE products(
	dwh_product_id INT IDENTITY(1,1),
	product_id VARCHAR(50),
	name NVARCHAR(100),
	Description NVARCHAR(MAX),
	price DECIMAL(18,2),
	weight DECIMAL(18,3),
	created_at DATETIME
);

CREATE TABLE orders(
	dwh_order_id INT IDENTITY(1,1),
	order_id VARCHAR(50),
	dwh_customer_if INT,
	dwh_product_id INT,
	quantity INT,
	order_dt DATETIME,
	amount DECIMAL(18,2),
	status VARCHAR(50),
	created_at DATETIME,
	updated_at DATETIME
);