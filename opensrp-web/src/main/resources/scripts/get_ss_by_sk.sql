CREATE OR REPLACE FUNCTION core.get_ss_by_sk(_sk_id integer)
    RETURNS TABLE(id integer, username text, firstname text, lastname text, mobile text, branches text, locationlist text)
    LANGUAGE plpgsql
AS $function$
begin
    return query
        select u.id, u.username::text, u.first_name::text, u.last_name::text, u.mobile::text,
               (select string_agg(name, ', ') from core.branch b join core.user_branch ub on ub.branch_id = b.id where ub.user_id = u.id)::text branches,
               (select string_agg(split_part(name, ':', 1), ', ') from core.location l join core.users_catchment_area uca on uca.location_id = l.id where uca.user_id = u.id)::text locationList
        from core.users as u where parent_user_id = _sk_id;
end;
$function$
;
