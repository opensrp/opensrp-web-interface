CREATE OR REPLACE FUNCTION report.get_child_nutrition_report_by_location(_start_date text, _end_date text, _parent_loc_id integer, _location_tag text, _parent_loc_tag text, _location_name text)
 RETURNS TABLE(locationorprovider text, childrenvisited19to36 integer, immunizedchildren18to36 integer, ncdpackage integer, adolescentpackage integer, iycfpackage integer, breastfeedin1hour integer, breastfeedin24hour integer, complementaryfoodat7months integer, pushtikonainlast24hour integer)
 LANGUAGE plpgsql
AS $function$
declare
	child_follow_up RECORD;
	package RECORD;
	vaccination RECORD;
begin
	create temporary table child_follow_up (
		location_name text,
		children_visited_19_to_36 int,
		breast_feed_in_1_hour int,
		breast_feed_in_24_hour int,
		complementary_food_at_7_months int,
		pushtikona_in_last_24_hour int )on
	commit drop;

	create temporary table package (
		location_name text,
		ncd_package int,
		iycf_package int,
		adolescent_package int )on
	commit drop;

	create temporary table vaccination (
		location_name text,
		immunized_children_18_to_36 int )on
	commit drop;

	for child_follow_up in
		with child_nutrition as (
			select
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				m.breast_feeding_time::int,
				(extract (year from age(s.date_created, m.birthdate))*12 + extract (month from age(s.date_created, m.birthdate))) age_in_months,
				s.breast_feed_in_24hr,
				s.nutrients_in_24hr,
				s.solid_food_month::int solid_food_month
			from
				report.service s
			join
				report."member" m
			on
				m.base_entity_id = s.base_entity_id
			where
				s.event_type = 'Child Followup' and
				s.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when age_in_months >= 19 and age_in_months < 36 then 1 else 0 end) children_visited_19_to_36,
			sum(case when nutrients_in_24hr = 'Yes' then 1 else 0 end) pushtikona_in_last_24_hour,
			sum(case when breast_feed_in_24hr = 'Yes' then 1 else 0 end) breast_feed_in_24_hour,
			sum(case when solid_food_month = 7 then 1 else 0 end) complementary_food_at_7_months,
			sum(case when breast_feeding_time = 1 then 1 else 0 end) breast_feed_in_1_hour
		from
			child_nutrition
		group by
			location_name

	loop
		insert into
			child_follow_up (
				location_name,
				children_visited_19_to_36,
				breast_feed_in_1_hour,
				breast_feed_in_24_hour,
				complementary_food_at_7_months,
				pushtikona_in_last_24_hour
			)
			values (
				child_follow_up.location_name,
				child_follow_up.children_visited_19_to_36,
				child_follow_up.breast_feed_in_1_hour,
				child_follow_up.breast_feed_in_24_hour,
				child_follow_up.complementary_food_at_7_months,
				child_follow_up.pushtikona_in_last_24_hour
			);
	end loop;

	for package in
		with package as (
			select
				s.event_type,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila
			from
				report.service s
			join
				report."member" m
			on
				m.base_entity_id = s.base_entity_id
			where
				s.date_created between _start_date::date and _end_date::date and
				(event_type = 'IYCF package' or event_type = 'NCD package' or event_type = 'Adolescent package') and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when event_type = 'NCD package' then 1 else 0 end) ncd_package,
			sum(case when event_type = 'IYCF package' then 1 else 0 end) iycf_package,
			sum(case when event_type = 'Adolescent package' then 1 else 0 end) adolescent_package
		from
			package
		group by
			location_name

	loop
		insert into
			package (
				location_name,
				ncd_package,
				iycf_package,
				adolescent_package
			)
			values (
				package.location_name,
				package.ncd_package,
				package.iycf_package,
				package.adolescent_package
			);
	end loop;

	for vaccination in
		with vaccination as (
			select
				row_number() over(partition by s.base_entity_id) ranking,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila
			from
				report.service s
			join
				report."member" m on
				m.base_entity_id = s.base_entity_id
			where
				event_type = 'Vaccination' and
				s.date_created <= _end_date::date and
				(extract (year from age(_start_date::date, m.birthdate))* 12 + extract (month from age(_start_date::date, m.birthdate))) < 36 and
				(extract (year from age(_end_date::date, m.birthdate))* 12 + extract (month from age(_end_date::date, m.birthdate))) >= 18 and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			count(*) immunized_children_18_to_36
		from
			vaccination
		where
			ranking = 13
		group by
			location_name

	loop
		insert into
			vaccination (
				location_name,
				immunized_children_18_to_36
			)
			values (
				vaccination.location_name,
				vaccination.immunized_children_18_to_36
			);
	end loop;


	return query
		select
			split_part(l.name, ':', 1) location_name,
			coalesce(cf.children_visited_19_to_36, 0),
			coalesce(v.immunized_children_18_to_36, 0),
			coalesce(p.ncd_package, 0),
			coalesce(p.adolescent_package, 0),
			coalesce(p.iycf_package, 0),
			coalesce(cf.breast_feed_in_1_hour, 0),
			coalesce(cf.breast_feed_in_24_hour, 0),
			coalesce(cf.complementary_food_at_7_months, 0),
			coalesce(cf.pushtikona_in_last_24_hour, 0)
		from
			child_follow_up cf
		full outer join package p on p.location_name = cf.location_name
		full outer join vaccination v on v.location_name = cf.location_name
		right join core.location l on split_part(l.name, ':', 1) = cf.location_name
		where l.parent_location_id = _parent_loc_id;
end;

$function$
;



CREATE OR REPLACE FUNCTION report.get_child_nutrition_report_by_sk(_start_date text, _end_date text, _sk_ids text[])
 RETURNS TABLE(locationorprovider text, childrenvisited19to36 integer, immunizedchildren18to36 integer, ncdpackage integer, adolescentpackage integer, iycfpackage integer, breastfeedin1hour integer, breastfeedin24hour integer, complementaryfoodat7months integer, pushtikonainlast24hour integer)
 LANGUAGE plpgsql
AS $function$
declare
	child_follow_up RECORD;
	package RECORD;
	vaccination RECORD;
begin
	create temporary table child_follow_up (
		provider_id text,
		children_visited_19_to_36 int,
		breast_feed_in_1_hour int,
		breast_feed_in_24_hour int,
		complementary_food_at_7_months int,
		pushtikona_in_last_24_hour int )on
	commit drop;

	create temporary table package (
		provider_id text,
		ncd_package int,
		iycf_package int,
		adolescent_package int )on
	commit drop;

	create temporary table vaccination (
		provider_id text,
		immunized_children_18_to_36 int )on
	commit drop;

	for child_follow_up in
		with child_nutrition as (
			select
				s.provider_id,
				m.breast_feeding_time::int,
				(extract (year from age(s.date_created, m.birthdate))*12 + extract (month from age(s.date_created, m.birthdate))) age_in_months,
				s.breast_feed_in_24hr,
				s.nutrients_in_24hr,
				s.solid_food_month::int solid_food_month
			from
				report.service s
			join
				report."member" m
			on
				m.base_entity_id = s.base_entity_id
			where
				s.event_type = 'Child Followup' and
				s.date_created between _start_date::date and _end_date::date and
				s.provider_id = any(_sk_ids)
		)
		select
			provider_id,
			sum(case when age_in_months >= 19 and age_in_months < 36 then 1 else 0 end) children_visited_19_to_36,
			sum(case when nutrients_in_24hr = 'Yes' then 1 else 0 end) pushtikona_in_last_24_hour,
			sum(case when breast_feed_in_24hr = 'Yes' then 1 else 0 end) breast_feed_in_24_hour,
			sum(case when solid_food_month = 7 then 1 else 0 end) complementary_food_at_7_months,
			sum(case when breast_feeding_time = 1 then 1 else 0 end) breast_feed_in_1_hour
		from
			child_nutrition
		group by
			provider_id

	loop
		insert into
			child_follow_up (
				provider_id,
				children_visited_19_to_36,
				breast_feed_in_1_hour,
				breast_feed_in_24_hour,
				complementary_food_at_7_months,
				pushtikona_in_last_24_hour
			)
			values (
				child_follow_up.provider_id,
				child_follow_up.children_visited_19_to_36,
				child_follow_up.breast_feed_in_1_hour,
				child_follow_up.breast_feed_in_24_hour,
				child_follow_up.complementary_food_at_7_months,
				child_follow_up.pushtikona_in_last_24_hour
			);
	end loop;

	for package in
		with package as (
			select
				s.event_type,
				s.provider_id
			from
				report.service s
			where
				s.date_created between _start_date::date and _end_date::date and
				(s.event_type = 'IYCF package' or s.event_type = 'NCD package' or s.event_type = 'Adolescent package') and
				s.provider_id = any(_sk_ids)
		)
		select
			provider_id,
			sum(case when event_type = 'NCD package' then 1 else 0 end) ncd_package,
			sum(case when event_type = 'IYCF package' then 1 else 0 end) iycf_package,
			sum(case when event_type = 'Adolescent package' then 1 else 0 end) adolescent_package
		from
			package
		group by
			provider_id

	loop
		insert into
			package (
				provider_id,
				ncd_package,
				iycf_package,
				adolescent_package
			)
			values (
				package.provider_id,
				package.ncd_package,
				package.iycf_package,
				package.adolescent_package
			);
	end loop;

	for vaccination in
		with vaccination as (
			select
				row_number() over(partition by s.base_entity_id) ranking,
				s.provider_id
			from
				report.service s
			join
				report."member" m
			on
				m.base_entity_id = s.base_entity_id
			where
				s.event_type = 'Vaccination' and
				s.date_created <= _end_date::date and
				(extract (year from age(_start_date::date, m.birthdate))* 12 + extract (month from age(_start_date::date, m.birthdate))) < 36 and
				(extract (year from age(_end_date::date, m.birthdate))* 12 + extract (month from age(_end_date::date, m.birthdate))) >= 18 and
				s.provider_id = any(_sk_ids)
		)
		select
			provider_id,
			count(*) immunized_children_18_to_36
		from
			vaccination
		where
			ranking = 13
		group by
			provider_id

	loop
		insert into
			vaccination (
				provider_id,
				immunized_children_18_to_36
			)
			values (
				vaccination.provider_id,
				vaccination.immunized_children_18_to_36
			);
	end loop;


	return query
		select
			u.first_name || '(' || u.username || ')',
			coalesce(cf.children_visited_19_to_36, 0),
			coalesce(v.immunized_children_18_to_36, 0),
			coalesce(p.ncd_package, 0),
			coalesce(p.adolescent_package, 0),
			coalesce(p.iycf_package, 0),
			coalesce(cf.breast_feed_in_1_hour, 0),
			coalesce(cf.breast_feed_in_24_hour, 0),
			coalesce(cf.complementary_food_at_7_months, 0),
			coalesce(cf.pushtikona_in_last_24_hour, 0)
		from
			child_follow_up cf
		full outer join package p on p.provider_id = cf.provider_id
		full outer join vaccination v on v.provider_id = cf.provider_id
		right join core.users u on u.username = cf.provider_id
		where u.username = any(_sk_ids);
end;

$function$
;
