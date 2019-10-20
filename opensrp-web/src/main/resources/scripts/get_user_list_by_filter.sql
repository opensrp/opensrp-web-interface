WITH recursive main_location_tree AS 
( 
       SELECT * 
       FROM   core.location 
       WHERE  id IN ( WITH recursive location_tree AS 
                     ( 
                            SELECT * 
                            FROM   core.location l 
                            WHERE  l.id = 9266 
                            UNION ALL 
                            SELECT loc.* 
                            FROM   core.location loc 
                            JOIN   location_tree lt 
                            ON     lt.id = loc.parent_location_id ) 
              SELECT DISTINCT(lt.id) 
              FROM            location_tree lt 
              WHERE           lt.location_tag_id = 33 ) 
UNION ALL 
SELECT l.* 
FROM   core.location l 
JOIN   main_location_tree mlt 
ON     l.id = mlt.parent_location_id ) 
SELECT DISTINCT(u.username), 
                r.NAME role_name, 
                b.NAME branch_name 
FROM            main_location_tree mlt 
JOIN            core.users_catchment_area uca 
ON              uca.location_id = mlt.id 
JOIN            core.users u 
ON              u.id = uca.user_id 
JOIN            core.user_branch ub 
ON              ub.user_id = u.id 
JOIN            core.branch b 
ON              b.id = ub.branch_id 
JOIN            core.user_role ur 
ON              u.id = ur.user_id 
JOIN            core.role r 
ON              ur.role_id = r.id 
WHERE           r.NAME = 'SK';
