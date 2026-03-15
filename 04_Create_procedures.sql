
USE DWH_Testproj; 
GO

IF OBJECT_ID('Load_Customers', 'P') IS NOT NULL
    DROP PROCEDURE Load_Customers;
IF OBJECT_ID('Load_products', 'P') IS NOT NULL
    DROP PROCEDURE Load_products;
IF OBJECT_ID('Load_orders', 'P') IS NOT NULL
    DROP PROCEDURE Load_orders;
IF OBJECT_ID('Load_dwh', 'P') IS NOT NULL
    DROP PROCEDURE Load_dwh;
GO

CREATE PROCEDURE Load_Customers
AS
BEGIN
	INSERT INTO customer(customer_id, subname, name, phone_number,city, Registrated_date)
	SELECT 
		src.customer_id, 
		src.subname, 
		src.name, 
		src.phone_number, 
		src.city, src.Registrated_date
	FROM klienti src
	WHERE NOT EXISTS(SELECT 1 FROM customer dwh  WHERE dwh.customer_id = src.customer_id)
END;
GO


CREATE PROCEDURE Load_products
AS
BEGIN
	INSERT INTO products(product_id, name,Description,price,weight,created_at)
	SELECT 
		src.product_id,
		src.name,
		src.Description,
		src.Price,
		TRY_CAST(
			REPLACE(
				REVERSE(
					SUBSTRING(
						REVERSE(src.Description),
						CHARINDEX(' ', REVERSE(src.Description))+1,
						5
					)
				),
			',','.')
		AS DECIMAL(18,3)),
		src.created_at
	FROM tovari src
	WHERE NOT EXISTS(SELECT 1 FROM products dwh WHERE dwh.product_id = src.product_id)
END
GO

CREATE PROCEDURE Load_orders
AS
BEGIN
	INSERT INTO orders(order_id, dwh_customer_if, dwh_product_id, quantity,order_dt,amount,status,created_at,updated_at)
	SELECT 
		src.order_id,
		c.dwh_customer_id,
		p.dwh_product_id,
		src.quantity,
		src.order_dt,
		src.amount,
		src.status,
		src.created_at,
		src.updated_at
	FROM zakazi src
	JOIN customer c ON src.customer_id = c.customer_id
	JOIN products p ON src.product_id = p.product_id
	WHERE NOT EXISTS (SELECT 1 FROM orders dwh WHERE dwh.order_id = src.order_id)
END
GO

CREATE PROCEDURE Load_dwh
AS 
BEGIN
	EXEC Load_Customers;
	EXEC Load_Products;
	EXEC Load_orders;
END
GO
