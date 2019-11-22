with agg_report as(with main_report as (
select
	*,
	(
	select
		first_name
	from
		core.users
	where
		username = a.filter_name)
from
	(
	select
		case
			when lower(lt.name) = 'division' then l.name
			else split_part(l.name, ':', 1)
		end as filter_name
	from
		core.location l
	join core.location_tag lt on
		l.location_tag_id = lt.id
	where
		lower(lt.name) = 'division'
		and l.parent_location_id = 9265) a
left join ( with report as (
	select
		*
	from
		(
		select
			distinct on
			(division) division,
			sum(coalesce(case when entity_type = 'ec_family' then 1 else 0 end, 0)) as house_hold_count,
			sum(case when house_hold_type = 'NVO' then 1 else 0 end) as nvo,
			sum(case when house_hold_type = 'BRAC VO' then 1 else 0 end) as vo,
			(sum(case when house_hold_type = 'NVO' or house_hold_type = 'BRAC VO' then 1 else 0 end) ) as total_household,
			sum(case when gender = 'M' or gender = 'F' then 1 else 0 end) as population,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 6 then 1 else 0 end) as zero_to_six_months,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 6 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 12 then 1 else 0 end) as seven_to_twelve_months,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 12 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 18 then 1 else 0 end) as thirteen_to_eighteen,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 18 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 24 then 1 else 0 end) as nineteen_to_twenty_four,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 24 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 36 then 1 else 0 end) as twenty_five_to_thirty_six,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 36 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 then 1 else 0 end) as thirty_seven_to_sixty,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 then 1 else 0 end) as children_under_five,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 60 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 120 then 1 else 0 end) as children_five_to_ten,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'M' then 1 else 0 end) as ten_to_nineteen_year_male,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'F' then 1 else 0 end) as ten_to_nineteen_year_female,
			(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'M' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'F' then 1 else 0 end) ) as total_mf_ten_to_nineteen,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' then 1 else 0 end) as nineteen_to_thirty_five_male,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' then 1 else 0 end) as nineteen_to_thirty_five_female,
			(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' then 1 else 0 end) ) as total_mf_aged_nineteen_tO_thirty_five,
			sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 420 and entity_type = 'ec_family_member' then 1 else 0 end) as population_thirty_five_and_above,
			sum(case when hh_has_latrine = 'Yes' then 1 else 0 end) as count_has_sanitary_latrine,
			sum(finger_print_taken) as total_finger_print_taken,
			sum(finger_print_availability) as total_finger_print_availability
		from
			core."clientInfoFromJSON"
		where
			cast(date_created as text) between '2019-11-01' and '2019-11-19'
		group by
			division) tmp)
	select
		*
	from
		report ) b on
	a.filter_name = b.division )
select
	*
from
	main_report
union all
select
	'TOTAL',
	null,
	sum(house_hold_count),
	sum(nvo),
	sum(vo),
	sum(total_household),
	sum(population),
	sum(zero_to_six_months),
	sum(seven_to_twelve_months),
	sum(thirteen_to_eighteen),
	sum(nineteen_to_twenty_four),
	sum(twenty_five_to_thirty_six),
	sum(thirty_seven_to_sixty),
	sum(children_under_five),
	sum(children_five_to_ten),
	sum(ten_to_nineteen_year_male),
	sum(ten_to_nineteen_year_female),
	sum(total_mf_ten_to_nineteen),
	sum(nineteen_to_thirty_five_male),
	sum(nineteen_to_thirty_five_female),
	sum(total_mf_aged_nineteen_tO_thirty_five),
	sum(population_thirty_five_and_above),
	sum(count_has_sanitary_latrine),
	sum(total_finger_print_taken),
	sum(total_finger_print_availability),
	null
from
	main_report)
select
	coalesce(filter_name, '') filter_name,
	coalesce(house_hold_count, 0) house_hold_count,
	coalesce(nvo, 0) nvo,
	coalesce(vo, 0) vo,
	coalesce(total_household, 0) total_household,
	coalesce(population, 0) population,
	coalesce(zero_to_six_months, 0) zero_to_six_months,
	coalesce(seven_to_twelve_months, 0) seven_to_twelve_months,
	coalesce(thirteen_to_eighteen, 0) thirteen_to_eighteen,
	coalesce(nineteen_to_twenty_four, 0) nineteen_to_twenty_four,
	coalesce(twenty_five_to_thirty_six, 0) twenty_five_to_thirty_six,
	coalesce(thirty_seven_to_sixty, 0) thirty_seven_to_sixty,
	coalesce(children_under_five, 0) children_under_five,
	coalesce(children_five_to_ten, 0) children_five_to_ten,
	coalesce(ten_to_nineteen_year_male, 0) ten_to_nineteen_year_male,
	coalesce(ten_to_nineteen_year_female, 0) ten_to_nineteen_year_female,
	coalesce(total_mf_ten_to_nineteen, 0) total_mf_ten_to_nineteen,
	coalesce(nineteen_to_thirty_five_male, 0) nineteen_to_thirty_five_male,
	coalesce(nineteen_to_thirty_five_female, 0) nineteen_to_thirty_five_female,
	coalesce(total_mf_aged_nineteen_tO_thirty_five, 0) total_mf_aged_nineteen_tO_thirty_five,
	coalesce(population_thirty_five_and_above, 0) population_thirty_five_and_above,
	coalesce(count_has_sanitary_latrine, 0) count_has_sanitary_latrine,
	coalesce(total_finger_print_taken, 0) total_finger_print_taken,
	coalesce(total_finger_print_availability, 0) total_finger_print_availability,
	coalesce(first_name, '') first_name
from
	agg_report;
