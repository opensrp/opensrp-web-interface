CREATE OR REPLACE FUNCTION core.get_location_by_am(_am_id integer, _role_id integer)
    RETURNS TABLE(_id integer, _locationname text, _parentlocationid integer, _locationtagname text, _users text)
    LANGUAGE plpgsql
AS $function$

DECLARE
    _sl int;
    _cnt int;
begin

    CREATE temporary TABLE loc_tree_temp
    (
        id BIGSERIAL PRIMARY KEY,
        location_name text ,
        parent_location_id integer,
        location_tag_name text ,
        depth_level integer,
        parent_no integer
    ) ON COMMIT DROP;

    with final_loc as (
        select * from (
                          with recursive loc_tree as (
                              select * from core.location loc1 where loc1.id in (
                                  select location_id from core.users_catchment_area where user_id = _am_id
                              ) union all
                              select loc2.* from core.location loc2 join loc_tree lt on lt.parent_location_id = loc2.id
                          ) select ltr.id, split_part(ltr.name, ':', 1) locationName, ltr.parent_location_id parentLocationId, lt.name locationTagName,lt.description::integer depth_level
                          from loc_tree ltr join core.location_tag lt on lt.id = ltr.location_tag_id) a
        union
        select * from (
                          with recursive loc_tree as (
                              select * from core.location loc1 where loc1.id in (
                                  select location_id from core.users_catchment_area where user_id = _am_id
                              ) union all
                              select loc2.* from core.location loc2 join loc_tree lt on lt.id = loc2.parent_location_id
                          )
                          select ltr.id, split_part(ltr.name, ':', 1) locationName, ltr.parent_location_id parentLocationId, lt.name locationTagName,lt.description::integer depth_level
                          from loc_tree ltr join core.location_tag lt on lt.id = ltr.location_tag_id
                      ) b
    )
    insert into loc_tree_temp(id,location_name,parent_location_id,location_tag_name,depth_level,parent_no)
    select *,count(*) over(partition by coalesce(parentLocationId,-1))  from final_loc order by id asc;

    loop
        select id::integer into _sl from loc_tree_temp
        where parent_location_id is null;
        select count(*) into _cnt from loc_tree_temp where parent_location_id=_sl;
        exit when _cnt>1;
        update loc_tree_temp set parent_location_id=null where parent_location_id=_sl;
        delete from loc_tree_temp where id::integer=_sl;


    end loop;

    return query 	(select id::integer,location_name,parent_location_id,location_tag_name,(select string_agg(concat(uu.first_name, ' - ',uu.username), ', ') from core.users_catchment_area uca join core.users uu on uu.id = uca.user_id join core.user_role urr on urr.user_id = uu.id where uca.location_id = loc_tree_temp.id and urr.role_id = _role_id) users from loc_tree_temp
                     order by id asc);
end;
$function$
;
