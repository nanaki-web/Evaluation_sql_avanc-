-- Créez une vue qui affiche le catalogue produits. L'id, la référence et le nom des produits, ainsi que l'id et le nom de la catégorie doivent apparaître.

CREATE VIEW v_gescom_2020_08_20_produits
AS
SELECT p.pro_id,p.pro_ref,p.pro_name,c.cat_id,c.cat_name FROM products p
JOIN categories c
ON p.pro_cat_id = c.cat_id

-- Créez la procédure stockée facture qui permet d'afficher les informations nécessaires à une facture en fonction d'un numéro de commande. Cette procédure doit sortir le montant total de la commande.


-- procédure clients 
DELIMITER |
DROP PROCEDURE IF EXISTS clients |
CREATE PROCEDURE clients (IN p_ord_id int)

BEGIN
-- clients
   SELECT cus_id, cus_lastname, cus_firstname, cus_address,cus_zipcode ,cus_city ,cus_countries_id,cus_mail,cus_phone
   FROM customers
   WHERE cus_id = (SELECT ord_cus_id FROM orders WHERE ord_id = p_ord_id);
--   facture 
    SELECT ord_id ,ord_order_date,ord_payment_date,ord_ship_date,ord_status,(ode_quantity+ode_unit_price) as PTTC 
    FROM orders
    JOIN orders_details
    ON orders.ord_id = orders_details.ode_ord_id
    WHERE  ode_ord_id = p_ord_id;
 
-- ttc
-- calcul de la remise prix * (1-Pourcentage/100)= prix remisé

-- Sujet : Ajouter une TVA de 20% au prix de 1500€
-- Réponse : 1500 x 1,2 = 1800€

-- Sujet : Soustraire une TVA de 5,5% au prix de 2110€
-- Réponse : 2110 ÷ 1,055 = 2000€
    SELECT round((ode_quantity+ode_unit_price) * (1-ode_discount/100),2) as 'prix remisé',
            round((ode_quantity+ode_unit_price) * 1.20,2) as 'prix TVA',
           round (((ode_quantity+ode_unit_price) * (1-ode_discount/100)) + ((ode_quantity+ode_unit_price) * 1.20 ),2)  as 'prix total '
    FROM orders_details od
    JOIN orders o
    ON od.ode_ord_id = o.ord_id
    WHERE o.ord_id = p_ord_id ;

END |

DELIMITER ;

-- afficher les clients 
call clients (20)
-- exemple
1
Riviere
Romain
2301 boulevard Alsace-Lorraine
80000
Amiens
FR
risus.morbi@laposte.net
201583083


ou utiliser la procédure de mysql .






