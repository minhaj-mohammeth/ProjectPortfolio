select *
from superstore_project..Orders
order by 15,16

--COMBINING THE TABLES

select *
from superstore_project..Orders ord
join superstore_project..Returns rtn
	on ord.[Order ID] = rtn.[Order ID]

select *
from superstore_project..Orders ord
join superstore_project..Users usr
	on ord.Region = usr.Region

--Get Full Order Details With status

select ord.[Order ID],ord.[Customer Name],ord.[Product Name],ord.Region,rtn.Status,ord.Sales,ord.Profit
from superstore_project..Orders ord
join superstore_project..Returns rtn
ON ord.[Order ID] = rtn.[Order ID]
order by ord.Region

--Respective Managers That Handled The Orders

SELECT ord.[Order ID],ord.[Customer Name],ord.Region,usr.Manager,ord.Sales,ord.[Ship Date]
FROM 
    superstore_project..Orders ord
join superstore_project..Users usr
on ord.Region = usr.Region
order by ord.Region

-- Combining All The Data

SELECT ord.[Order ID],ord.[Customer Name],ord.[Product Name],ord.Region,usr.Manager,rtn.Status,ord.[Order Date],ord.Sales,ord.Profit
FROM 
	superstore_project..Orders ord
join superstore_project..Users usr
on ord.region = usr.Region
join superstore_project..Returns rtn
on ord.[Order ID] = rtn.[Order ID]

--Top 5 Products By Sales

SELECT top 5
    [Product Name],
    SUM(Sales) AS Total_Sales
FROM 
    superstore_project..Orders
GROUP BY 
    [Product Name]
ORDER BY 
    Total_Sales DESC

--Total Profit by Region with Manager Name

SELECT 
    ord.Region,
    usr.Manager,
    SUM(ord.Profit) AS Total_Profit
FROM 
   superstore_project..Orders ord
JOIN 
    superstore_project..Users usr
 on ord.region = usr.Region
GROUP BY 
    ord.Region, usr.Manager
ORDER BY 
    Total_Profit DESC

--Most Common Product Container Used

SELECT 
    [Product Container],
    COUNT(*) AS Container_Count
FROM 
    superstore_project..Orders
GROUP BY 
    [Product Container]
ORDER BY 
    Container_Count DESC

--Late Delivered Orders (Ship Date > Order Date)

SELECT 
    [Order ID],
    [Customer Name],
    [Order Date],
    [Ship Date],
    DATEDIFF(DAY,[Order Date],[Ship Date]) AS [Delivery Days]
FROM 
    superstore_project..Orders
WHERE 
    [Ship Date] > [Order Date]
ORDER BY 
    [Delivery Days] DESC

-- Sales Performance of Each Manager

SELECT 
    usr.Manager,
    COUNT(ord.[Order ID]) AS Total_Orders,
    SUM(ord.Sales) AS Total_Sales,
    SUM(ord.Profit) AS Total_Profit
FROM 
    superstore_project..Orders ord
JOIN 
    superstore_project..Users usr
    on ord.region = usr.Region
GROUP BY 
    usr.Manager
ORDER BY 
    Total_Sales DESC

--Return Count

SELECT 
    rtn.Status,
    COUNT(ord.[Order ID]) AS Total_Orders,
    SUM(ord.Sales) AS Total_Sales
FROM 
     superstore_project..Orders ord
JOIN 
    superstore_project..Returns rtn
on  ord.[Order ID] = rtn.[Order ID]
GROUP BY 
    rtn.Status;

--

SELECT 
    CASE 
        WHEN rtn.[Order ID] IS NOT NULL THEN 'Returned'
        ELSE 'Delivered'
    END AS Order_Status,
    COUNT(ord.[Order ID]) AS Total_Orders,
    SUM(ord.Sales) AS Total_Sales
FROM 
    superstore_project..Orders ord
LEFT JOIN 
    superstore_project..Returns rtn
    ON ord.[Order ID] = rtn.[Order ID]
GROUP BY 
    CASE 
        WHEN rtn.[Order ID] IS NOT NULL THEN 'Returned'
        ELSE 'Delivered'
    END

--Customer Lifetime Value (Top 10 Customers by Sales)

SELECT top 10
    ord.[Customer ID],
    ord.[Customer Name],
    SUM(ord.Sales) AS Lifetime_Sales,
    SUM(ord.Profit) AS Total_Profit
FROM 
     superstore_project..Orders ord
GROUP BY 
    ord.[Customer ID], ord.[Customer Name]
ORDER BY 
    Lifetime_Sales DESC

