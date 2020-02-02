with elco_table as (
	select
		m.first_name,
		m.base_entity_id,
		m.division,
		m.district,
		m.city_corporation_upazila,
		(extract (year from age(e.date_created, m.birthdate))*12 + extract (month from age(e.date_created, m.birthdate))) age_in_months,
		e.provider_id,
		e.family_planning_referral,
		e.family_planning_referral_location,
		e.familyplanning_method,
		e.familyplanning_method_known,
		e.complications_known,
		e.distribution_location,
		e.type_of_complications,
		e.form_submission_id
	from
		report.elco e,
		report."member" m
	where
		m.base_entity_id = e.base_entity_id
) select
	sum(case when age_in_months >= 120 and age_in_months < 228 then 1 else 0 end) adolescent_elco,
	sum(case when age_in_months > 228 and age_in_months < 600 then 1 else 0 end) non_adolescent_elco,
	sum(case when distribution_location = 'ব্র্যাক স্বাস্থ্য কর্মী' then 1 else 0 end) brac,
	sum(case when distribution_location = 'সরকারী' then 1 else 0 end) govt,
	sum(case when distribution_location = 'অন্যান্য' then 1 else 0 end) other,
	sum(case when family_planning_referral = 'হ্যাঁ' then 1 else 0 end) total_refer
 from elco_table;