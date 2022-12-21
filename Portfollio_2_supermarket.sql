--How can we avoid canceled orders? 
 
 SELECT SUM(CASE WHEN [Status] = 'Cancelled' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--Total number of Cancelled orders = 20334 out of 143107 (or 14%). Lets see if there is correlation to other metrics.


--Canceled orders that were fulfilled by "Easy Ship" 
SELECT SUM(CASE WHEN [Status] = 'Cancelled' AND [fulfilled-by] = 'Easy Ship' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--Answer is 7737 (or 38% of cancelled orders) so majority were not normal shipping

SELECT SUM(CASE WHEN [Fulfilled-by] = 'Easy Ship' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--44429 out of 143107 (or 31%) so there is a preference of 7% to cancel orders when fulfilled by easy ship. Weak correlation. Lets try another metric 

--Is there a correlaiton with location?
SELECT SUM(CASE WHEN [Status] = 'Cancelled' AND [ship-city] = 'Easy Ship' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];

--First we must find the size of each city (number of orders)
WITH Total_orders ([ship-city],[Status]) AS 
(
SELECT DISTINCT [ship-city], COUNT([Status]) AS [Total_Orders_by_city]
FROM Sales..Amazon_Sale_Report
--WHERE [Status] = 'Cancelled'
GROUP BY [ship-city]
)
SELECT * FROM Total_orders
WHERE [Status] > 10 
ORDER BY [Status] DESC

SELECT DISTINCT [ship-city], COUNT([Status]) AS [Total_Cancels]
FROM Sales..Amazon_Sale_Report
WHERE [Status] = 'Cancelled'
GROUP BY [ship-city]j=
ORDER BY [Total_Cancels] DESC
--6 to 12%, the same as cancelled orders from easy ship

--What about fulfilment? Amazon vs. Merchant
SELECT SUM(CASE WHEN [Fulfilment] = 'Merchant' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--gives 44429 total orders from merchant 
SELECT SUM(CASE WHEN [Fulfilment] = 'Merchant' AND [Status] = 'Cancelled' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--gives 7737, 17% of 44429

SELECT SUM(CASE WHEN [Fulfilment] = 'Amazon' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--gives 98678 total orders from merchant 
SELECT SUM(CASE WHEN [Fulfilment] = 'Amazon' AND [Status] = 'Cancelled' THEN 1 ELSE 0 END) FROM Sales..[Amazon_Sale_Report];
--gives 12597, 13% of 98678
