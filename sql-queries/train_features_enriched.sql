#La creación de esta tabla tiene el propósito de consolidar en una sola tabla todas las variables creadas con anterioridad.

drop table if exists train_features_enriched ;
CREATE TABLE train_features_enriched as
SELECT
      tf.*,
      /*s.store,
      s.date,
      s.sales,
      s.customers,*/
      
      r.sales_rolling_7,
	  r.sales_rolling_30,
      
      r.customers_rolling_7,
	  r.customers_rolling_30,
      
      l.Sales_Lag_7,
	  l.Sales_Lag_30,
           
	  l.Customers_Lag_7,
	  l.Customers_Lag_30
           
      
      
      from train_features tf
      left join rolling_means r on tf.store = r.store and tf.date = r.date
      left join sales_lags_1 l on tf.store = l.store and tf.date = l.date ;
           
 select * from train_features_enriched;         
