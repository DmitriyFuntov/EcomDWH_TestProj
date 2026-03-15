USE DWH_Testproj;
GO

INSERT INTO klienti (customer_id, subname, name, phone_number, city, Registrated_date)
SELECT TOP(50)
	'CUS' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS VARCHAR),
	CASE (ROW_NUMBER() OVER (ORDER BY (SELECT NULL))%3)
		WHEN 0 THEN 'Иванов' WHEN 1 THEN 'Петров' ELSE 'Сидоров' END,
	CASE (ROW_NUMBER() OVER (ORDER BY (SELECT NULL))%2)
		WHEN 1 THEN 'Александр' ELSE 'Иван' END,
	'+79' + CAST(100000000 + ABS(CHECKSUM(NEWID())) % 900000000 AS VARCHAR),
	CASE (ROW_NUMBER() OVER (ORDER BY (SELECT NULL))%4)
		WHEN 1 THEN 'Москва' WHEN 2 THEN 'Санкт-Петербург' WHEN 3 THEN 'Самара' ELSE 'Сургут' END,
	DATEADD (DAY, - (ABS(CHECKSUM(NEWid())) % 365), GETDATE())
FROM sys.all_columns a CROSS JOIN sys.all_columns b; 


INSERT INTO tovari (product_id, name, Description, Price, Weight, created_at)
VALUES 
('PRC001', 'Йогурт Чудо', 'Вкусный йогурт клубничный, 150 г.', 65.50, NULL, '2024-12-01 10:00:00'),
('PRC002', 'Огурцы короткоплодные', 'Свежие овощи из теплицы, 1 кг.', 120.00, NULL, '2024-12-01 10:05:00'),
('PRC003', 'Фисташки соленые', 'Обжаренные орехи, упаковка 200г', 450.00, NULL, '2024-12-01 10:10:00'),
('PRC004', 'Молоко Домик в деревне', 'Жирность 3.2%, объем 900 мл', 95.00, NULL, '2024-12-01 10:15:00'),
('PRC005', 'Мука пшеничная', 'Высший сорт, пакет 2 кг.', 140.00, NULL, '2024-12-01 10:20:00'),
('PRC006', 'Масло сливочное', 'Масло 82.5%, пачка 180 г', 210.00, NULL, '2024-12-02 09:00:00'),
('PRC007', 'Сахар-песок', 'Белый сахар, мешок 1000 г', 75.00, NULL, '2024-12-02 09:10:00'),
('PRC008', 'Творог зерненый', 'В сливках, баночка 0.3 кг', 130.00, NULL, '2024-12-02 09:20:00'),
('PRC009', 'Шоколад темный', 'Содержание какао 70%, плитка 90 г.', 110.00, NULL, '2024-12-02 09:30:00'),
('PRC010', 'Яблоки Голден', 'Сладкие яблоки, пакет 1.5 кг', 190.00, NULL, '2024-12-02 09:40:00'),
('PRC011', 'Кофе молотый', 'Арабика 100%, пачка 250 г.', 350.00, NULL, '2024-12-03 11:00:00'),
('PRC012', 'Сыр Российский', 'Нарезка в вакууме, вес 125г', 160.00, NULL, '2024-12-03 11:15:00'),
('PRC013', 'Макароны перья', 'Твердые сорта пшеницы, 450 г.', 85.00, NULL, '2024-12-03 11:30:00'),
('PRC014', 'Рис жасмин', 'Длиннозерный рис, пачка 0.8 кг', 150.00, NULL, '2024-12-03 11:45:00'),
('PRC015', 'Чай черный', 'В пакетиках, упаковка 100 г', 220.00, NULL, '2024-12-04 12:00:00'),
('PRC016', 'Вода минеральная', 'Газированная, бутылка 1.5л', 55.00, NULL, '2024-12-04 12:15:00'),
('PRC017', 'Гречневая крупа', 'Ядрица быстроразваривающаяся, 900 г.', 115.00, NULL, '2024-12-04 12:30:00'),
('PRC018', 'Соль поваренная', 'Помол N1, упаковка 1 кг.', 25.00, NULL, '2024-12-04 12:45:00'),
('PRC019', 'Корм для кошек', 'Сухой корм, пакет 400 г', 280.00, NULL, '2024-12-05 13:00:00'),
('PRC020', 'Картофель', 'Свежий урожай, сетка 2.5 кг', 100.00, NULL, '2024-12-05 13:15:00');

INSERT INTO zakazi (order_id, customer_id, product_id, quantity, order_dt, amount, status, created_at, updated_at)
SELECT TOP (100)
    'ORD' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS VARCHAR),
    (SELECT TOP 1 customer_id FROM klienti WHERE (a.object_id + b.column_id) IS NOT NULL ORDER BY NEWID()),
    (SELECT TOP 1 product_id FROM tovari WHERE (a.object_id + b.column_id) IS NOT NULL ORDER BY NEWID()),
    (ABS(CHECKSUM(NEWID())) % 10) + 1,
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 30), GETDATE()),
    0,
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'NEW' WHEN 1 THEN 'PAID' ELSE 'CANCELLED' END,
    GETDATE(),
    GETDATE()
FROM sys.all_columns a 
CROSS JOIN sys.all_columns b;

UPDATE z
SET z.amount = z.quantity * t.price
FROM zakazi z 
JOIN tovari t ON z.product_id = t.product_id;

