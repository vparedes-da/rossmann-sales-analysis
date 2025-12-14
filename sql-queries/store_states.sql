#Se crea una tabla ficticia en la que se asignan los Stores a los diferentes estados
#A fictitious table is created in which the stores are assigned to different states.

CREATE TABLE store_state (
 Store INT Primary key,
 State VARCHAR(50)
 );
 
 INSERT INTO store_state (Store)
 SELECT DISTINCT(Store)
 from store
 ORDER BY Store;
 
#Dado que hay 16 estados en Alemania se asignará dichos estados a grupos de tiendas.
#Since there are 16 states in Germany, these states will be assigned to store groups.

UPDATE store_state
SET state = Case

    when store between 1 and 70 then 'Baden-Wurttemberg'
    when store between 71 and 140 then 'Bavaria'
    when store between 141 and 210 then 'Berlin'
    when store between 211 and 280 then 'Brandenburg'
    when store between 281 and 350 then 'Bremen'
    WHEN Store BETWEEN 351 AND 420 THEN 'Hamburg'
    WHEN Store BETWEEN 421 AND 490 THEN 'Hesse'
    WHEN Store BETWEEN 491 AND 560 THEN 'Lower Saxony'
    WHEN Store BETWEEN 561 AND 630 THEN 'Mecklenburg-Vorpommern'
    WHEN Store BETWEEN 631 AND 700 THEN 'North Rhine-Westphalia'
    WHEN Store BETWEEN 701 AND 770 THEN 'Rhineland-Palatinate'
    WHEN Store BETWEEN 771 AND 840 THEN 'Saarland'
    WHEN Store BETWEEN 841 AND 910 THEN 'Saxony'
    WHEN Store BETWEEN 911 AND 980 THEN 'Saxony-Anhalt'
    WHEN Store BETWEEN 981 AND 1045 THEN 'Schleswig-Holstein'
    ELSE 'Thuringia'
END;

select * from store_state;
    
