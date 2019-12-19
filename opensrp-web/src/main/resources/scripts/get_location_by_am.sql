CREATE OR REPLACE FUNCTION core.get_location_by_am(_am_id integer)
    RETURNS TABLE(id integer, locationName text, parentLocationId integer, locationTagName text)
    LANGUAGE plpgsql
AS $function$
begin
    return query
with final_loc as (
    select * from (
        with recursive loc_tree as (
            select * from core.location loc1 where loc1.id in (
                select location_id from core.users_catchment_area where user_id = _am_id
                ) union all
            select loc2.* from core.location loc2 join loc_tree lt on lt.parent_location_id = loc2.id
            ) select ltr.id, split_part(ltr.name, ':', 1) locationName, ltr.parent_location_id parentLocationId, lt.name locationTagName
                   from loc_tree ltr join core.location_tag lt on lt.id = ltr.location_tag_id) a
    union
    select * from (
        with recursive loc_tree as (
            select * from core.location loc1 where loc1.id in (
                select location_id from core.users_catchment_area where user_id = _am_id
                ) union all
            select loc2.* from core.location loc2 join loc_tree lt on lt.id = loc2.parent_location_id
            )
        select ltr.id, split_part(ltr.name, ':', 1) locationName, ltr.parent_location_id parentLocationId, lt.name locationTagName
    from loc_tree ltr join core.location_tag lt on lt.id = ltr.location_tag_id
        ) b
    ) select id, locationName::text, parentLocationId, locationTagName::text from final_loc order by id asc;
end;
$function$
;
