-- Amity HANAH, Manageuse au sein du magasin d'Arras, vient de prendre sa retraite. Il a été décidé, après de nombreuses tractations, de confier son poste au pépiniériste le plus ancien en poste dans ce magasin. Ce dernier voit alors son salaire augmenter de 5% et ses anciens collègues pépiniéristes passent sous sa direction.

-- 1 La base de données ne contient actuellement que des employés en postes. Il a été choisi de garder en base une liste des anciens collaborateurs de l'entreprise parti en retraite. Il va donc vous falloir ajouter une ligne dans la table posts pour référencer les employés à la retraite.


insert into posts (pos_libelle) VALUES ('retraité(e)');


-- 2 Décrire les opérations qui seront à réaliser sur la table posts.
il faut rajouter une colonne retraité (code au dessus) 

-- 3 Ecrire les requêtes correspondant à ces opérations

-- l'employé le plus ancien
SELECT * FROM employees WHERE employees.emp_enter_date =
(SELECT min(emp_enter_date)
FROM employees 
LIMIT 1)

-- le magasin d'arras
SELECT * FROM employees WHERE emp_sho_id =
(SELECT sho_id
FROM shops where sho_city = 'Arras')

-- employé le plus ancien et d'arras
SELECT * FROM employees WHERE employees.emp_enter_date =
(SELECT min(emp_enter_date)
FROM employees  WHERE emp_sho_id =
(SELECT sho_id
FROM shops where sho_city = 'Arras')
LIMIT 1)

-- poste du pépiniériste

SELECT * 
FROM employees e
WHERE e.emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle ='pépiniériste')

-- requete du pépiériste le plus ancien du magasin d'Arras 
SELECT * FROM employees WHERE employees.emp_enter_date =
(SELECT min(emp_enter_date)
FROM employees  WHERE emp_sho_id =
(SELECT sho_id
FROM shops where sho_city = 'Arras' AND emp_pos_id = (SELECT pos_id FROM posts WHERE pos_libelle ='pépiniériste'))
LIMIT 1)

-- la requete pour trouver la manageuse du magasin d'Arras Amity HANAH

SELECT *
FROM employees
WHERE emp_sho_id =(SELECT sho_id 
                FROM shops 
                where sho_city = 'Arras' AND emp_pos_id IN (SELECT pos_id 
                                                            FROM posts 
                                                            WHERE pos_libelle 
                                                            LIKE '%manager%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity'




-- ********************************************************************************************************************
-- la transaction



START TRANSACTION;
DECLARE v_temp INT;
update employees;
set v_temp = emp_pos_id ,
emp_pos_id = pos_id,
pos_id = v_temp
where emp_pos_id IN (SELECT pos_id 
                    FROM posts 
                    WHERE pos_libelle 
                    LIKE '%retraité%');
rollback;

-- ou
START TRANSACTION;
update employees
set emp_pos_id = pos_id
where (SELECT sho_id 
                FROM shops 
                where sho_city = 'Arras' AND emp_pos_id IN (SELECT pos_id 
                                                            FROM posts 
                                                            WHERE pos_libelle 
                                                            LIKE '%retraité%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';
ROLLBACK;
-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- ou
START TRANSACTION;
SELECT *
FROM employees
WHERE emp_sho_id =(
    SELECT sho_id 
    FROM shops 
    where sho_city = 'Arras' AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%manager%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';


set v_temp = SELECT *
                FROM employees
                WHERE emp_sho_id =(
                    SELECT sho_id 
                    FROM shops 
                    where sho_city = 'Arras' AND emp_pos_id IN (
                        SELECT pos_id 
                        FROM posts 
                        WHERE pos_libelle LIKE '%manager%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';

update employees
set v_temp = pos_libelle
pos_libelle= "retraité(e)"
"retraité(e)" = v_temp
where emp_pos_id IN (SELECT pos_id 
                    FROM posts 
                    WHERE pos_libelle LIKE '%retraité%');
rollback;


SELECT *
FROM employees
WHERE emp_sho_id =(
    SELECT sho_id 
    FROM shops 
    where sho_city = 'Arras' AND emp_pos_id IN (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE '%retraité%'))AND emp_lastname ='Hannah' AND emp_firstname ='Amity';





-- *********************************************************************************************************************
SELECT * FROM employees WHERE emp_sho_id = (
    SELECT sho_id FROM shops  where sho_city = 'Arras' AND emp_pos_id IN (
        SELECT pos_id FROM posts WHERE pos_libelle LIKE '%retraité%')
    )AND emp_lastname ='Hannah' AND emp_firstname ='Amity';
    

SELECT 
    FROM employees 
    WHERE emp_sho_id = (
        SELECT sho_id 
        FROM shops  
        where sho_city = 'Arras' AND emp_pos_id IN (SELECT pos_id FROM posts WHERE pos_libelle LIKE '%retraité%')
    ) AND emp_lastname ='Hannah' AND emp_firstname ='Amity';

-- *********************************************************************************************************************
SELECT @id_hannah := emp_id ,@pos_id_hannah :=pos_id ,@emp_pos_id_hannah :=emp_pos_id,@pos_libelle_hannah :=pos_libelle,
@emp_lastname := emp_lastname,@emp_firstname_hannah := emp_firstname,@shop_id_hannah := shop_id,
@sho_city_hannah := sho_city ,@emp_sup_id_hannah := emp_sup_id
    FROM employees
    WHERE emp_sho_id = (
        SELECT sho_id 
        FROM shops  
        where sho_city = 'Arras' AND emp_pos_id IN (SELECT pos_id FROM posts WHERE pos_libelle LIKE '%manager%')
    ) AND emp_lastname ='Hannah' AND emp_firstname ='Amity';

SELECT @id_pépiniériste := emp_id,@enter_date_pépiniériste := emp_enter_date,@sho_id_pépiniériste := sho_id ,
        @emp_sho_id_pépiniériste := emp_sho_id ,@sho_city_pépiniériste := sho_city,
        @pos_libelle_pépinériste := pos_libelle
        FROM employees 
        WHERE employees.emp_enter_date =(
            SELECT min(emp_enter_date)
            FROM employees  
            WHERE emp_sho_id =(
                SELECT sho_id
                FROM shops 
                where sho_city = 'Arras' AND emp_pos_id = (
                    SELECT pos_id 
                    FROM posts 
                    WHERE pos_libelle ='pépiniériste'))LIMIT 1)

update employees
    SET emp_pos_id = @pos_id_hannah,
        emp_sup_id = @emp_sup_id_hannah,
        emp_salary = emp_salary * 1.05 
    where emp_id = @id_pépiniériste


-- *********************************************************************************************************************

-- pour hannah

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
SET emp_pos_id = 36
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




-- pour le pépiniériste



START TRANSACTION;

SELECT * 
FROM employees 
WHERE 
	employees.emp_enter_date =(
    	SELECT min(emp_enter_date)
		FROM employees  WHERE 
    emp_sho_id =(
        SELECT sho_id
		FROM shops 
        where sho_city = 'Arras' 
	AND emp_pos_id = (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle = 'pépiniériste'))
		LIMIT 1);

SET @idPépiniériste = (
SELECT emp_id 
FROM employees 
WHERE 
    employees.emp_enter_date =
    	(SELECT min(emp_enter_date)
    	FROM employees  
    	WHERE
    emp_sho_id =
        (SELECT sho_id
        FROM shops 
        where sho_city = 'Arras' 
    AND emp_pos_id = (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle ='pépiniériste'))
        LIMIT 1 
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

-- *************************************************************************************

-- *************************************************************************************
        
-- Collégues du pépiniériste 

SELECT * 
FROM `employees` 
WHERE emp_pos_id IN (
    SELECT pos_id 
    FROM posts 
    WHERE pos_libelle ='Pépiniériste'
AND emp_sho_id IN (
    SELECT sho_id 
    FROM shops
    WHERE sho_city = 'Arras'))


    --**** TRANSACTION pour passer les collgues du pépinériste sous son commandement*****

START transaction;

-- afficher les collegues

SELECT * 
FROM `employees` 
WHERE emp_pos_id IN (
    SELECT pos_id 
    FROM posts 
    WHERE pos_libelle ='Pépiniériste'
AND emp_sho_id IN (
    SELECT sho_id 
    FROM shops
    WHERE sho_city = 'Arras'));


-- id du pépiniériste

SET @idPépiniériste = (
SELECT emp_id 
FROM employees 
WHERE
    emp_sho_id =
        (SELECT sho_id
        FROM shops 
        where sho_city = 'Arras' 
    AND emp_pos_id = (
        SELECT pos_id 
        FROM posts 
        WHERE pos_libelle LIKE 'manager%'))
        LIMIT 1 

);
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

-- afficher de nouveau les infos collegues


START TRANSACTION;
SELECT * 
FROM `employees` 
WHERE emp_pos_id IN (
    SELECT pos_id 
    FROM posts 
    WHERE pos_libelle ='Pépiniériste'
AND emp_sho_id IN (
    SELECT sho_id 
    FROM shops
    WHERE sho_city = 'Arras'));

COMMIT ;







