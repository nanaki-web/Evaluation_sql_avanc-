# Transaction: 
**Question °4**

```sql

START TRANSACTION;

SELECT emp_id
FROM employees
WHERE
	emp_sho_id =(
 	   SELECT sho_id 
   	 	FROM shops 
    	where sho_city = 'Arras')
    AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%manager%')
    AND emp_lastname ='Hannah' AND emp_firstname ='Amity';

set @idHannah  = (
SELECT emp_id
FROM employees
WHERE
	emp_sho_id =(
 	   SELECT sho_id 
   	 	FROM shops 
    	where sho_city = 'Arras')
    AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%manager%')
    AND emp_lastname ='Hannah' AND emp_firstname ='Amity'
);

UPDATE employees 
SET emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle LIKE 'retraité%')
WHERE emp_id = @idHannah;
/*WHERE emp_sho_id =(
    SELECT sho_id 
    FROM shops 
    where sho_city = 'Arras'
	)
    AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%manager%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';*/

   
 
SELECT *
FROM employees
WHERE emp_sho_id =(
    SELECT sho_id 
    FROM shops 
    where sho_city = 'Arras' AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%retraité%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';
COMMIT;
```
