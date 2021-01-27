```sql
START TRANSACTION;

SELECT *  
    FROM employees 
    WHERE 
	    employees.emp_enter_date = (
    	SELECT min(emp_enter_date)
		FROM employees  
        WHERE emp_sho_id = (
            SELECT sho_id
		    FROM shops 
            where sho_city = 'Arras' 
	        AND emp_pos_id = (
                SELECT pos_id 
                FROM posts 
                WHERE pos_libelle = 'pépiniériste'
            )
        )
        
    )
LIMIT 1;

SET @idPépiniériste = (
    SELECT emp_id 
    FROM employees 
    WHERE 
    employees.emp_enter_date =
    	(SELECT min(emp_enter_date)
    	FROM employees  
    	WHERE emp_sho_id =
        (SELECT sho_id
        FROM shops 
        where sho_city = 'Arras' 
    AND emp_pos_id = (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle ='pépiniériste'))
    )
        LIMIT 1;
);

SET @postePépinériste = (
SELECT pos_id 
FROM posts p
WHERE p.pos_libelle like 'manager%');
 
UPDATE employees 
SET emp_pos_id = @postePépinériste
WHERE emp_id = @idPépiniériste;

SELECT *
FROM employees
WHERE emp_sho_id =(
    SELECT sho_id 
    FROM shops 
    where sho_city = 'Arras' 
    AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle 
        LIKE 'manager%'));
COMMIT;

```