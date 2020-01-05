
CREATE OR REPLACE FUNCTION core.update_ss_parent_by_sk_and_location(_sk_id integer, _ss_role_id integer , _location_list integer[])
 LANGUAGE plpgsql
AS $function$
begin
return query
update core.users set parent_user_id = _sk_id where id = any(
    select distinct uca.user_id from core.users_catchment_area uca join core.user_role ur on ur.user_id = uca.user_id where uca.location_id = any (_location_list) and ur.role_id = 29 and uca.user_id != _sk_id
);
end;
$function$
;
