drop function report.get_elco_report;
create or replace
function report.get_elco_report(_start_date text, _end_date text, _parent_loc_id int, _location_tag text )
returns table(
	locationOrProviderName text,
	totalElcoVisited int,
	adolescent int,
	nonAdolescent int,
	userTotalFpMethodUserIncludingAdolescent int,
	bracUserIncludingAdolescent int,
	govtUserIncludingAdolescent int,
	otherUserIncludingAdolescent int,
	referUserIncludingAdolescent int,
	userTotalFpMethodUserOnlyAdolescent int,
	bracUserOnlyAdolescent int,
	govtUserOnlyAdolescent int,
	otherUserOnlyAdolescent int,
	referUserOnlyAdolescent int,
	newTotalFpMethodUserIncludingAdolescent int,
	bracNewIncludingAdolescent int,
	govtNewIncludingAdolescent int,
	otherNewIncludingAdolescent int,
	referNewIncludingAdolescent int,
	newTotalFpMethodUserOnlyAdolescent int,
	bracNewOnlyAdolescent int,
	govtNewOnlyAdolescent int,
	otherNewOnlyAdolescent int,
	referNewOnlyAdolescent int,
	changeTotalFpMethodUserIncludingAdolescent int,
	bracChangeIncludingAdolescent int,
	govtChangeIncludingAdolescent int,
	otherChangeIncludingAdolescent int,
	referChangeIncludingAdolescent int,
	changeTotalFpMethodUserOnlyAdolescent int,
	bracChangeOnlyAdolescent int,
	govtChangeOnlyAdolescent int,
	otherChangeOnlyAdolescent int,
	referChangeOnlyAdolescent int,
	reInitiatedTotalFpMethodUserIncludingAdolescent int,
	bracReInitiatedIncludingAdolescent int,
	govtReInitiatedIncludingAdolescent int,
	otherReInitiatedIncludingAdolescent int,
	referReInitiatedIncludingAdolescent int,
	reInitiatedTotalFpMethodUserOnlyAdolescent int,
	bracReInitiatedOnlyAdolescent int,
	govtReInitiatedOnlyAdolescent int,
	otherReInitiatedOnlyAdolescent int,
	referReInitiatedOnlyAdolescent int,
	nsv int,
	tubectomy int,
	totalPermanentFpUser int,
	condom int,
	pill int,
	implant int,
	iud int,
	injection int,
	totalTemporaryFpUser int
) language plpgsql as $function$
declare
	fp_user RECORD;
	elco_member RECORD;
	unique_user RECORD;
	new_user RECORD;
	change_and_re_initiated_user RECORD;
begin
	create temporary table fp_method_user(
		location_name text,
		user_total_fp_method_user int,
		brac_user_including_adolescent int,
		govt_user_including_adolescent int,
		other_user_including_adolescent int,
		refer_user_including_adolescent int,
		brac_user_only_adolescent int,
		govt_user_only_adolescent int,
		other_user_only_adolescent int,
		refer_user_only_adolescent int,
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
				m.division,
				m.district,
				m.city_corporation_upazila,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.provider_id sk_id,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date )
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district when _location_tag = 'city_corporation_upazila' then city_corporation_upazila else sk_id end as location_name,
				sum(case when distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' then 1 else 0 end) brac_user_including_adolescent,
				sum(case when distribution_location = 'সরকারী' then 1 else 0 end) govt_user_including_adolescent,
				sum(case when distribution_location = 'অন্যান্য' then 1 else 0 end) other_user_including_adolescent,
				sum(case when family_planning_referral = 'হ্যাঁ' then 1 else 0 end) refer_user_including_adolescent,
				sum(case when distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_user_only_adolescent,
				sum(case when distribution_location = 'সরকারী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_user_only_adolescent,
				sum(case when distribution_location = 'অন্যান্য' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_user_only_adolescent,
				sum(case when family_planning_referral = 'হ্যাঁ' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_user_only_adolescent
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
				m.division,
				m.district,
				m.city_corporation_upazila,
				(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
				e.provider_id sk_id,
				e.distribution_location,
				e.family_planning_referral
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id )
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district when _location_tag = 'city_corporation_upazila' then city_corporation_upazila else sk_id end as location_name,
				sum(case when distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' then 1 else 0 end) brac_new_including_adolescent,
				sum(case when distribution_location = 'সরকারী' then 1 else 0 end) govt_new_including_adolescent,
				sum(case when distribution_location = 'অন্যান্য' then 1 else 0 end) other_new_including_adolescent,
				sum(case when family_planning_referral = 'হ্যাঁ' then 1 else 0 end) refer_new_including_adolescent,
				sum(case when distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_new_only_adolescent,
				sum(case when distribution_location = 'সরকারী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_new_only_adolescent,
				sum(case when distribution_location = 'অন্যান্য' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_new_only_adolescent,
				sum(case when family_planning_referral = 'হ্যাঁ' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_new_only_adolescent
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
						m.division,
						m.district,
						m.city_corporation_upazila,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.provider_id sk_id,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
						e.base_entity_id = m.base_entity_id
				) select * from t where ranking = 2
			) a, (
				with t as (
					select
						row_number() over (partition by e.base_entity_id order by e.date_created desc) ranking,
						e.base_entity_id,
						e.date_created,
						m.division,
						m.district,
						m.city_corporation_upazila,
						(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
						e.provider_id sk_id,
						e.distribution_location,
						e.family_planning_referral,
						e.familyplanning_method,
						e.familyplanning_method_known
					from
						report.elco e
					join report."member" m on
					e.base_entity_id = m.base_entity_id
				) select * from t where ranking = 1
			) b where a.base_entity_id = b.base_entity_id and a.date_created between _start_date::date and _end_date::date
		) select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district when _location_tag = 'city_corporation_upazila' then city_corporation_upazila else sk_id end as location_name,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' then 1 else 0 end) brac_change_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'সরকারী' then 1 else 0 end) govt_change_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'অন্যান্য' then 1 else 0 end) other_change_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='হ্যাঁ' then 1 else 0 end) refer_change_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_change_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'সরকারী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_change_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and distribution_location = 'অন্যান্য' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_change_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'হ্যাঁ' and familyplanning_method != previous_familyplanning_method and family_planning_referral ='হ্যাঁ' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_change_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না'  and distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' then 1 else 0 end) brac_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and distribution_location = 'সরকারী' then 1 else 0 end) govt_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and distribution_location = 'অন্যান্য' then 1 else 0 end) other_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and family_planning_referral ='হ্যাঁ' then 1 else 0 end) refer_re_initiated_including_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না'  and distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) brac_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and distribution_location = 'সরকারী' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) govt_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and distribution_location = 'অন্যান্য' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) other_re_initiated_only_adolescent,
			sum(case when familyplanning_method_known = 'হ্যাঁ' and previous_familyplanning_method_known = 'না' and family_planning_referral ='হ্যাঁ' and age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) refer_re_initiated_only_adolescent
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
				m.division,
				m.district,
				m.city_corporation_upazila,
				e.provider_id sk_id
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date )
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district when _location_tag = 'city_corporation_upazila' then city_corporation_upazila else sk_id end as location_name,
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
				m.division,
				m.district,
				m.city_corporation_upazila,
				e.provider_id sk_id,
				e.familyplanning_method,
				e.familyplanning_method_known
			from
				report.elco e
			join report."member" m on
				e.base_entity_id = m.base_entity_id
			where
				e.date_created between _start_date::date and _end_date::date )
			select
				case when _location_tag = 'division' then division when _location_tag = 'district' then district when _location_tag = 'city_corporation_upazila' then city_corporation_upazila else sk_id end as location_name,
				sum(case when familyplanning_method = 'পুরুষ বনধ্যাকরণ' then 1 else 0 end) nsv,
				sum(case when familyplanning_method = 'মহিলা বন্ধ্যাকরণ' then 1 else 0 end) tubectomy,
				sum(case when familyplanning_method = 'কনডম' then 1 else 0 end) condom,
				sum(case when familyplanning_method = 'বড়ি' then 1 else 0 end) pill,
				sum(case when familyplanning_method = 'নরপ্লান্ট' then 1 else 0 end) implant,
				sum(case when familyplanning_method = 'আই ইউ ডি' then 1 else 0 end) iud,
				sum(case when familyplanning_method = 'ইঞ্জেকশান' then 1 else 0 end) injection
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
	if _location_tag = 'sk_id' then
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
			join elco_user eu on fmu.location_name = eu.location_name
			join unique_user uu on uu.location_name = eu.location_name
			join new_user nu on nu.location_name = eu.location_name
			join change_and_re_initiated_user cru on nu.location_name = cru.location_name
			right join core.location l on split_part(l.name, ':', 1) = fmu.location_name
			where l.parent_location_id = _parent_loc_id;
	else
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
			join elco_user eu on fmu.location_name = eu.location_name
			join unique_user uu on uu.location_name = eu.location_name
			join new_user nu on nu.location_name = eu.location_name
			join change_and_re_initiated_user cru on nu.location_name = cru.location_name
			right join core.location l on split_part(l.name, ':', 1) = fmu.location_name
			where l.parent_location_id = _parent_loc_id;
	end if;
end;

$function$;

select * from report.get_elco_report(:startDate, :endDate, :parentLocationId, :locationTag);
select * from report.elco;
