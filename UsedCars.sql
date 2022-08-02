Tables of the dataset: 

SELECT *
FROM [Portfolio Project].dbo.Price;

SELECT *
FROM [Portfolio Project].dbo.Car_Region;

SELECT *
FROM [Portfolio Project].dbo.Car_Detail;

SELECT * 
FROM [Portfolio Project].dbo.Torque;

------------------------//------------------------------//-------------------------------//--------------------------------//---------------------------------//---------

-- Views for visualization in Tableau Public [Used Cars Market]

-- View 1
-- Checking qty of cars per brand
CREATE VIEW TOTAL_BRANDS_CAR AS
SELECT name AS Brand,
       COUNT(sold) AS TOTAL_CAR_NUMBER
FROM [Portfolio Project].dbo.Price
GROUP BY name;



-- View 2
-- Getting total, sold and not sold qty and sold percentage per brand
CREATE VIEW TOTAL_SOLD_NOTSOLD AS
SELECT t1.name AS BRAND,
       COUNT(CASE
                 WHEN t1.sold = 'Y' THEN t1.sold
                 ELSE NULL
             END) AS SOLD_CAR_NUMBER,
       COUNT(CASE
                 WHEN t1.sold = 'N' THEN t1.sold
                 ELSE NULL
             END) AS NOTSOLD_CAR_NUMBER,
       COUNT(t1.sold) AS TOTAL_CAR_NUMBER,
       COUNT(CASE
                 WHEN t1.sold = 'Y' THEN t1.sold
                 ELSE NULL
             END)*100/COUNT(t1.sold) AS SOLD_PERCENTAGE
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Car_Detail t2 ON t1.Sales_ID = t2.Sales_ID
GROUP BY t1.name;



-- View 3
-- Analyzing total qty and sold percentage of cars, per cars' year 
CREATE VIEW SOLD_PERCENTAGE_CARYEAR AS
SELECT t2.year,
       COUNT(t1.sold) AS TOTAL_CAR_NUMBER,
       COUNT(CASE
                 WHEN t1.sold = 'Y' THEN t1.sold
                 ELSE NULL
             END)*100/COUNT(t1.sold) AS SOLD_PERCENTAGE
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Car_Detail t2 ON t1.Sales_ID = t2.Sales_ID
GROUP BY t2.year;



-- View 4
-- Total qty, revenue and average ticket per State
CREATE VIEW STATE_REVENUE_AVGTICKET AS
SELECT t2.[State or Province],
       COUNT(t1.name) AS Qty,
       SUM(t1.selling_price)*0.069 AS 'REVENUE(R$)',
       (SUM(t1.selling_price)/COUNT(t1.name))*0.069 AS AVG_TICKET
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Car_Region t2 ON t1.Sales_ID = t2.Sales_ID
WHERE t1.sold = 'Y'
GROUP BY t2.[State or Province]
ORDER BY 3 DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;



-- View 5
-- Total sold cars and revenues per city in NY State
CREATE VIEW NY_STATE_BRANDS AS
SELECT t2.City,
       SUM(t1.selling_price)*0.069 AS 'CAR_REVENUE(R$)',
       COUNT(t1.sold) AS CAR_QTY
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Car_Region t2 ON t1.Sales_ID = t2.Sales_ID
WHERE t2.[State or Province] = 'New York'
  AND t1.sold = 'Y'
GROUP BY t2.City
ORDER BY 2 DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- View 6
-- Total sold cars and revenus, per brand in NY State
CREATE VIEW NY_CITIES_REVENUE AS
SELECT t1.name,
       SUM(t1.selling_price)*0.069 AS 'CAR_REVENUE(R$)',
       COUNT(t1.sold) AS CAR_QTY
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Car_Region t2 ON t1.Sales_ID = t2.Sales_ID
WHERE t2.[State or Province] = 'New York'
  AND t1.sold = 'Y'
GROUP BY t1.name
ORDER BY 2 DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;



-- View 7
-- Checking which variables influences in used cars' selling price
CREATE VIEW VARIABLES_ON_CARS_PRICE AS
SELECT t1.Sales_ID,
       t1.name,
       t2.torque,
       t3.owner,
       t3.year,
       t4.[State or Province],
       t1.km_driven,
       t1.selling_price*0.069 AS selling_price,
       t4.City
FROM [Portfolio Project].dbo.Price t1
INNER JOIN [Portfolio Project].dbo.Torque t2 ON t1.Sales_ID = t2.Sales_ID
INNER JOIN [Portfolio Project].dbo.Car_Detail t3 ON t3.Sales_ID = t1.Sales_ID
INNER JOIN [Portfolio Project].dbo.Car_Region t4 ON t4.Sales_ID = t1.Sales_ID
WHERE km_driven = 100000
  AND t1.name = 'Maruti'
  AND t2.torque = '190Nm@ 2000rpm'
  AND t3.owner = 'Second_Owner'
ORDER BY t1.selling_price DESC;
























 









































