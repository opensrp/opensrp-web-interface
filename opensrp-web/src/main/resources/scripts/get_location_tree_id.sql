-- FUNCTION: core.get_location_tree_id(integer, integer, integer)

-- DROP FUNCTION core.get_location_tree_id(integer, integer, integer);

CREATE OR REPLACE FUNCTION core.get_location_tree_id(
	_member_id integer,
	_role_id integer,
	_location_tag_id integer)
RETURNS TABLE(id integer)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
declare
	rec record;
begin

	CREATE temporary TABLE location_tree (
		id int
	)ON COMMIT DROP;

    for rec in
		with recursive parent_loc_1 as (
			select * from core.location ll where ll.id in(
				select tml.location_id from core.team_member_location tml join core.team_member tm on tm.id = tml.team_member_id join core.user_role ur on ur.user_id = tm.person_id where location_id in (
					with recursive parent_loc_2 as (
						select * from core.location l where l.id in(
							select location_id from core.team_member_location where team_member_id = _member_id
						) union all select loc.* from core.location loc join parent_loc_2 pl on pl.id = loc.parent_location_id
					) select distinct(pl.id) from parent_loc_2 pl
				) and ur.role_id = _role_id
			) union all select loc.* from core.location loc join parent_loc_1 pl on pl.id = loc.parent_location_id
		) select distinct(pl1.id), pl1.name from parent_loc_1 pl1 where location_tag_id = _location_tag_id

	loop
		insert into location_tree (id) values (rec.id);
	end loop;
	return query select * from location_tree;
end $BODY$;

ALTER FUNCTION core.get_location_tree_id(integer, integer, integer)
    OWNER TO opensrp_admin;
