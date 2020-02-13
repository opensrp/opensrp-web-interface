CREATE OR REPLACE FUNCTION report.get_elco_report_by_location(_start_date text, _end_date text, _parent_loc_id integer, _location_tag text, _parent_loc_tag text, _location_name text)
 RETURNS TABLE(locationorprovidername text, totalelcovisited integer, adolescent integer, nonadolescent integer, usertotalfpmethoduserincludingadolescent integer, bracuserincludingadolescent integer, govtuserincludingadolescent integer, otheruserincludingadolescent integer, referuserincludingadolescent integer, usertotalfpmethoduseronlyadolescent integer, bracuseronlyadolescent integer, govtuseronlyadolescent integer, otheruseronlyadolescent integer, referuseronlyadolescent integer, newtotalfpmethoduserincludingadolescent integer, bracnewincludingadolescent integer, govtnewincludingadolescent integer, othernewincludingadolescent integer, refernewincludingadolescent integer, newtotalfpmethoduseronlyadolescent integer, bracnewonlyadolescent integer, govtnewonlyadolescent integer, othernewonlyadolescent integer, refernewonlyadolescent integer, changetotalfpmethoduserincludingadolescent integer, bracchangeincludingadolescent integer, govtchangeincludingadolescent integer, otherchangeincludingadolescent integer, referchangeincludingadolescent integer, changetotalfpmethoduseronlyadolescent integer, bracchangeonlyadolescent integer, govtchangeonlyadolescent integer, otherchangeonlyadolescent integer, referchangeonlyadolescent integer, reinitiatedtotalfpmethoduserincludingadolescent integer, bracreinitiatedincludingadolescent integer, govtreinitiatedincludingadolescent integer, otherreinitiatedincludingadolescent integer, referreinitiatedincludingadolescent integer, reinitiatedtotalfpmethoduseronlyadolescent integer, bracreinitiatedonlyadolescent integer, govtreinitiatedonlyadolescent integer, otherreinitiatedonlyadolescent integer, referreinitiatedonlyadolescent integer, nsv integer, tubectomy integer, totalpermanentfpuser integer, condom integer, pill integer, implant integer, iud integer, injection integer, totaltemporaryfpuser integer)
 LANGUAGE plpgsql
AS $function$
declare
	fp_user RECORD;
	elco_member RECORD;
	unique_user RECORD;
	new_user RECORD;
	change_and_re_initiated_user RECORD;
begin
	create temporary table fp_method_user(
		location_name text,
		nsv int,
		tubectomy int,
		total_permanent_fp_user int,
		condom int,
		pill int,
		implant int,
		iud int,
		injection int,
		total_temporary_fp_user int)on
	commit drop;

	create temporary table elco_user(
		location_name text,
		adolescent int,
		non_adolescent int,
		total_elco int )on
	commit drop;

	create temporary table unique_user(
		location_name text,
		user_total_fp_method_including int,
		brac_user_including_adolescent int,
		govt_user_including_adolescent int,
		other_user_including_adolescent int,
		refer_user_including_adolescent int,
		user_total_fp_method_only int,
		brac_user_only_adolescent int,
		govt_user_only_adolescent int,
		other_user_only_adolescent int,
		refer_user_only_adolescent int)on
	commit drop;

	create temporary table new_user(
		location_name text,
		new_total_fp_method_including int,
		brac_new_including_adolescent int,
		govt_new_including_adolescent int,
		other_new_including_adolescent int,
		refer_new_including_adolescent int,
		new_total_fp_method_only int,
		brac_new_only_adolescent int,
		govt_new_only_adolescent int,
		other_new_only_adolescent int,
		refer_new_only_adolescent int)on
	commit drop;

	create temporary table change_and_re_initiated_user(
		location_name text,
		change_total_fp_method_including int,
		brac_change_including_adolescent int,
		govt_change_including_adolescent int,
		other_change_including_adolescent int,
		refer_change_including_adolescent int,
		change_total_fp_method_only int,
		brac_change_only_adolescent int,
		govt_change_only_adolescent int,
		other_change_only_adolescent int,
		refer_change_only_adolescent int,
		re_initiated_total_fp_method_including int,
		brac_re_initiated_including_adolescent int,
		govt_re_initiated_including_adolescent int,
		other_re_initiated_including_adolescent int,
		refer_re_initiated_including_adolescent int,
		re_initiated_total_fp_method_only int,
		brac_re_initiated_only_adolescent int,
		govt_re_initiated_only_adolescent int,
		other_re_initiated_only_adolescent int,
		refer_re_initiated_only_adolescent int)on
	commit drop;

	for unique_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
				e.base_entity_id,
				e.date_created,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date and ( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ))
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
				sum(case when distribution_location = 'brac_health_worker' then 1 else 0 end) brac_user_including_adolescent,
				sum(case when distribution_location = 'official' then 1 else 0 end) govt_user_including_adolescent,
				sum(case when distribution_location = 'other' then 1 else 0 end) other_user_including_adolescent,
				sum(case when family_planning_referral = 'Yes' then 1 else 0 end) refer_user_including_adolescent,
				sum(case when distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_user_only_adolescent,
				sum(case when distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_user_only_adolescent,
				sum(case when distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_user_only_adolescent,
				sum(case when family_planning_referral = 'Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_user_only_adolescent
			from
				elco_table
			where
				ranking = 1
			group by location_name
		loop
			insert
				into
				unique_user (
					location_name,
					user_total_fp_method_including,
					brac_user_including_adolescent,
					govt_user_including_adolescent,
					other_user_including_adolescent,
					refer_user_including_adolescent,
					user_total_fp_method_only,
					brac_user_only_adolescent,
					govt_user_only_adolescent,
					other_user_only_adolescent,
					refer_user_only_adolescent)
				values(
					unique_user.location_name,
					unique_user.brac_user_including_adolescent+unique_user.govt_user_including_adolescent+unique_user.other_user_including_adolescent,
					unique_user.brac_user_including_adolescent,
					unique_user.govt_user_including_adolescent,
					unique_user.other_user_including_adolescent,
					unique_user.refer_user_including_adolescent,
					unique_user.brac_user_only_adolescent+unique_user.govt_user_only_adolescent+unique_user.other_user_only_adolescent,
					unique_user.brac_user_only_adolescent,
					unique_user.govt_user_only_adolescent,
					unique_user.other_user_only_adolescent,
					unique_user.refer_user_only_adolescent);
		end loop;

	for new_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created asc) ranking,
				e.base_entity_id,
				e.date_created,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where ( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ) and e.date_created <= _end_date::date)
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
				sum(case when distribution_location = 'brac_health_worker' then 1 else 0 end) brac_new_including_adolescent,
				sum(case when distribution_location = 'official' then 1 else 0 end) govt_new_including_adolescent,
				sum(case when distribution_location = 'other' then 1 else 0 end) other_new_including_adolescent,
				sum(case when family_planning_referral = 'Yes' then 1 else 0 end) refer_new_including_adolescent,
				sum(case when distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_new_only_adolescent,
				sum(case when distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_new_only_adolescent,
				sum(case when distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_new_only_adolescent,
				sum(case when family_planning_referral = 'Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_new_only_adolescent
			from
				elco_table
			where
				ranking = 1 and date_created between _start_date::date and _end_date::date
			group by location_name
		loop
			insert
				into
				new_user (
					location_name,
					new_total_fp_method_including,
					brac_new_including_adolescent,
					govt_new_including_adolescent,
					other_new_including_adolescent,
					refer_new_including_adolescent,
					new_total_fp_method_only,
					brac_new_only_adolescent,
					govt_new_only_adolescent,
					other_new_only_adolescent,
					refer_new_only_adolescent)
				values(
					new_user.location_name,
					new_user.brac_new_including_adolescent+new_user.govt_new_including_adolescent+new_user.other_new_including_adolescent,
					new_user.brac_new_including_adolescent,
					new_user.govt_new_including_adolescent,
					new_user.other_new_including_adolescent,
					new_user.refer_new_including_adolescent,
					new_user.brac_new_only_adolescent+new_user.govt_new_only_adolescent+new_user.other_new_only_adolescent,
					new_user.brac_new_only_adolescent,
					new_user.govt_new_only_adolescent,
					new_user.other_new_only_adolescent,
					new_user.refer_new_only_adolescent);
		end loop;


	for change_and_re_initiated_user in
		with elco_table as(
			select
				b.*,
				a.familyplanning_method previous_familyplanning_method,
				a.familyplanning_method_known previous_familyplanning_method_known
			from (
				with t as (
					select
						row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
						e.base_entity_id,
						e.date_created,
						m.country,
						m.division,
						m.district,
						m.city_corporation_upazila,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
						e.base_entity_id = m.base_entity_id
					where
						( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ) and e.date_created <= _end_date::date
				) select * from t where ranking = 2
			) a, (
				with t as (
					select
						row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
						e.base_entity_id,
						e.date_created,
						m.country,
						m.division,
						m.district,
						m.city_corporation_upazila,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
						e.base_entity_id = m.base_entity_id
					where
						( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ) and e.date_created <= _end_date::date
				) select * from t where ranking = 1
			) b where a.base_entity_id = b.base_entity_id and a.date_created between _start_date::date and _end_date::date
		) select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'brac_health_worker' then 1 else 0 end) brac_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'official' then 1 else 0 end) govt_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'other' then 1 else 0 end) other_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='Yes' then 1 else 0 end) refer_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No'  and distribution_location = 'brac_health_worker' then 1 else 0 end) brac_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'official' then 1 else 0 end) govt_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'other' then 1 else 0 end) other_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and family_planning_referral ='Yes' then 1 else 0 end) refer_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No'  and distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and family_planning_referral ='Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_re_initiated_only_adolescent
		from elco_table
			group by location_name

	loop
		insert
			into
			change_and_re_initiated_user (
				location_name,
				change_total_fp_method_including,
				brac_change_including_adolescent,
				govt_change_including_adolescent,
				other_change_including_adolescent,
				refer_change_including_adolescent,
				change_total_fp_method_only,
				brac_change_only_adolescent,
				govt_change_only_adolescent,
				other_change_only_adolescent,
				refer_change_only_adolescent,
				re_initiated_total_fp_method_including,
				brac_re_initiated_including_adolescent,
				govt_re_initiated_including_adolescent,
				other_re_initiated_including_adolescent,
				refer_re_initiated_including_adolescent,
				re_initiated_total_fp_method_only,
				brac_re_initiated_only_adolescent,
				govt_re_initiated_only_adolescent,
				other_re_initiated_only_adolescent,
				refer_re_initiated_only_adolescent)
			values(
				change_and_re_initiated_user.location_name,
				change_and_re_initiated_user.brac_change_including_adolescent+change_and_re_initiated_user.govt_change_including_adolescent+change_and_re_initiated_user.other_change_including_adolescent,
				change_and_re_initiated_user.brac_change_including_adolescent,
				change_and_re_initiated_user.govt_change_including_adolescent,
				change_and_re_initiated_user.other_change_including_adolescent,
				change_and_re_initiated_user.refer_change_including_adolescent,
				change_and_re_initiated_user.brac_change_only_adolescent+change_and_re_initiated_user.govt_change_only_adolescent+change_and_re_initiated_user.other_change_only_adolescent,
				change_and_re_initiated_user.brac_change_only_adolescent,
				change_and_re_initiated_user.govt_change_only_adolescent,
				change_and_re_initiated_user.other_change_only_adolescent,
				change_and_re_initiated_user.refer_change_only_adolescent,
				change_and_re_initiated_user.brac_re_initiated_including_adolescent+change_and_re_initiated_user.govt_re_initiated_including_adolescent+change_and_re_initiated_user.other_re_initiated_including_adolescent,
				change_and_re_initiated_user.brac_re_initiated_including_adolescent,
				change_and_re_initiated_user.govt_re_initiated_including_adolescent,
				change_and_re_initiated_user.other_re_initiated_including_adolescent,
				change_and_re_initiated_user.refer_re_initiated_including_adolescent,
				change_and_re_initiated_user.brac_re_initiated_only_adolescent+change_and_re_initiated_user.govt_re_initiated_only_adolescent+change_and_re_initiated_user.other_re_initiated_only_adolescent,
				change_and_re_initiated_user.brac_re_initiated_only_adolescent,
				change_and_re_initiated_user.govt_re_initiated_only_adolescent,
				change_and_re_initiated_user.other_re_initiated_only_adolescent,
				change_and_re_initiated_user.refer_re_initiated_only_adolescent );
	end loop;

	for elco_member in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id) ranking,
				e.base_entity_id,
				e.date_created,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date and ( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ))
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
				sum(case when age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) adolescent,
				sum(case when age_in_months >= 228 and age_in_months < 600 then 1 else 0 end) non_adolescent
			from
				elco_table
			where
				ranking = 1
			group by location_name
		loop
			insert
				into
				elco_user(
					location_name,
					adolescent,
					non_adolescent,
					total_elco)
				values(
					elco_member.location_name,
					elco_member.adolescent,
					elco_member.non_adolescent,
					elco_member.adolescent+elco_member.non_adolescent);
		end loop;


	for fp_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
				e.base_entity_id,
				e.date_created,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				e.familyplanning_method,
				e.familyplanning_method_known
			from
				report.elco e
			join
				report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date and ( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end ))
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
				sum(case when familyplanning_method = 'vasectomy' then 1 else 0 end) nsv,
				sum(case when familyplanning_method = 'ligation' then 1 else 0 end) tubectomy,
				sum(case when familyplanning_method = 'condom' then 1 else 0 end) condom,
				sum(case when familyplanning_method = 'contraceptive_pill' then 1 else 0 end) pill,
				sum(case when familyplanning_method = 'norplant' then 1 else 0 end) implant,
				sum(case when familyplanning_method = 'iud' then 1 else 0 end) iud,
				sum(case when familyplanning_method = 'injection' then 1 else 0 end) injection
			from
				elco_table
			where
				ranking = 1
			group by location_name
		loop
			insert
				into
				fp_method_user(
					location_name,
					nsv,
					tubectomy,
					total_permanent_fp_user,
					condom,
					pill,
					implant,
					iud,
					injection,
					total_temporary_fp_user)
				values(
					fp_user.location_name,
					fp_user.nsv,
					fp_user.tubectomy,
					fp_user.nsv+fp_user.tubectomy,
					fp_user.condom,
					fp_user.pill,
					fp_user.implant,
					fp_user.iud,
					fp_user.injection,
					fp_user.condom+fp_user.pill+fp_user.implant+fp_user.iud+fp_user.injection);
		end loop;
	return query
		select
			split_part(l.name, ':', 1) location_name,
			coalesce(eu.total_elco, 0),
			coalesce(eu.adolescent, 0),
			coalesce(eu.non_adolescent, 0),
			coalesce(uu.user_total_fp_method_including, 0),
			coalesce(uu.brac_user_including_adolescent, 0),
			coalesce(uu.govt_user_including_adolescent, 0),
			coalesce(uu.other_user_including_adolescent, 0),
			coalesce(uu.refer_user_including_adolescent, 0),
			coalesce(uu.user_total_fp_method_only, 0),
			coalesce(uu.brac_user_only_adolescent, 0),
			coalesce(uu.govt_user_only_adolescent, 0),
			coalesce(uu.other_user_only_adolescent, 0),
			coalesce(uu.refer_user_only_adolescent, 0),
			coalesce(nu.new_total_fp_method_including, 0),
			coalesce(nu.brac_new_including_adolescent, 0),
			coalesce(nu.govt_new_including_adolescent, 0),
			coalesce(nu.other_new_including_adolescent, 0),
			coalesce(nu.refer_new_including_adolescent, 0),
			coalesce(nu.new_total_fp_method_only, 0),
			coalesce(nu.brac_new_only_adolescent, 0),
			coalesce(nu.govt_new_only_adolescent, 0),
			coalesce(nu.other_new_only_adolescent, 0),
			coalesce(nu.refer_new_only_adolescent, 0),
			coalesce(cru.change_total_fp_method_including, 0),
			coalesce(cru.brac_change_including_adolescent, 0),
			coalesce(cru.govt_change_including_adolescent, 0),
			coalesce(cru.other_change_including_adolescent, 0),
			coalesce(cru.refer_change_including_adolescent, 0),
			coalesce(cru.change_total_fp_method_only, 0),
			coalesce(cru.brac_change_only_adolescent, 0),
			coalesce(cru.govt_change_only_adolescent, 0),
			coalesce(cru.other_change_only_adolescent, 0),
			coalesce(cru.refer_change_only_adolescent, 0),
			coalesce(cru.re_initiated_total_fp_method_including, 0),
			coalesce(cru.brac_re_initiated_including_adolescent, 0),
			coalesce(cru.govt_re_initiated_including_adolescent, 0),
			coalesce(cru.other_re_initiated_including_adolescent, 0),
			coalesce(cru.refer_re_initiated_including_adolescent, 0),
			coalesce(cru.re_initiated_total_fp_method_only, 0),
			coalesce(cru.brac_re_initiated_only_adolescent, 0),
			coalesce(cru.govt_re_initiated_only_adolescent, 0),
			coalesce(cru.other_re_initiated_only_adolescent, 0),
			coalesce(cru.refer_re_initiated_only_adolescent, 0),
			coalesce(fmu.nsv, 0),
			coalesce(fmu.tubectomy, 0),
			coalesce(fmu.total_permanent_fp_user, 0),
			coalesce(fmu.condom, 0),
			coalesce(fmu.pill, 0),
			coalesce(fmu.implant, 0),
			coalesce(fmu.iud, 0),
			coalesce(fmu.injection, 0),
			coalesce(fmu.total_temporary_fp_user, 0)
		from
			fp_method_user fmu
			full outer join elco_user eu on fmu.location_name = eu.location_name
			full outer join unique_user uu on uu.location_name = eu.location_name
			full outer join new_user nu on nu.location_name = eu.location_name
			full outer join change_and_re_initiated_user cru on nu.location_name = cru.location_name
			full outer join core.location l on split_part(l.name, ':', 1) = fmu.location_name
		where l.parent_location_id = _parent_loc_id;
end;

$function$
;


CREATE OR REPLACE FUNCTION report.get_elco_report_by_sk(_start_date text, _end_date text, _sk_ids text[])
 RETURNS TABLE(locationorprovidername text, totalelcovisited integer, adolescent integer, nonadolescent integer, usertotalfpmethoduserincludingadolescent integer, bracuserincludingadolescent integer, govtuserincludingadolescent integer, otheruserincludingadolescent integer, referuserincludingadolescent integer, usertotalfpmethoduseronlyadolescent integer, bracuseronlyadolescent integer, govtuseronlyadolescent integer, otheruseronlyadolescent integer, referuseronlyadolescent integer, newtotalfpmethoduserincludingadolescent integer, bracnewincludingadolescent integer, govtnewincludingadolescent integer, othernewincludingadolescent integer, refernewincludingadolescent integer, newtotalfpmethoduseronlyadolescent integer, bracnewonlyadolescent integer, govtnewonlyadolescent integer, othernewonlyadolescent integer, refernewonlyadolescent integer, changetotalfpmethoduserincludingadolescent integer, bracchangeincludingadolescent integer, govtchangeincludingadolescent integer, otherchangeincludingadolescent integer, referchangeincludingadolescent integer, changetotalfpmethoduseronlyadolescent integer, bracchangeonlyadolescent integer, govtchangeonlyadolescent integer, otherchangeonlyadolescent integer, referchangeonlyadolescent integer, reinitiatedtotalfpmethoduserincludingadolescent integer, bracreinitiatedincludingadolescent integer, govtreinitiatedincludingadolescent integer, otherreinitiatedincludingadolescent integer, referreinitiatedincludingadolescent integer, reinitiatedtotalfpmethoduseronlyadolescent integer, bracreinitiatedonlyadolescent integer, govtreinitiatedonlyadolescent integer, otherreinitiatedonlyadolescent integer, referreinitiatedonlyadolescent integer, nsv integer, tubectomy integer, totalpermanentfpuser integer, condom integer, pill integer, implant integer, iud integer, injection integer, totaltemporaryfpuser integer)
 LANGUAGE plpgsql
AS $function$
declare
	fp_user RECORD;
	elco_member RECORD;
	unique_user RECORD;
	new_user RECORD;
	change_and_re_initiated_user RECORD;
begin
	create temporary table fp_method_user(
		provider_id text,
		nsv int,
		tubectomy int,
		total_permanent_fp_user int,
		condom int,
		pill int,
		implant int,
		iud int,
		injection int,
		total_temporary_fp_user int)on
	commit drop;

	create temporary table elco_user(
		provider_id text,
		adolescent int,
		non_adolescent int,
		total_elco int )on
	commit drop;

	create temporary table unique_user(
		provider_id text,
		user_total_fp_method_including int,
		brac_user_including_adolescent int,
		govt_user_including_adolescent int,
		other_user_including_adolescent int,
		refer_user_including_adolescent int,
		user_total_fp_method_only int,
		brac_user_only_adolescent int,
		govt_user_only_adolescent int,
		other_user_only_adolescent int,
		refer_user_only_adolescent int)on
	commit drop;

	create temporary table new_user(
		provider_id text,
		new_total_fp_method_including int,
		brac_new_including_adolescent int,
		govt_new_including_adolescent int,
		other_new_including_adolescent int,
		refer_new_including_adolescent int,
		new_total_fp_method_only int,
		brac_new_only_adolescent int,
		govt_new_only_adolescent int,
		other_new_only_adolescent int,
		refer_new_only_adolescent int)on
	commit drop;

	create temporary table change_and_re_initiated_user(
		provider_id text,
		change_total_fp_method_including int,
		brac_change_including_adolescent int,
		govt_change_including_adolescent int,
		other_change_including_adolescent int,
		refer_change_including_adolescent int,
		change_total_fp_method_only int,
		brac_change_only_adolescent int,
		govt_change_only_adolescent int,
		other_change_only_adolescent int,
		refer_change_only_adolescent int,
		re_initiated_total_fp_method_including int,
		brac_re_initiated_including_adolescent int,
		govt_re_initiated_including_adolescent int,
		other_re_initiated_including_adolescent int,
		refer_re_initiated_including_adolescent int,
		re_initiated_total_fp_method_only int,
		brac_re_initiated_only_adolescent int,
		govt_re_initiated_only_adolescent int,
		other_re_initiated_only_adolescent int,
		refer_re_initiated_only_adolescent int)on
	commit drop;

	for unique_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
				e.base_entity_id,
				e.date_created,
				e.provider_id,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date and e.provider_id = any(_sk_ids))
			select
				provider_id,
				sum(case when distribution_location = 'brac_health_worker' then 1 else 0 end) brac_user_including_adolescent,
				sum(case when distribution_location = 'official' then 1 else 0 end) govt_user_including_adolescent,
				sum(case when distribution_location = 'other' then 1 else 0 end) other_user_including_adolescent,
				sum(case when family_planning_referral = 'Yes' then 1 else 0 end) refer_user_including_adolescent,
				sum(case when distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_user_only_adolescent,
				sum(case when distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_user_only_adolescent,
				sum(case when distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_user_only_adolescent,
				sum(case when family_planning_referral = 'Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_user_only_adolescent
			from
				elco_table
			where
				ranking = 1
			group by provider_id
		loop
			insert
				into
				unique_user (
					provider_id,
					user_total_fp_method_including,
					brac_user_including_adolescent,
					govt_user_including_adolescent,
					other_user_including_adolescent,
					refer_user_including_adolescent,
					user_total_fp_method_only,
					brac_user_only_adolescent,
					govt_user_only_adolescent,
					other_user_only_adolescent,
					refer_user_only_adolescent)
				values(
					unique_user.provider_id,
					unique_user.brac_user_including_adolescent+unique_user.govt_user_including_adolescent+unique_user.other_user_including_adolescent,
					unique_user.brac_user_including_adolescent,
					unique_user.govt_user_including_adolescent,
					unique_user.other_user_including_adolescent,
					unique_user.refer_user_including_adolescent,
					unique_user.brac_user_only_adolescent+unique_user.govt_user_only_adolescent+unique_user.other_user_only_adolescent,
					unique_user.brac_user_only_adolescent,
					unique_user.govt_user_only_adolescent,
					unique_user.other_user_only_adolescent,
					unique_user.refer_user_only_adolescent);
		end loop;

	for new_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created asc) ranking,
				e.base_entity_id,
				e.date_created,
				e.provider_id,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where e.provider_id = any(_sk_ids) and e.date_created <= _end_date::date)
			select
				provider_id,
				sum(case when distribution_location = 'brac_health_worker' then 1 else 0 end) brac_new_including_adolescent,
				sum(case when distribution_location = 'official' then 1 else 0 end) govt_new_including_adolescent,
				sum(case when distribution_location = 'other' then 1 else 0 end) other_new_including_adolescent,
				sum(case when family_planning_referral = 'Yes' then 1 else 0 end) refer_new_including_adolescent,
				sum(case when distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_new_only_adolescent,
				sum(case when distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_new_only_adolescent,
				sum(case when distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_new_only_adolescent,
				sum(case when family_planning_referral = 'Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_new_only_adolescent
			from
				elco_table
			where
				ranking = 1 and date_created between _start_date::date and _end_date::date
			group by provider_id
		loop
			insert
				into
				new_user (
					provider_id,
					new_total_fp_method_including,
					brac_new_including_adolescent,
					govt_new_including_adolescent,
					other_new_including_adolescent,
					refer_new_including_adolescent,
					new_total_fp_method_only,
					brac_new_only_adolescent,
					govt_new_only_adolescent,
					other_new_only_adolescent,
					refer_new_only_adolescent)
				values(
					new_user.provider_id,
					new_user.brac_new_including_adolescent+new_user.govt_new_including_adolescent+new_user.other_new_including_adolescent,
					new_user.brac_new_including_adolescent,
					new_user.govt_new_including_adolescent,
					new_user.other_new_including_adolescent,
					new_user.refer_new_including_adolescent,
					new_user.brac_new_only_adolescent+new_user.govt_new_only_adolescent+new_user.other_new_only_adolescent,
					new_user.brac_new_only_adolescent,
					new_user.govt_new_only_adolescent,
					new_user.other_new_only_adolescent,
					new_user.refer_new_only_adolescent);
		end loop;


	for change_and_re_initiated_user in
		with elco_table as(
			select
				b.*,
				a.familyplanning_method previous_familyplanning_method,
				a.familyplanning_method_known previous_familyplanning_method_known
			from (
				with t as (
					select
						row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
						e.base_entity_id,
						e.date_created,
						e.provider_id,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
						e.base_entity_id = m.base_entity_id
					where
						e.provider_id = any(_sk_ids) and e.date_created <= _end_date::date
				) select * from t where ranking = 2
			) a, (
				with t as (
					select
						row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
						e.base_entity_id,
						e.date_created,
						e.provider_id,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
						e.base_entity_id = m.base_entity_id
					where
						e.provider_id = any(_sk_ids) and e.date_created <= _end_date::date
				) select * from t where ranking = 1
			) b where a.base_entity_id = b.base_entity_id and a.date_created between _start_date::date and _end_date::date
		) select
			provider_id,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'brac_health_worker' then 1 else 0 end) brac_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'official' then 1 else 0 end) govt_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'other' then 1 else 0 end) other_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='Yes' then 1 else 0 end) refer_change_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'Yes' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_change_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No'  and distribution_location = 'brac_health_worker' then 1 else 0 end) brac_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'official' then 1 else 0 end) govt_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'other' then 1 else 0 end) other_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and family_planning_referral ='Yes' then 1 else 0 end) refer_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No'  and distribution_location = 'brac_health_worker' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'official' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and distribution_location = 'other' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'Yes' and previous_familyplanning_method_known = 'No' and family_planning_referral ='Yes' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_re_initiated_only_adolescent
		from elco_table
			group by provider_id

	loop
		insert
			into
			change_and_re_initiated_user (
				provider_id,
				change_total_fp_method_including,
				brac_change_including_adolescent,
				govt_change_including_adolescent,
				other_change_including_adolescent,
				refer_change_including_adolescent,
				change_total_fp_method_only,
				brac_change_only_adolescent,
				govt_change_only_adolescent,
				other_change_only_adolescent,
				refer_change_only_adolescent,
				re_initiated_total_fp_method_including,
				brac_re_initiated_including_adolescent,
				govt_re_initiated_including_adolescent,
				other_re_initiated_including_adolescent,
				refer_re_initiated_including_adolescent,
				re_initiated_total_fp_method_only,
				brac_re_initiated_only_adolescent,
				govt_re_initiated_only_adolescent,
				other_re_initiated_only_adolescent,
				refer_re_initiated_only_adolescent)
			values(
				change_and_re_initiated_user.provider_id,
				change_and_re_initiated_user.brac_change_including_adolescent+change_and_re_initiated_user.govt_change_including_adolescent+change_and_re_initiated_user.other_change_including_adolescent,
				change_and_re_initiated_user.brac_change_including_adolescent,
				change_and_re_initiated_user.govt_change_including_adolescent,
				change_and_re_initiated_user.other_change_including_adolescent,
				change_and_re_initiated_user.refer_change_including_adolescent,
				change_and_re_initiated_user.brac_change_only_adolescent+change_and_re_initiated_user.govt_change_only_adolescent+change_and_re_initiated_user.other_change_only_adolescent,
				change_and_re_initiated_user.brac_change_only_adolescent,
				change_and_re_initiated_user.govt_change_only_adolescent,
				change_and_re_initiated_user.other_change_only_adolescent,
				change_and_re_initiated_user.refer_change_only_adolescent,
				change_and_re_initiated_user.brac_re_initiated_including_adolescent+change_and_re_initiated_user.govt_re_initiated_including_adolescent+change_and_re_initiated_user.other_re_initiated_including_adolescent,
				change_and_re_initiated_user.brac_re_initiated_including_adolescent,
				change_and_re_initiated_user.govt_re_initiated_including_adolescent,
				change_and_re_initiated_user.other_re_initiated_including_adolescent,
				change_and_re_initiated_user.refer_re_initiated_including_adolescent,
				change_and_re_initiated_user.brac_re_initiated_only_adolescent+change_and_re_initiated_user.govt_re_initiated_only_adolescent+change_and_re_initiated_user.other_re_initiated_only_adolescent,
				change_and_re_initiated_user.brac_re_initiated_only_adolescent,
				change_and_re_initiated_user.govt_re_initiated_only_adolescent,
				change_and_re_initiated_user.other_re_initiated_only_adolescent,
				change_and_re_initiated_user.refer_re_initiated_only_adolescent );
	end loop;

	for elco_member in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id) ranking,
				e.base_entity_id,
				e.date_created,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.provider_id
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date and e.provider_id = any(_sk_ids) )
			select
				provider_id,
				sum(case when age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) adolescent,
				sum(case when age_in_months >= 228 and age_in_months < 600 then 1 else 0 end) non_adolescent
			from
				elco_table
			where
				ranking = 1
			group by provider_id
		loop
			insert
				into
				elco_user(
					provider_id,
					adolescent,
					non_adolescent,
					total_elco)
				values(
					elco_member.provider_id,
					elco_member.adolescent,
					elco_member.non_adolescent,
					elco_member.adolescent+elco_member.non_adolescent);
		end loop;


	for fp_user in
		with elco_table as (
			select
				row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
				e.base_entity_id,
				e.date_created,
				e.provider_id,
				e.familyplanning_method,
				e.familyplanning_method_known
			from
				report.elco e
			where
				e.date_created between _start_date::date and _end_date::date and e.provider_id = any(_sk_ids))
			select
				provider_id,
				sum(case when familyplanning_method = 'vasectomy' then 1 else 0 end) nsv,
				sum(case when familyplanning_method = 'ligation' then 1 else 0 end) tubectomy,
				sum(case when familyplanning_method = 'condom' then 1 else 0 end) condom,
				sum(case when familyplanning_method = 'contraceptive_pill' then 1 else 0 end) pill,
				sum(case when familyplanning_method = 'norplant' then 1 else 0 end) implant,
				sum(case when familyplanning_method = 'iud' then 1 else 0 end) iud,
				sum(case when familyplanning_method = 'injection' then 1 else 0 end) injection
			from
				elco_table
			where
				ranking = 1
			group by provider_id
		loop
			insert
				into
				fp_method_user(
					provider_id,
					nsv,
					tubectomy,
					total_permanent_fp_user,
					condom,
					pill,
					implant,
					iud,
					injection,
					total_temporary_fp_user)
				values(
					fp_user.provider_id,
					fp_user.nsv,
					fp_user.tubectomy,
					fp_user.nsv+fp_user.tubectomy,
					fp_user.condom,
					fp_user.pill,
					fp_user.implant,
					fp_user.iud,
					fp_user.injection,
					fp_user.condom+fp_user.pill+fp_user.implant+fp_user.iud+fp_user.injection);
		end loop;
	return query
		select
			u.first_name || '(' || u.username || ')',
			coalesce(eu.total_elco, 0),
			coalesce(eu.adolescent, 0),
			coalesce(eu.non_adolescent, 0),
			coalesce(uu.user_total_fp_method_including, 0),
			coalesce(uu.brac_user_including_adolescent, 0),
			coalesce(uu.govt_user_including_adolescent, 0),
			coalesce(uu.other_user_including_adolescent, 0),
			coalesce(uu.refer_user_including_adolescent, 0),
			coalesce(uu.user_total_fp_method_only, 0),
			coalesce(uu.brac_user_only_adolescent, 0),
			coalesce(uu.govt_user_only_adolescent, 0),
			coalesce(uu.other_user_only_adolescent, 0),
			coalesce(uu.refer_user_only_adolescent, 0),
			coalesce(nu.new_total_fp_method_including, 0),
			coalesce(nu.brac_new_including_adolescent, 0),
			coalesce(nu.govt_new_including_adolescent, 0),
			coalesce(nu.other_new_including_adolescent, 0),
			coalesce(nu.refer_new_including_adolescent, 0),
			coalesce(nu.new_total_fp_method_only, 0),
			coalesce(nu.brac_new_only_adolescent, 0),
			coalesce(nu.govt_new_only_adolescent, 0),
			coalesce(nu.other_new_only_adolescent, 0),
			coalesce(nu.refer_new_only_adolescent, 0),
			coalesce(cru.change_total_fp_method_including, 0),
			coalesce(cru.brac_change_including_adolescent, 0),
			coalesce(cru.govt_change_including_adolescent, 0),
			coalesce(cru.other_change_including_adolescent, 0),
			coalesce(cru.refer_change_including_adolescent, 0),
			coalesce(cru.change_total_fp_method_only, 0),
			coalesce(cru.brac_change_only_adolescent, 0),
			coalesce(cru.govt_change_only_adolescent, 0),
			coalesce(cru.other_change_only_adolescent, 0),
			coalesce(cru.refer_change_only_adolescent, 0),
			coalesce(cru.re_initiated_total_fp_method_including, 0),
			coalesce(cru.brac_re_initiated_including_adolescent, 0),
			coalesce(cru.govt_re_initiated_including_adolescent, 0),
			coalesce(cru.other_re_initiated_including_adolescent, 0),
			coalesce(cru.refer_re_initiated_including_adolescent, 0),
			coalesce(cru.re_initiated_total_fp_method_only, 0),
			coalesce(cru.brac_re_initiated_only_adolescent, 0),
			coalesce(cru.govt_re_initiated_only_adolescent, 0),
			coalesce(cru.other_re_initiated_only_adolescent, 0),
			coalesce(cru.refer_re_initiated_only_adolescent, 0),
			coalesce(fmu.nsv, 0),
			coalesce(fmu.tubectomy, 0),
			coalesce(fmu.total_permanent_fp_user, 0),
			coalesce(fmu.condom, 0),
			coalesce(fmu.pill, 0),
			coalesce(fmu.implant, 0),
			coalesce(fmu.iud, 0),
			coalesce(fmu.injection, 0),
			coalesce(fmu.total_temporary_fp_user, 0)
		from
			fp_method_user fmu
			full outer join elco_user eu on fmu.provider_id = eu.provider_id
			full outer join unique_user uu on uu.provider_id = eu.provider_id
			full outer join new_user nu on nu.provider_id = eu.provider_id
			full outer join change_and_re_initiated_user cru on nu.provider_id = cru.provider_id
			full outer join core.users u on u.username = eu.provider_id
		where u.username = any(_sk_ids);
end;

$function$
;
