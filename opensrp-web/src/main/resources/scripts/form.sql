insert into form (id,formName) SELECT 1,'ancrv_1' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'ancrv_1');
insert into form (id,formName) SELECT 2,'ancrv_2' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'ancrv_2');
insert into form (id,formName) SELECT 3,'ancrv_3' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'ancrv_3');
insert into form (id,formName) SELECT 4,'ancrv_4' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'ancrv_4');
insert into form (id,formName) SELECT 5,'pncrv_1' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'pncrv_1');
insert into form (id,formName) SELECT 6,'pncrv_2' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'pncrv_2');
insert into form (id,formName) SELECT 7,'pncrv_3' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'pncrv_3');
insert into form (id,formName) SELECT 8,'enccrv_1' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'enccrv_1');
insert into form (id,formName) SELECT 9,'enccrv_2' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'enccrv_2');
insert into form (id,formName) SELECT 10,'enccrv_3' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'enccrv_3');
insert into form (id,formName) SELECT 11,'BirthNotificationPregnancyStatusFollowUp' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'BirthNotificationPregnancyStatusFollowUp');
insert into form (id,formName) SELECT 12,'ELCO PSRF' WHERE NOT EXISTS (SELECT formName FROM form WHERE formName = 'ELCO PSRF');



CREATE OR REPLACE FUNCTION core.get_location_tree(_member_id integer, _role_id integer)
 RETURNS TABLE(id integer, code text, name text, leaf_loc_id integer, member_id integer, username text, first_name text, last_name text, loc_tag_name text)
 LANGUAGE plpgsql
AS $function$
declare
	temprow record;
	rec record;
begin

	CREATE temporary TABLE location_tree (
		id int,
		code text,
		name text,
		leaf_loc_id int,
		member_id int,
		username text,
		first_name text,
		last_name text,
		loc_tag_name text
	)ON COMMIT DROP;

    for temprow in

	select uca.location_id, u.id, u.first_name, u.last_name, u.username, u.ss_no from core.users_catchment_area uca join core.user_role ur on ur.user_id = uca.user_id join core.users u on u.id = ur.user_id
		where location_id in (
			with recursive parent_loc_2 as (
				select * from core.location l where l.id in(
					select location_id from core.users_catchment_area where user_id = _member_id
				) union all
				select loc.* from core.location loc join parent_loc_2 pl on pl.id = loc.parent_location_id
			  ) select distinct(pl.id) from parent_loc_2 pl
		) and ur.role_id = _role_id

	loop
		for rec in
		with recursive parent_loc as (
		  select *, l.id as leaf_loc_id from core.location l where l.id in(
			  with recursive parent_loc_1 as (
				select * from core.location ll where ll.id = temprow.location_id union all
				select loc.* from core.location loc join parent_loc_1 pl on pl.id = loc.parent_location_id
			  ) select pl1.id from parent_loc_1 pl1 where location_tag_id = 33
		  ) union all
			select loc.*, pl.leaf_loc_id from core.location loc join parent_loc pl on pl.parent_location_id = loc.id
		) select ploc.id, ploc.code, ploc.name, ploc.leaf_loc_id, temprow.id as member_id, temprow.username as username, concat(temprow.first_name,'(',temprow.ss_no, ')') as first_name, temprow.last_name as last_name, lt.name as loc_tag_name from parent_loc ploc join core.location_tag lt on lt.id = ploc.location_tag_id order by ploc.leaf_loc_id, ploc.id
		loop
			insert into location_tree (id, code, name, leaf_loc_id, member_id, username, first_name, last_name, loc_tag_name) values (rec.id, rec.code, rec.name, rec.leaf_loc_id, rec.member_id, rec.username, rec.first_name, rec.last_name, rec.loc_tag_name);
		end loop;
	end loop;
	return query select * from location_tree order by username, leaf_loc_id, id;
end $function$
;
