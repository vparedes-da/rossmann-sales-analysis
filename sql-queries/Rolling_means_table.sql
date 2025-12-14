# ROLING MEANS

-- Suavizan el ruido diario. Las ventas pueden variar mucho día a día. El RM crea una tendencia más estable
-- También ayuda al modelo a entender la inercia reciente. Ej: Si en los últimos 7 días ha habido una tendencia a subir, el RM7 lo captura.alter
-- Un lag es 1 punto en el tiempo, un rolling mean captura una tendencia completa. También son muy útiles en series temporales.

-- Parte 1 (por el tamaño de los datos)


/* SALES */
drop table if exists sales_rolling_p1;
CREATE TABLE sales_rolling_p1 AS
SELECT
    Store,
    Date,
    Sales,
    Customers,
CASE 
    WHEN COUNT(Sales) OVER (
         PARTITION BY Store
         ORDER BY Date
         ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
         ) = 7
         
    THEN AVG(Sales) OVER (
        PARTITION BY Store
        ORDER BY Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) 
    ELSE NULL
    END AS Sales_Rolling_7
    
    FROM sales_sorted;
    
    select sales, sales_rolling_7 from sales_rolling_p1;
    
-- Parte 2
CREATE TABLE sales_rolling_p2 AS
SELECT
    Store,
    Date,
    Sales,
    Customers,
CASE
    WHEN COUNT(Sales) OVER (
         PARTITION BY Store
         ORDER BY Date
         ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
         ) = 30
   THEN AVG(Sales) OVER (
        PARTITION BY Store
        ORDER BY Date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) 
    ELSE NULL
    END AS Sales_Rolling_30

FROM sales_sorted;


-- SALES ROLLING : Union de ambas tablas
CREATE TABLE sales_rolling_7_30 as
SELECT 
    o.Store,
    o.Date,
    o.Sales,
    o.Customers,
    o.sales_rolling_7,
    t.sales_rolling_30
    
from sales_rolling_p1 as o
left join sales_rolling_p2 t
            on o.store = t.store
		    and o.date = t.date;
  
    
    
/*CUSTOMERS*/    
    
drop table if exists customers_rolling_p1;
CREATE TABLE customers_rolling_p1 AS
SELECT
    Store,
    Date,
    Sales,
    Customers,
CASE

     WHEN COUNT(customers) OVER (
        PARTITION BY Store
        ORDER BY Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	 ) = 7
     THEN AVG(customers) OVER (
        PARTITION BY Store
        ORDER BY Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	 )
      ELSE NULL
     END AS customers_Rolling_7
 
 FROM sales_sorted;
 
 
drop table if exists customers_rolling_p2;
CREATE TABLE customers_rolling_p2 AS
SELECT
    Store,
    Date,
    Sales,
    Customers,
    CASE
         WHEN COUNT(customers) OVER (
         PARTITION BY Store
         ORDER BY Date
         ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
	  ) = 30
     THEN AVG(customers) OVER (
        PARTITION BY Store
        ORDER BY Date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
	 )
      ELSE NULL
     END AS customers_Rolling_30
 
FROM sales_sorted;


CREATE TABLE customers_rolling_7_30 as

Select
	 o.store,
     o.date,
     o.sales,
     o.customers,
     
     o.customers_rolling_7,
     t.customers_rolling_30
     
from customers_rolling_p1 o
left join customers_rolling_p2 t
          on o.store = t.store
		  and o.date = t.date; 
     


drop table if exists rolling_means;
CREATE TABLE rolling_means as
SELECT
      s.store,
      s.date,
      s.sales,
      s.customers,
      
      s.sales_rolling_7,
	  s.sales_rolling_30,
      
      c.customers_rolling_7,
	  c.customers_rolling_30
      
      from sales_rolling_7_30 s 
      left join customers_rolling_7_30 c
           on s.store = c.store
           and s.date = c.date;
           
 select * from rolling_means;         
 