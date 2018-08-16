CREATE OR REPLACE FUNCTION core.test_growth_faltering_percentage_linegraph()
RETURNS TABLE(
	year float
	, month float
	, growthFalteringPercentage float
			 )
AS $$
DECLARE
i integer; 
years float[] := ARRAY(SELECT DISTINCT EXTRACT(YEAR FROM event_date) 
					   FROM core.child_growth
					   order by EXTRACT(YEAR FROM event_date));
BEGIN
  /*Generating Temporary Table to populate aggregated values TEMPORARY*/
  DROP TABLE IF EXISTS helper_table;
  CREATE TEMPORARY TABLE IF NOT EXISTS helper_table (
   year float,
   month float,
   growthFalteringPercentage float
  );

  DROP TABLE IF EXISTS table_growth_faltering_percentage;
  CREATE TEMPORARY TABLE IF NOT EXISTS table_growth_faltering_percentage (
   year float,
   month float,
   growthFalteringPercentage float
  );

   FOREACH i IN ARRAY years
   LOOP 
   RAISE NOTICE '%', i;
   /*insert data for total child growth faltering*/
   INSERT INTO helper_table (year, month)
   VALUES  (i, 1), (i, 2), (i, 3), (i, 4), (i, 5), (i, 6), (i, 7), (i, 8), (i, 9), (i, 10), (i, 11), (i, 12);
   END LOOP;

   update helper_table
   set growthFalteringPercentage = growth_faltering.growthFalteringPercentage from
   (select date_part('year', date(event_date))
   , date_part('month', date(event_date))
   , count(date_part('month', date(event_date)))
   from core.child_growth cg1
   WHERE cg1.growth_status=false

   and NOT EXISTS (
				  SELECT *
				  FROM core.child_growth cg2
				  WHERE cg1.base_entity_id = cg2.base_entity_id
				  AND cg1.event_date < cg2.event_date
			  )
   group by date_part('year', date(event_date)), date_part('month', date(event_date))
   order by date_part('month', date(event_date)) asc) as growth_faltering(year, month, growthFalteringPercentage)
   where helper_table.year = growth_faltering.year
   and helper_table.month = growth_faltering.month;
									
   /*insert percentage of growth faltering data*/
   insert into table_growth_faltering_percentage(year, month, growthFalteringPercentage)
   select ht.year, ht.month, (SELECT round(((ht.growthFalteringPercentage :: numeric)/(70 :: numeric)) * 100, 2))
   from helper_table ht;

   /*Return whole dashboard_data_count data*/
   RETURN QUERY SELECT ttable.year
	   , ttable.month
       , coalesce(ttable.growthFalteringPercentage, 0) as growthFalteringPercentage
       from table_growth_faltering_percentage ttable
		order by year, month;
END;
$$ LANGUAGE plpgsql;
