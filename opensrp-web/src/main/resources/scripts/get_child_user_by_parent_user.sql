with recursive loc_tree as (
    select * from core.location loc1 where loc1.id in (
        select location_id from core.users_catchment_area where user_id = 1612
        )
    union all
    select loc2.* from core.location loc2 join loc_tree lt on lt.id = loc2.parent_location_id
    ) select
        distinct u.id,
        u.username,
        u.first_name firstName,
        u.last_name lastName,
        u.mobile,
        (select string_agg(b.name, ', ') from core.user_branch ub
            join core.branch b on ub.branch_id = b.id
        where ub.user_id = u.id) branches,
        (select string_agg(distinct(loc_p.name), ', ') from core.users_catchment_area uca1
            join core.location loc_c on loc_c.id = uca1.location_id
            join core.location loc_p on loc_p.id = loc_c.parent_location_id
        where uca1.user_id = u.id) locationList
from loc_tree lt
    join core.users_catchment_area uca on lt.id = uca.location_id
    join core.users u on u.id = uca.user_id
    join core.user_role ur on u.id = ur.user_id
    join core.role r on r.id = ur.role_id
where r.name = 'SK' order by firstName;
