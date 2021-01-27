USE gescom_2020_08_20;
DROP Table IF EXISTS commander_articles;
CREATE TABLE commander_articles
(codart INT PRIMARY KEY  NOT NULL,
qte INT (10),
 date DATE 
)

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
   INSERT INTO commander_articles (codart,qte,date) VALUES (old.pro_id,new.pro_stock,now());
   if new.pro_stock > pro_stock_alert
   THEN
   DELETE FROM commander_articles where old.pro_id = pro_id  and new.pro_stock > pro_stock_alert;
	END IF;
    END IF;

END $$
DELIMITER ;



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