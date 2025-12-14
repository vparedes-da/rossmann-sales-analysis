#Verificación de estructura y formato: Entendiendo lo que nos muestra cada tabla y columna se procede a verificar formatos,
#consistencia de los datos,etc.

#1. Se verifica la cantidad de datos en la tabla de train importada en MySQL Workbench, inicialmente se verificó la cantidad de datos
#en el archivo original (CSV)

select
count(*) as number_rows
from train;

#Ahora se verificará el tipo de dato de las columnas

describe train;
describe test;
describe store;
describe store_state;



-- Verificación de la consistencia y calidad de los datos de las columnas en cada tabla

-- 1. Fechas con ventas pero cerradas
select 
store,
count(store)
from train
where Open = 0 AND Sales > 0
group by store
;

select 
*
from train
where Open = 0 AND Sales > 0;

-- 2. Clientes con tienda cerrada

select
* 
from train
where customers >0 and Open = 0; 

-- 3. Clientes sin ventas
select
* 
from train
where customers >0 and Sales = 0; 
-- Hay un hallazgo, mantener presente.

-- 4. Columnas categóricas mal codificadas
-- StateHoliday, StoreType, Assortment, PromoInterval

SELECT storetype, count(storetype)
from store
group by storetype;

SELECT PromoInterval, count(PromoInterval)
from store
group by PromoInterval;

SELECT Assortment, count(Assortment) 
from store
group by Assortment;

SELECT Stateholiday, count(Stateholiday) 
from train
group by Stateholiday;

-- Consulta generalizada/automatizada

SET @database = 'rossmann_store_sales';
SET @table_name = 'store';

SELECT GROUP_CONCAT(
  CONCAT(
    'SELECT ''', column_name, ''' AS column_name, ',
    column_name, ' AS value, COUNT(*) AS count ',
    'FROM ', @database, '.', @table_name, ' ',
    'GROUP BY ', column_name
  ) SEPARATOR ' UNION ALL '
) INTO @sql_query -- Esta función me pone la consulta en una variable
FROM information_schema.columns
WHERE table_schema = @database
  AND table_name = @table_name
  AND data_type IN ('varchar','char','text');

SELECT @sql_query;

PREPARE stmt FROM @sql_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


/*Dado que se encontraron 544 Null en PromoInterval, verificaremos si estos pertenecen a aquellas tiendas que no participan en
promociones recurrentes/ciclicas
*/
  
  select
  Promo2,
  COUNT(*) AS Participacion
  from store
  where PromoInterval is Null
  Group by Promo2; -- Dicha consulta me arroja 0, lo que quiere decir y la cantidad es 544, lo que coincide con los NULL hallados anteriormente.
 
-- verificación de los valores nulos en las tablas.

SELECT
concat(
'select ' ,
 group_concat(
  concat(
 'sum(case when ', COLUMN_NAME ,' IS NULL THEN 1 ELSE 0 END) AS ' ,COLUMN_NAME , ''
   ) 
   separator ', '
 ),
 ' FROM train;'
) AS sql_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'train'
AND TABLE_SCHEMA = 'rossmann_store_sales';


 
-- Resultado de la consulta anterior
 select sum(case when Store IS NULL THEN 1 ELSE 0 END) AS Store, 
 sum(case when DayOfWeek IS NULL THEN 1 ELSE 0 END) AS DayOfWeek, 
 sum(case when Date IS NULL THEN 1 ELSE 0 END) AS Date, 
 sum(case when Sales IS NULL THEN 1 ELSE 0 END) AS Sales, 
 sum(case when Customers IS NULL THEN 1 ELSE 0 END) AS Customers, 
 sum(case when Open IS NULL THEN 1 ELSE 0 END) AS Open, 
 sum(case when Promo IS NULL THEN 1 ELSE 0 END) AS Promo, 
 sum(case when StateHoliday IS NULL THEN 1 ELSE 0 END) AS StateHoliday, 
 sum(case when SchoolHoliday IS NULL THEN 1 ELSE 0 END) AS SchoolHoliday 
 FROM train;

-- Verificación de formato correcto en la columna date

Select column_name, data_type
from information_schema.columns
where table_name = 'train'
 and column_name = 'Date' -- El resultado nos arroja correcto. Es date
 
 -- Ahora extraeremos sus partes para un mejor análisis
 
 Select
  Date,
  year(Date) as year,
  month(Date) as month,
  day(Date) as day,
  week(Date, 3) as week, -- (Date,3) Para que la semana empiece el lunes y no domingo
  dayofweek(date) as day_of_week
  from train; 
  /* dayofweek 1= Domingo , 7 = Sábado */
 
 # Revisaremos si hay fechas fuera de rango fuera de rango
 
 Select
 min(Date) as MinDate,
 max(Date) as MaxDate
 From train;
 
 
 #Revisión de la unicidad e integridad 
 
 -- Verificación de indentificador único
 -- Revisión de duplicados en la combinación (Tienda + Date)
 
 select
 total_registros
 from (Select
 id,
 count(*) as total_registros
 from test
 group by id) as registros
 where total_registros > 1 ;
-- Revisión de duplicados Store iD
select
 total_registros
 from (Select
 store,
 count(*) as total_registros
 from store
 group by store) as registros
 where total_registros > 1 ;

#Consistencia entre tablas

-- Tiendas en Train que no están en store

Select distinct t.store
from train t
left join store s on t.store + s.Store
where s.store is null; 

-- Tiendas en store que nunca aparecen en train 

select distinct s.store
from store s 
left join train t ON s.store = t.store
where t.store is null;

-- Tiendas en test que no están store

select te.store
from test te
left join store s on te.store = s.store
where s.store is null;

-- Tiendas en test que no aparecen train

select te.store
from test te
left join train t on te.store = t.store
where t.store is null;

-- Tiendas en store que no están ni en train ni en test
SELECT DISTINCT s.Store
FROM store s
LEFT JOIN train t ON s.Store = t.Store
LEFT JOIN test te ON s.Store = te.Store
WHERE t.Store IS NULL AND te.Store IS NULL;


