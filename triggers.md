# Création d'un déclencheur
Créer une table commander_articles constituées de colonnes :

codart : id du produit

qte : quantité à commander

date : date du jour

Créer un déclencheur after_products_update sur la table products : lorsque le stock physique devient inférieur au stock d'alerte, une nouvelle ligne est insérée dans la table commander_articles.

Pour le jeu de test de votre déclencheur, on prendra le produit 8 (barbecue 'Athos') auquel on mettra pour valeur de départ :

pro_stock_alert = 5

```sql

<!-- création de la table commander_articles  -->

USE gescom_2020_08_20;
DROP Table IF EXISTS commander_articles;
CREATE TABLE commander_articles
(codart INT PRIMARY KEY  NOT NULL,
qte INT (10),
 date DATE 
)
-- creation du trigger after_products_update
DELIMITER $$
DROP TRIGGER if EXISTS after_products_update $$
CREATE TRIGGER after_products_update
AFTER update 
ON  products
FOR EACH ROW
BEGIN
    DECLARE pro_stock_alert INT;
    SET pro_stock_alert = 5;
   if NEW.pro_stock <> old.pro_stock
   and NEW.pro_stock <= pro_stock_alert 
   THEN
   DELETE FROM commander_articles  where codart = old.pro_id ;
   INSERT INTO commander_articles (codart,qte,date) VALUES (old.pro_id,(pro_stock_alert - new.pro_stock),now());
    END IF;

     
    if new.pro_stock > pro_stock_alert
      THEN
   DELETE FROM commander_articles  where codart = old.pro_id  and new.pro_stock > pro_stock_alert;
	END IF;

END $$
DELIMITER ;

























```