# Script transactions




```sql
START transaction;
insert into posts (pos_libelle) VALUES ('retraité(e)');

-- changement du poste d'hannah

UPDATE employees 
SET emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle LIKE 'retraité%')
WHERE emp_id = @idHannah;

-- variable idPépiniériste
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
        WHERE pos_libelle ='Pépiniériste'))
    )
        LIMIT 1
);

-- variable poste pépiniériste 
SET @postePépinériste = (
SELECT pos_id 
FROM posts p
WHERE p.pos_libelle like 'manager%');
--  changement  de poste pour le pépiniériste
UPDATE employees 
SET emp_pos_id = @postePépinériste,
	emp_salary = emp_salary * 1.05
WHERE emp_id = @idPépiniériste;

-- les anciens collegues deviennent ces subordonnés 

update employees
SET emp_superior_id = @idPépiniériste
WHERE emp_pos_id IN (
    SELECT pos_id 
    FROM posts 
    WHERE pos_libelle ='Pépiniériste'
AND emp_sho_id IN (
    SELECT sho_id 
    FROM shops
    WHERE sho_city = 'Arras'));

COMMIT;





```
