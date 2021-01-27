# Créez une vue qui affiche le catalogue produits. L'id, la référence et le nom des produits, ainsi que l'id et le nom de la catégorie doivent apparaître.


```sql

CREATE VIEW v_gescom_2020_08_20_produits
AS
SELECT p.pro_id,p.pro_ref,p.pro_name,c.cat_id,c.cat_name FROM products p
JOIN categories c
ON p.pro_cat_id = c.cat_id












```