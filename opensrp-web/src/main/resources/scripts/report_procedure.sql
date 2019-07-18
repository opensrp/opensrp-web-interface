-- FUNCTION: public.test2_anc_data(text[])

-- DROP FUNCTION public.test2_anc_data(text[]);

CREATE OR REPLACE FUNCTION core.test2_report(
    filterarray text[])
    RETURNS TABLE(providerName text, householdCount integer, population integer
        , femalePercentage double precision, malePercentage double precision)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$


DECLARE
    filterString text := '';
    div text := '';
    dis text := '';
    upa text := '';
    uni text := '';
    war text := '';
    cc text := '';
    sub text := '';
    mau text := '';
    pro text := '';
    end_date text := '';
    start_date text := '';
    pregnancy_status text := '';
    age_from text := '';
    age_to text := '';
BEGIN
    /*Search Filter Assignments*/
    div := upper(filterArray[1]);
    dis := upper(filterArray[2]);
    upa := filterArray[3];
    uni := filterArray[4];
    war := filterArray[5];
    cc := filterarray[6];
    sub := filterArray[7];
    mau := filterArray[8];
    pro := filterArray[9];
    start_date := filterArray[10];
    end_date := filterArray[11];
    pregnancy_status := filterarray[12];
    age_from := filterarray[13];
    age_to := filterarray[14];
    /*Generating Temporary Table to populate aggregated values TEMPORARY*/
    DROP TABLE IF EXISTS helper_table;
    CREATE TEMPORARY TABLE IF NOT EXISTS helper_table (
                                                          providerName text,
                                                          householdCount integer,
                                                          population integer,
                                                          femalePercentage float,
                                                          malePercentage float
    );

    /*Creating conditional query string*/
    if (div != '') THEN
        filterString := E' and division=\'' || div || E'\'';
    END IF;

    if (dis != '') THEN
        filterString := filterString || E' and district=\'' || dis || E'\'';
    END IF;

    if (upa != '') THEN
        filterString := filterString || E' and upazila=\'' || upa || E'\'';
    END IF;

    if (uni != '') THEN
        filterString := filterString || E' and client_union=\'' || uni || E'\'';
    END IF;

    if (war != '') THEN
        filterString := filterString || E' and ward=\'' || war || E'\'';
    END IF;

    IF (cc != '') THEN
        filterString := filterString || E' and cc_name=\'' || cc || E'\'';
    END IF;

    if (sub != '') THEN
        filterString := filterString || E' and subunit=\'' || sub || E'\'';
    END IF;

    if (mau != '') THEN
        filterString := filterString || E' and mauzapara=\'' || mau || E'\'';
    END IF;

    IF (pro != '') THEN
        filterString := filterString || E' and provider_id=\'' || pro || E'\'';
    END IF;

    IF (pregnancy_status != '') THEN
        filterString := filterString || E' and pregnancy_status=\'' || pregnancy_status || E'\'';
    END IF;

    IF (start_date != '' AND end_date != '') THEN
        end_date = E'\''|| end_date || E'\'';
        start_date = E'\''||start_date || E'\'';
        filterString := filterString || E' and ( date_created between '|| start_date || ' and '
                            || end_date ||')';
    END IF;

    IF (age_from != '' AND age_to != '') THEN
        age_from = E'\'' || age_from || E'\'';
        age_to = E'\'' || age_to || E'\'';
        filterString := filterString || E' and ((now()::date - birth_date::date) >'
                            || age_from ||E'and (now()::date - birth_date::date) <'
                            || age_to ||E')';
    END IF;
    /*Total counts*/
    EXECUTE E'INSERT INTO helper_table (providerName)
   VALUES (\'Total\')';

    EXECUTE E'update helper_table
    set householdCount = population_count.counts from
    (SELECT count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type = \'ec_household\' '
                || filterString
        || E' ) as population_count(counts)
    where helper_table.providerName = \'Total\'';

    EXECUTE E'update helper_table
    set population = population_count.counts from
    (SELECT count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\' '
                || filterString
        || E' ) as population_count(counts)
    where helper_table.providerName = \'Total\'';

    EXECUTE E'update helper_table
    set femalePercentage = population_count.counts from
    (SELECT count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\'
	 and gender = \'F\' '
                || filterString
        || E' ) as population_count(counts)
    where helper_table.providerName = \'Total\'';

    /*updating temporary table with male count count*/
    EXECUTE E'update helper_table
    set malePercentage = population_count.counts from
    (SELECT count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\'
	 and gender = \'M\' '
                || filterString
        || E' ) as population_count(counts)
    where helper_table.providerName = \'Total\'';

    UPDATE helper_table
    SET femalePercentage=(SELECT round(cast (subquery.femalePercentage as numeric)/cast ((subquery.population)as numeric)*100, 2))
    FROM (SELECT t.providerName, t.population, t.femalePercentage FROM helper_table t)
             AS subquery(providerName, population, femalePercentage)
    WHERE helper_table.providerName = 'Total';

    UPDATE helper_table
    SET malePercentage=(SELECT round(cast (subquery.malePercentage as numeric)/cast ((subquery.population)as numeric)*100, 2))
    FROM (SELECT t.providerName, t.population, t.malePercentage FROM helper_table t)
             AS subquery(providerName, population, malePercentage)
    WHERE helper_table.providerName = 'Total';
    /*Total counts End*/

    /*Counts of households by providers*/
    EXECUTE E'INSERT INTO helper_table (providerName , householdCount)
   SELECT provider_id, count(*) FROM core."viewJsonDataConversionOfClient"
   where entity_type = \'ec_household\' '
                || filterString
        || E' group by provider_id
   order by provider_id';

    /*updating temporary table with population count*/
    EXECUTE E'update helper_table
    set population = population_count.counts from
    (SELECT provider_id, count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\' '
                || filterString
        || E' group by provider_id
     order by provider_id ) as population_count(providername, counts)
    where helper_table.providerName = population_count.providername';


    /*updating temporary table with female count count*/
    EXECUTE E'update helper_table
    set femalePercentage = population_count.counts from
    (SELECT provider_id, count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\' '
                || filterString
        || E' and gender = \'F\'
     group by provider_id
     order by provider_id ) as population_count(providername, counts)
    where helper_table.providerName = population_count.providername';


    /*updating temporary table with female count count*/
    EXECUTE E'update helper_table
    set malePercentage = population_count.counts from
    (SELECT provider_id, count(*) FROM core."viewJsonDataConversionOfClient"
     where entity_type != \'ec_household\'
	 and gender = \'M\' '
                || filterString
        || E' group by provider_id
     order by provider_id ) as population_count(providername, counts)
    where helper_table.providerName = population_count.providername';

    UPDATE helper_table
    SET femalePercentage=(SELECT round(cast (subquery.femalePercentage as numeric)/cast ((subquery.population)as numeric)*100, 2))
    FROM (SELECT t.providerName, t.population, t.femalePercentage FROM helper_table t)
             AS subquery(providerName, population, femalePercentage)
    WHERE helper_table.providerName = subquery.providerName
      and helper_table.providerName != 'Total';

    UPDATE helper_table
    SET malePercentage=(SELECT round(cast (subquery.malePercentage as numeric)/cast ((subquery.population)as numeric)*100, 2))
    FROM (SELECT t.providerName, t.population, t.malePercentage FROM helper_table t)
             AS subquery(providerName, population, malePercentage)
    WHERE helper_table.providerName = subquery.providerName
      and helper_table.providerName != 'Total';

    /*Return whole dashboard_data_count data*/
    RETURN QUERY SELECT ttable.providerName
                      , coalesce(ttable.householdCount, 0) as householdCount
                      , coalesce(ttable.population, 0) as population
                      , coalesce(ttable.femalePercentage, 0) as femalePercentage
                      , coalesce(ttable.malePercentage, 0) as malePercentage
                 from helper_table ttable
                 order by providerName, householdCount;
END;
$BODY$;

ALTER FUNCTION core.test2_report(text[])
    OWNER TO opensrp_admin;

select * from core.test2_report(array['','','','','','','','','','','','','', ''])