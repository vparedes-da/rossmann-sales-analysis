/* Variables LAG (rezagadas)*/

-- Es bueno crear otra tabla para evitar errores y darle un enfoque modular que se usa en ingenieria de datos y ciencia de data profesional. 

# Creación de tabla con tiendas ordenas para crear LAGs más facil para el servidor
create table sales_sorted as
select *
from train
order by store, date;

DESCRIBE sales_sorted;
SELECT * from sales_sorted;


#Calculo del LAG sobre la tabla anterior (Ya estará ordenada por store y date, por lo tanto no tendrá que hacer este proceso)

# LAGs sales
drop table if exists sales_lags;
create table sales_lags as
select
     Store,
     Date,
     Sales,
     Customers,
     
     LAG(Sales, 1) OVER (PARTITION BY Store ORDER BY Date) AS Sales_Lag_1,
     LAG(Sales, 7) OVER (PARTITION BY Store ORDER BY Date) AS Sales_Lag_7,
     LAG(Sales, 30) OVER (PARTITION BY Store ORDER BY Date) AS Sales_Lag_30
     
     FROM sales_sorted;
# LAGs Customers 
     drop table if exists sales_lags_2;
     create table sales_lags_2 as
     
     select
     Store,
     Date,
     Customers,
     LAG(Customers, 1) OVER (PARTITION BY Store ORDER BY Date) AS Customers_Lag_1,
	 LAG(Customers, 7) OVER (PARTITION BY Store ORDER BY Date) AS Customers_Lag_7,
	 LAG(Customers, 30) OVER (PARTITION BY Store ORDER BY Date) AS Customers_Lag_30
     
     from sales_lags;
     
     # LAG's Customers & LAG's sales
     
     CREATE TABLE sales_lags_1 as
     
     select
           s.store,
           s.date,
           s.sales,
           s.customers,
           
           s.Sales_Lag_7,
           s.Sales_Lag_30,
           
           c.Customers_Lag_7,
           c.Customers_Lag_30
           
      from sales_lags s 
      left join sales_lags_2 c 
		on s.store = c.store
        and s.date = c.date;
     
    
     