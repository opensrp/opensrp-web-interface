CREATE OR REPLACE FUNCTION report.get_pregnancy_report_by_location(_start_date text, _end_date text, _parent_loc_id integer, _location_tag text, _parent_loc_tag text, _location_name text)
 RETURNS TABLE(locationorprovider text, totalpregnant integer, adolescentpregnant integer, firsttrimesterpregnant integer, secondtrimesterpregnant integer, pregnantoldandnew integer, normal integer, cesarean integer, braccsba integer, dnfcs integer, tbaandothers integer, totaldeliveries integer, anc1to3 integer, anc4and4plus integer, ttprotectedmothers integer, pnc48sk integer, pnc48others integer, completed42days integer, pnc1and2 integer, pnc3and3plus integer, pregnancycomplicationreferred integer)
 LANGUAGE plpgsql
AS $function$
declare
	anc RECORD;
	anc_given RECORD;
	pnc RECORD;
	pnc_given RECORD;
	preg_identified_current_month RECORD;
	member_referral RECORD;
begin
	create temporary table anc (
		location_name text,
		pregnancy_count int,
		adolescent int )on
	commit drop;

	create temporary table anc_given (
		location_name text,
		anc_1_to_3 int,
		anc_4_and_4_plus int,
		vaccination_completed int )on
	commit drop;

	create temporary table pnc (
		location_name text,
		normal int,
		cesarean int,
		brac_csba int,
		dnfcs int,
		tba_other int,
		total_deliveries int,
		days_after_42 int,
		pnc_48_sk int,
		pnc_48_others int )on
	commit drop;

	create temporary table pnc_given (
		location_name text,
		pnc_1_and_2 int,
		pnc_3_and_3_plus int )on
	commit drop;

	create temporary table preg_identified_current_month (
		location_name text,
		first_trimester int,
		second_trimester int )on
	commit drop;

	create temporary table member_referral (
		location_name text,
		total_referred int )on
	commit drop;

	for anc in
		with pregnancy as (
			select
				(extract (year from age(_end_date::date, m.birthdate))*12 + extract (month from age(_end_date::date, m.birthdate))) age_in_months_upper,
				(extract (year from age(_start_date::date, m.birthdate))*12 + extract (month from age(_start_date::date, m.birthdate))) age_in_months_lower,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				a.id
			from
				report."member" m
			join
				report.anc a
			on
				a.base_entity_id = m.base_entity_id
			where
				a.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			count(*) pregnancy_count,
			sum(case when (age_in_months_lower >= 120 and age_in_months_lower < 228) or (age_in_months_upper >= 120 and age_in_months_upper < 228) then 1 else 0 end) adolescent
		from
			pregnancy
		group by
			location_name
	loop
		insert
			into
			anc (
				location_name,
				pregnancy_count,
				adolescent)
			values(
				anc.location_name,
				anc.pregnancy_count,
				anc.adolescent
			);
	end loop;

	for anc_given in
		with pregnancy as (
			select
				row_number() over(partition by s.base_entity_id order by s.date_created desc) ranking,
				s.date_created,
				s.visit_number::int visit_number,
				s.vaccination_tt_dose_completed,
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
				s.event_type = 'ANC Home Visit' and
				s.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when visit_number >= 1 and visit_number <= 3 then 1 else 0 end) anc_1_to_3,
			sum(case when visit_number >= 4 then 1 else 0 end) anc_4_and_4_plus,
			sum(case when vaccination_tt_dose_completed = 'Yes' and ranking = 1 then 1 else 0 end) vaccination_completed
		from
			pregnancy
		group by
			location_name
	loop
		insert
			into
			anc_given (
				location_name,
				anc_1_to_3,
				anc_4_and_4_plus,
				vaccination_completed )
			values(
				anc_given.location_name,
				anc_given.anc_1_to_3,
				anc_given.anc_4_and_4_plus,
				anc_given.vaccination_completed
			);
	end loop;


	for pnc in
		with pregnancy as (
			select
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				p.delivery_date,
				p.delivery_assistance,
				p.delivery_method,
				p.delivery_place,
				_end_date::date-p.delivery_date::date days_after_42,
				p.pnc_received
			from
				report.pnc p
			join
				report."member" m
			on
				p.base_entity_id = m.base_entity_id
			where
				p.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when delivery_place != 'home' and delivery_method = 'normal' then 1 else 0 end) normal,
			sum(case when delivery_place != 'home' and delivery_method = 'c_section' then 1 else 0 end) cesarean,
			sum(case when delivery_place = 'home' and delivery_assistance = 'brac_csba' then 1 else 0 end) brac_csba,
			sum(case when delivery_place = 'home' and (delivery_assistance != 'untrained_midwife' and delivery_assistance != 'other' and delivery_assistance != 'brac_csba') then 1 else 0 end) dnfcs,
			sum(case when delivery_place = 'home' and (delivery_assistance = 'untrained_midwife' or delivery_assistance = 'other') then 1 else 0 end) tba_other,
			sum(case when days_after_42 > 42 then 1 else 0 end) days_after_42,
			sum(case when pnc_received = 'Yes' then 1 else 0 end) pnc_48_sk,
			sum(case when pnc_received = 'No' then 1 else 0 end) pnc_48_others
		from
			pregnancy
		group by
			location_name
	loop
		insert
			into
			pnc (
				location_name,
				normal,
				cesarean,
				brac_csba,
				dnfcs,
				tba_other,
				total_deliveries,
				days_after_42,
				pnc_48_sk,
				pnc_48_others )
			values(
				pnc.location_name,
				pnc.normal,
				pnc.cesarean,
				pnc.brac_csba,
				pnc.dnfcs,
				pnc.tba_other,
				pnc.normal+pnc.cesarean+pnc.brac_csba+pnc.dnfcs+pnc.tba_other,
				pnc.days_after_42,
				pnc.pnc_48_sk,
				pnc.pnc_48_others
			);
	end loop;

	for pnc_given in
		with pregnancy as (
			select
				m.first_name,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila,
				s.visit_number::int visit_number
			from
				report.service s
			join
				report."member" m
			on
				s.base_entity_id = m.base_entity_id
			where
				s.event_type = 'PNC Home Visit' and
				s.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when visit_number = 1 or visit_number = 2 then 1 else 0 end) pnc_1_and_2,
			sum(case when visit_number > 2 then 1 else 0 end) pnc_3_and_3_plus
		from
			pregnancy
		group by
			location_name
	loop
		insert
			into
			pnc_given (
				location_name,
				pnc_1_and_2,
				pnc_3_and_3_plus )
			values(
				pnc_given.location_name,
				pnc_given.pnc_1_and_2,
				pnc_given.pnc_3_and_3_plus
			);
	end loop;

	for preg_identified_current_month in
		with pregnancy as (
			select
				row_number() over(partition by a.base_entity_id) ranking,
				now()::date-a.lmp::date preg_duration,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila
			from
				report.anc a
			join
				report.member m
			on
				m.base_entity_id = a.base_entity_id
			where
				a.date_created >= date_trunc('month', current_date) and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			sum(case when preg_duration <= 90 then 1 else 0 end) first_trimester,
			sum(case when preg_duration > 90 then 1 else 0 end) second_trimester
		from
			pregnancy
		where
			ranking = 1
		group by
			location_name
	loop
		insert
			into
			preg_identified_current_month (
				location_name,
				first_trimester,
				second_trimester )
			values(
				preg_identified_current_month.location_name,
				preg_identified_current_month.first_trimester,
				preg_identified_current_month.second_trimester
			);
	end loop;

	for member_referral in
		with pregnancy as (
			select
				s.id,
				m.country,
				m.division,
				m.district,
				m.city_corporation_upazila
			from
				report.service s
			join
				report.member m
			on
				m.base_entity_id = s.base_entity_id
			where
				s.referred_reason = 'pregnancy_problems' and
				s.date_created between _start_date::date and _end_date::date and
				( case when _parent_loc_tag = 'division' then m.division = _location_name when _parent_loc_tag = 'district' then m.district = _location_name when _parent_loc_tag = 'city_corporation_upazila' then m.city_corporation_upazila = _location_name else m.country = _location_name end )
		)
		select
			case when _location_tag = 'division' then division when _location_tag = 'district' then district else city_corporation_upazila end as location_name,
			count(*) total_referred
		from
			pregnancy
		group by
			location_name
	loop
		insert
			into
			member_referral (
				location_name,
				total_referred )
			values(
				member_referral.location_name,
				member_referral.total_referred
			);
	end loop;

	return query
		select
			split_part(l.name, ':', 1) location_name,
			coalesce(a.pregnancy_count, 0),
			coalesce(a.adolescent, 0),
			coalesce(picm.first_trimester, 0),
			coalesce(picm.second_trimester, 0),
			coalesce(a.pregnancy_count, 0),
			coalesce(p.normal, 0),
			coalesce(p.cesarean, 0),
			coalesce(p.brac_csba, 0),
			coalesce(p.dnfcs, 0),
			coalesce(p.tba_other, 0),
			coalesce(p.total_deliveries, 0),
			coalesce(ag.anc_1_to_3, 0),
			coalesce(ag.anc_4_and_4_plus, 0),
			coalesce(ag.vaccination_completed, 0),
			coalesce(p.pnc_48_sk, 0),
			coalesce(p.pnc_48_others, 0),
			coalesce(p.days_after_42, 0),
			coalesce(pg.pnc_1_and_2, 0),
			coalesce(pg.pnc_3_and_3_plus, 0),
			coalesce(mr.total_referred, 0)
		from
			preg_identified_current_month picm
			full outer join anc a on picm.location_name = a.location_name
			full outer join anc_given ag on a.location_name = ag.location_name
			full outer join pnc p on ag.location_name = p.location_name
			full outer join pnc_given pg on p.location_name = pg.location_name
			full outer join member_referral mr on mr.location_name = pg.location_name
			full outer join core.location l on split_part(l.name, ':', 1) = picm.location_name
		where l.parent_location_id = _parent_loc_id;
end;

$function$
;


CREATE OR REPLACE FUNCTION report.get_pregnancy_report_by_sk(_start_date text, _end_date text, _sk_ids text[])
    RETURNS TABLE(locationorprovider text, totalpregnant integer, adolescentpregnant integer, firsttrimesterpregnant integer, secondtrimesterpregnant integer, pregnantoldandnew integer, normal integer, cesarean integer, braccsba integer, dnfcs integer, tbaandothers integer, totaldeliveries integer, anc1to3 integer, anc4and4plus integer, ttprotectedmothers integer, pnc48sk integer, pnc48others integer, completed42days integer, pnc1and2 integer, pnc3and3plus integer, pregnancycomplicationreferred integer)
    LANGUAGE plpgsql
AS $function$
declare
    anc RECORD;
    anc_given RECORD;
    pnc RECORD;
    pnc_given RECORD;
    preg_identified_current_month RECORD;
    member_referral RECORD;
begin
    create temporary table anc (
                                   provider_id text,
                                   pregnancy_count int,
                                   adolescent int )on
                                                       commit drop;

    create temporary table anc_given (
                                         provider_id text,
                                         anc_1_to_3 int,
                                         anc_4_and_4_plus int,
                                         vaccination_completed int )on
                                                                        commit drop;

    create temporary table pnc (
                                   provider_id text,
                                   normal int,
                                   cesarean int,
                                   brac_csba int,
                                   dnfcs int,
                                   tba_other int,
                                   total_deliveries int,
                                   days_after_42 int,
                                   pnc_48_sk int,
                                   pnc_48_others int )on
                                                          commit drop;

    create temporary table pnc_given (
                                         provider_id text,
                                         pnc_1_and_2 int,
                                         pnc_3_and_3_plus int )on
                                                                   commit drop;

    create temporary table preg_identified_current_month (
                                                             provider_id text,
                                                             first_trimester int,
                                                             second_trimester int )on
                                                                                       commit drop;

    create temporary table member_referral (
                                               provider_id text,
                                               total_referred int )on
                                                                       commit drop;

    for anc in
        with pregnancy as (
            select
                (extract (year from age(_end_date::date, m.birthdate))*12 + extract (month from age(_end_date::date, m.birthdate))) age_in_months_upper,
                (extract (year from age(_start_date::date, m.birthdate))*12 + extract (month from age(_start_date::date, m.birthdate))) age_in_months_lower,
                a.id,
                a.provider_id
            from
                report."member" m
                    join
                report.anc a
                on
                        a.base_entity_id = m.base_entity_id
            where
                a.date_created between _start_date::date and _end_date::date and
                    a.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            count(*) pregnancy_count,
            sum(case when (age_in_months_lower >= 120 and age_in_months_lower < 228) or (age_in_months_upper >= 120 and age_in_months_upper < 228) then 1 else 0 end) adolescent
        from
            pregnancy
        group by
            provider_id
        loop
            insert
            into
                anc (
                provider_id,
                pregnancy_count,
                adolescent)
            values(
                      anc.provider_id,
                      anc.pregnancy_count,
                      anc.adolescent
                  );
        end loop;

    for anc_given in
        with pregnancy as (
            select
                        row_number() over(partition by s.base_entity_id order by s.date_created desc) ranking,
                        s.date_created,
                        s.visit_number::int visit_number,
                        s.vaccination_tt_dose_completed,
                        s.provider_id
            from
                report.service s
            where
                    s.event_type = 'ANC Home Visit' and
                s.date_created between _start_date::date and _end_date::date and
                    s.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            sum(case when visit_number >= 1 and visit_number <= 3 then 1 else 0 end) anc_1_to_3,
            sum(case when visit_number >= 4 then 1 else 0 end) anc_4_and_4_plus,
            sum(case when vaccination_tt_dose_completed = 'Yes' and ranking = 1 then 1 else 0 end) vaccination_completed
        from
            pregnancy
        group by
            provider_id
        loop
            insert
            into
                anc_given (
                provider_id,
                anc_1_to_3,
                anc_4_and_4_plus,
                vaccination_completed )
            values(
                      anc_given.provider_id,
                      anc_given.anc_1_to_3,
                      anc_given.anc_4_and_4_plus,
                      anc_given.vaccination_completed
                  );
        end loop;


    for pnc in
        with pregnancy as (
            select
                p.provider_id,
                p.delivery_date,
                p.delivery_assistance,
                p.delivery_method,
                p.delivery_place,
                _end_date::date-p.delivery_date::date days_after_42,
                p.pnc_received
            from
                report.pnc p
            where
                p.date_created between _start_date::date and _end_date::date and
                    p.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            sum(case when delivery_place != 'home' and delivery_method = 'normal' then 1 else 0 end) normal,
            sum(case when delivery_place != 'home' and delivery_method = 'c_section' then 1 else 0 end) cesarean,
            sum(case when delivery_place = 'home' and delivery_assistance = 'brac_csba' then 1 else 0 end) brac_csba,
            sum(case when delivery_place = 'home' and (delivery_assistance != 'untrained_midwife' and delivery_assistance != 'other' and delivery_assistance != 'brac_csba') then 1 else 0 end) dnfcs,
            sum(case when delivery_place = 'home' and (delivery_assistance = 'untrained_midwife' or delivery_assistance = 'other') then 1 else 0 end) tba_other,
            sum(case when days_after_42 > 42 then 1 else 0 end) days_after_42,
            sum(case when pnc_received = 'Yes' then 1 else 0 end) pnc_48_sk,
            sum(case when pnc_received = 'No' then 1 else 0 end) pnc_48_others
        from
            pregnancy
        group by
            provider_id
        loop
            insert
            into
                pnc (
                provider_id,
                normal,
                cesarean,
                brac_csba,
                dnfcs,
                tba_other,
                total_deliveries,
                days_after_42,
                pnc_48_sk,
                pnc_48_others )
            values(
                      pnc.provider_id,
                      pnc.normal,
                      pnc.cesarean,
                      pnc.brac_csba,
                      pnc.dnfcs,
                      pnc.tba_other,
                      pnc.normal+pnc.cesarean+pnc.brac_csba+pnc.dnfcs+pnc.tba_other,
                      pnc.days_after_42,
                      pnc.pnc_48_sk,
                      pnc.pnc_48_others
                  );
        end loop;

    for pnc_given in
        with pregnancy as (
            select
                s.provider_id,
                s.visit_number::int visit_number
            from
                report.service s
            where
                    s.event_type = 'PNC Home Visit' and
                s.date_created between _start_date::date and _end_date::date and
                    s.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            sum(case when visit_number = 1 or visit_number = 2 then 1 else 0 end) pnc_1_and_2,
            sum(case when visit_number > 2 then 1 else 0 end) pnc_3_and_3_plus
        from
            pregnancy
        group by
            provider_id
        loop
            insert
            into
                pnc_given (
                provider_id,
                pnc_1_and_2,
                pnc_3_and_3_plus )
            values(
                      pnc_given.provider_id,
                      pnc_given.pnc_1_and_2,
                      pnc_given.pnc_3_and_3_plus
                  );
        end loop;


    for preg_identified_current_month in
        with pregnancy as (
            select
                        row_number() over(partition by a.base_entity_id) ranking,
                        now()::date-a.lmp::date preg_duration,
                        a.provider_id
            from
                report.anc a
            where
                    a.date_created >= date_trunc('month', current_date) and
                    a.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            sum(case when preg_duration <= 90 then 1 else 0 end) first_trimester,
            sum(case when preg_duration > 90 then 1 else 0 end) second_trimester
        from
            pregnancy
        where
                ranking = 1
        group by
            provider_id
        loop
            insert
            into
                preg_identified_current_month (
                provider_id,
                first_trimester,
                second_trimester )
            values(
                      preg_identified_current_month.provider_id,
                      preg_identified_current_month.first_trimester,
                      preg_identified_current_month.second_trimester
                  );
        end loop;

    for member_referral in
        with pregnancy as (
            select
                s.id,
                s.provider_id
            from
                report.service s
            where
                    s.referred_reason = 'pregnancy_problems' and
                s.date_created between _start_date::date and _end_date::date and
                    s.provider_id = any(_sk_ids)
        )
        select
            provider_id,
            count(*) total_referred
        from
            pregnancy
        group by
            provider_id
        loop
            insert
            into
                member_referral (
                provider_id,
                total_referred )
            values(
                      member_referral.provider_id,
                      member_referral.total_referred
                  );
        end loop;

    return query
        select
                        u.first_name || '(' || u.username || ')' provider_id,
                        coalesce(a.pregnancy_count, 0),
                        coalesce(a.adolescent, 0),
                        coalesce(picm.first_trimester, 0),
                        coalesce(picm.second_trimester, 0),
                        coalesce(a.pregnancy_count, 0),
                        coalesce(p.normal, 0),
                        coalesce(p.cesarean, 0),
                        coalesce(p.brac_csba, 0),
                        coalesce(p.dnfcs, 0),
                        coalesce(p.tba_other, 0),
                        coalesce(p.total_deliveries, 0),
                        coalesce(ag.anc_1_to_3, 0),
                        coalesce(ag.anc_4_and_4_plus, 0),
                        coalesce(ag.vaccination_completed, 0),
                        coalesce(p.pnc_48_sk, 0),
                        coalesce(p.pnc_48_others, 0),
                        coalesce(p.days_after_42, 0),
                        coalesce(pg.pnc_1_and_2, 0),
                        coalesce(pg.pnc_3_and_3_plus, 0),
                        coalesce(mr.total_referred, 0)
        from
            preg_identified_current_month picm
                full outer join anc a on picm.provider_id = a.provider_id
                full outer join anc_given ag on a.provider_id = ag.provider_id
                full outer join pnc p on ag.provider_id = p.provider_id
                full outer join pnc_given pg on p.provider_id = pg.provider_id
                full outer join member_referral mr on mr.provider_id = pg.provider_id
                full outer join core.users u on u.username = a.provider_id
        where u.username = any(_sk_ids);
end;

$function$
;
