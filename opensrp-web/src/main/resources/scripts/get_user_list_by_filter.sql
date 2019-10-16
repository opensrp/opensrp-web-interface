with recursive main_location_tree as (
	select * from core.location where id in (
		with recursive location_tree as (
			select * from core.location l where l.id = 9266
			union all
			select loc.* from core.location loc join location_tree lt on lt.id = loc.parent_location_id
		)select distinct(lt.id) from location_tree lt where lt.location_tag_id = 33
	) union all
	select l.* from core.location l join main_location_tree mlt on l.id = mlt.parent_location_id
) select distinct(u.username), r.name role_name, b.name branch_name from main_location_tree mlt
join core.users_catchment_area uca on uca.location_id = mlt.id
join core.users u on u.id = uca.user_id
join core.user_branch ub on ub.user_id = u.id
join core.branch b on b.id = ub.branch_id
join core.user_role ur on u.id = ur.user_id
join core.role r on ur.role_id = r.id where r.name = 'SK';
