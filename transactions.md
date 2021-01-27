# Amity HANAH, Manageuse au sein du magasin d'Arras, vient de prendre sa retraite. Il a été décidé, après de nombreuses tractations, de confier son poste au pépiniériste le plus ancien en poste dans ce magasin. Ce dernier voit alors son salaire augmenter de 5% et ses anciens collègues pépiniéristes passent sous sa direction.

Ecrire la transaction permettant d'acter tous ces changements en base des données.

La base de données ne contient actuellement que des employés en postes. Il a été choisi de garder en base une liste des anciens collaborateurs de l'entreprise parti en retraite. Il va donc vous falloir ajouter une ligne dans la table posts pour référencer les employés à la retraite.

Décrire les opérations qui seront à réaliser sur la table posts.

Ecrire les requêtes correspondant à ces opéarations.

Ecrire la transaction

```sql
#Transaction
START TRANSACTION;
-- affichage du profile Hannah
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

-- variable idHannah

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

-- changement du poste d'hannah

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

-- affichage pour vérifier le changement du poste d'Hannah 
 
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
-- ***************************************************************************************

-- transactions pour changement du poste du pépiniériste

START TRANSACTION;
-- affichage du profile du pépiniériste
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
                WHERE pos_libelle = 'Pépiniériste')
        )
            )
LIMIT 1;
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
-- variable poste pépiniériste pépiniériste
SET @postePépinériste = (
SELECT pos_id 
FROM posts p
WHERE p.pos_libelle like 'manager%');
--  changement  de poste pour le 
UPDATE employees 
SET emp_pos_id = @postePépinériste,
	emp_salary = emp_salary * 1.05
WHERE emp_id = @idPépiniériste;
-- affichage pour vérifier le changement de poste du pépiniériste
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

-- ***************************************************************************************

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



```