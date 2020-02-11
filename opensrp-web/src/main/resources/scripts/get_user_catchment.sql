-- FUNCTION: core.get_user_catchment(integer)

-- DROP FUNCTION core.get_user_catchment(integer);

CREATE OR REPLACE FUNCTION core.get_user_catchment(
	_user_id integer)
RETURNS TABLE(division text, district text, upazila text, union_name text, ward_name text, submission_id integer)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
DECLARE
     arry_cur REFCURSOR;
	 par_loc_id int ;
	 lvl int;
	 par_loc text;
	 _loc text;
	 ret json;
	 pid int;
	 pname text;

BEGIN

 CREATE temporary TABLE tmp_catchment (
  	div_id int,
	div_name text,
  	dis_id int,
	dis_name text,
  	upa_id int,
	upa_name text,
  	uni_id int,
	uni_name text,
  	war_id int,
	war_name text,
	vil_id int,
	vil_name text,
	submit_id int

)ON COMMIT DROP;

open arry_cur  FOR
with t as(
SELECT id,parent_location_id,location_id,
(SELECT name FROM core.location where id=core.users_catchment_area.parent_location_id) parent_loc
FROM core.users_catchment_area where user_id=_user_id
),t1 as(
select t.*,core.location.name loc,location_tag_id from t,core.location where t.location_id=core.location.id
),t2 as(
select t1.*,core.location_tag.name loc_tag,core.location_tag.description loc_level from t1,core.location_tag where t1.location_tag_id=core.location_tag.id
)select
--loc_tag,
parent_location_id,(loc_level::int-1),--location_tag_id,
parent_loc,
string_agg(loc,',') from t2 group by loc_tag,parent_location_id,loc_level,location_tag_id,parent_loc;

loop
	fetch arry_cur into par_loc_id,lvl,par_loc,_loc;
	exit when not found;
	if lvl =0 then
		insert into tmp_catchment(div_name,submit_id) values(_loc,par_loc_id);
	end if;
	if lvl =1 then
		insert into tmp_catchment(div_id,div_name,dis_name,submit_id) values(par_loc_id,par_loc,_loc,par_loc_id);
	end if;
	if lvl =2 then
		insert into tmp_catchment(dis_id,dis_name,upa_name,submit_id) values(par_loc_id,par_loc,_loc,par_loc_id);
		select parent_location_id into pid from core.location where id=par_loc_id;
		select name into pname from core.location where id=pid;
		update tmp_catchment set div_id=pid,div_name=pname where submit_id=par_loc_id;
	end if;
	if lvl =3 then
		insert into tmp_catchment(upa_id,upa_name,uni_name,submit_id) values(par_loc_id,par_loc,_loc,par_loc_id);
		select parent_location_id into pid from core.location where id=par_loc_id;
		select name into pname from core.location where id=pid;
		update tmp_catchment set dis_id=pid,dis_name=pname where submit_id=par_loc_id;

		select parent_location_id into pid from core.location where id=pid;
		select name into pname from core.location where id=pid;
		update tmp_catchment set div_id=pid,div_name=pname where submit_id=par_loc_id;
	end if;
	if lvl =4 then
		insert into tmp_catchment(uni_id,uni_name,war_name,submit_id) values(par_loc_id,par_loc,_loc,par_loc_id);
		select parent_location_id into pid from core.location where id=par_loc_id;
		select name into pname from core.location where id=pid;
		update tmp_catchment set upa_id=pid,upa_name=pname where submit_id=par_loc_id;

		select parent_location_id into pid from core.location where id=pid;
		select name into pname from core.location where id=pid;
		update tmp_catchment set dis_id=pid,dis_name=pname where submit_id=par_loc_id;

		select parent_location_id into pid from core.location where id=pid;
		select name into pname from core.location where id=pid;
		update tmp_catchment set div_id=pid,div_name=pname where submit_id=par_loc_id;
	end if;
end loop;

close arry_cur;
with t as(
	select
	div_name as division,
	dis_name district,
	upa_name as upzaila,
	uni_name union_name,
	submit_id
	from tmp_catchment
)
select json_agg(row_to_json(t)) into ret from t;
raise notice '%',ret;

RETURN query select
	div_name ,
	dis_name ,
	upa_name ,
	uni_name ,
	war_name,
	submit_id
	from tmp_catchment;
END;
$BODY$;

ALTER FUNCTION core.get_user_catchment(integer)
    OWNER TO opensrp_admin;
