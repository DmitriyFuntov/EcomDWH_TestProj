USE DWH_Testproj;
GO

EXEC Load_dwh;
GO

IF OBJECT_ID('Calculate_Top5', 'P') IS NOT NULL
    DROP PROCEDURE Calculate_Top5;
GO

CREATE PROCEDURE Calculate_Top5
AS
BEGIN
    WITH CitySales AS (
        SELECT 
            c.city,
            p.name AS product_name,
            SUM(o.quantity) AS total_quantity,
            SUM(o.amount) AS total_amount 
        FROM orders o
        JOIN customer c ON o.dwh_customer_if = c.dwh_customer_id
        JOIN products p ON o.dwh_product_id = p.dwh_product_id
        GROUP BY c.city, p.name
    ),
    RankedSales AS (
        SELECT 
            city,
            product_name,
            total_quantity,
            total_amount,
            DENSE_RANK() OVER(PARTITION BY city ORDER BY total_quantity DESC) AS item_rank
        FROM CitySales
    )
    SELECT 
        item_rank,
        city,
        product_name,
        total_quantity,
        total_amount
    FROM RankedSales
    WHERE item_rank <= 5
    ORDER BY city, total_quantity DESC;
END;
GO

EXEC Calculate_Top5;
