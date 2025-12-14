DROP TABLE IF EXISTS train_features;
CREATE TABLE train_features AS

SELECT
/* Creación de variables temporales */
t.*,
year(t.Date) as Year,
month(t.Date) as Month,
day(t.Date) as Day,
week(t.Date,3) as `Week`, -- este va entre comillas invertidas porque es una palabra reservada en MySQL y es una función
dayofweek(t.Date) as DayOfWeek_,
CASE
    WHEN MONTH(t.date) IN (12,1,2) then 'winter'
    WHEN MONTH(t.date) IN (3,4,5)  then  'spring'
    WHEN MONTH(t.date) IN (6,7,8) then 'summer'
	WHEN MONTH(t.date) IN (9,10,11) then 'fall'
 END AS Season,
 
 /* Creación de variables de negocio*/
 
 -- Holidays / Festivos : Impacto en Ventas en días festivos
 CASE 
	WHEN t.StateHoliday <> '0' then 1 else 0
 END AS Holiday,
 
-- Competition_active: Impacto de la competencia en las ventas (Has Competition) y Tiempo en que la competencia ha estado abierta

CASE 
    WHEN (
         CASE 
	        WHEN s.CompetitionOpenSinceYear IS NOT NULL 
	        AND s.CompetitionOpenSinceMonth IS NOT NULL
	        AND STR_TO_DATE(CONCAT(s.CompetitionOpenSinceYear, '-', s.CompetitionOpenSinceMonth, '-01'), '%Y-%m-%d') <= t.Date
	        THEN 1 
            ELSE 0
			END
		  ) = 1
    THEN  TIMESTAMPDIFF(
          day, -- The unit in which the difference between the two datetime expressions should be returned.
          str_to_date(concat(s.CompetitionOpenSinceYear, '-', s.CompetitionOpenSinceMonth, '-01'), '%Y-%m-%d'), t.date
          ) 
    ELSE NULL
    END AS Competition_Time_Opened,
    
    
    -- Promociones activas
    
    t.promo as Promo1_Active,
    
    
    -- Promociones recurrentes (Activas) : Queremos saber si en el mes que se generó la transacción la tienda tenia una promoción recurrente sucediendo.
 
CASE
   WHEN s.Promo2 = 1 -- If 1,  Store is participating
	AND s.Promo2SinceYear IS NOT NULL
    AND (
    s.Promo2SinceYear < Year(t.Date)
    or (s.Promo2SinceYear = Year(t.date) and s.Promo2SinceWeek <= week(t.date,3))
    )
    AND (LOCATE(MONTHNAME(t.Date), s.PromoInterval) > 0) -- Encuentra la posición de la primera ocurrencia de una subcadena dentro de otra cadena, devolviendo el indica (la posición) donde comienza la subcadena. Si la subcadena no encuentra, devuelve 0 (esto también cuenta espacios).
   THEN 1 ELSE 0
 END AS Promo2_Active,
 
 
  -- Ticket promedio
 
COALESCE(t.Sales / NULLIF(t.customers, 0)) AS average_ticket_value -- COALESCE arrojará cero cuando costumers sea 0.







FROM train t 
LEFT JOIN store s on t.Store = s.Store;
 
select * from store;


