-- FUNCTION: core.get_location_tree(integer, integer)

-- DROP FUNCTION core.get_location_tree(integer, integer);

CREATE OR REPLACE FUNCTION core.get_location_tree(
	_member_id integer,
	_role_id integer)
RETURNS TABLE(id integer, code text, name text, leaf_loc_id integer, member_id integer, username text, first_name text, last_name text, loc_tag_name text)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
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

	select tml.location_id, tm.id, u.first_name, u.last_name, u.username from core.team_member_location tml join core.team_member tm on tm.id = tml.team_member_id join core.user_role ur on ur.user_id = tm.person_id join core.users u on u.id = ur.user_id
		where location_id in (
			with recursive parent_loc_2 as (
				select * from core.location l where l.id in(
					select location_id from core.team_member_location where team_member_id = _member_id
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
			  ) select pl1.id from parent_loc_1 pl1 where location_tag_id = 16
		  ) union all
			select loc.*, pl.leaf_loc_id from core.location loc join parent_loc pl on pl.parent_location_id = loc.id
		) select ploc.id, ploc.code, ploc.name, ploc.leaf_loc_id, temprow.id as member_id, temprow.username as username, temprow.first_name as first_name, temprow.last_name as last_name, lt.name as loc_tag_name from parent_loc ploc join core.location_tag lt on lt.id = ploc.location_tag_id order by ploc.leaf_loc_id, ploc.id
		loop
			insert into location_tree (id, code, name, leaf_loc_id, member_id, username, first_name, last_name, loc_tag_name) values (rec.id, rec.code, rec.name, rec.leaf_loc_id, rec.member_id, rec.username, rec.first_name, rec.last_name, rec.loc_tag_name);
		end loop;
	end loop;
	return query select * from location_tree order by username, leaf_loc_id, id;
end $BODY$;

ALTER FUNCTION core.get_location_tree(integer, integer)
    OWNER TO opensrp_admin;
