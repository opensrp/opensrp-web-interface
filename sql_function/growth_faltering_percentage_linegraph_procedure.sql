CREATE OR REPLACE FUNCTION core.growth_faltering_percentage_linegraph()
RETURNS TABLE(month float
			  , growthFalteringPercentage float
			 )
AS $$
DECLARE
BEGIN
  /*Generating Temporary Table to populate aggregated values TEMPORARY*/
  DROP TABLE IF EXISTS helper_table;
  CREATE TEMPORARY TABLE IF NOT EXISTS helper_table (
   month float,
   growthFalteringPercentage float
  );

  DROP TABLE IF EXISTS table_growth_faltering_percentage;
  CREATE TEMPORARY TABLE IF NOT EXISTS table_growth_faltering_percentage (
   month float,
   growthFalteringPercentage float
  );

   /*insert data for total child growth faltering*/
   insert into helper_table(month, growthFalteringPercentage)
   select date_part('month', date(last_event_date))
   , count(date_part('month', date(last_event_date)))
   from core.child_growth cg1
   WHERE cg1.growth_status=false and NOT EXISTS (
				  SELECT *
				  FROM core.child_growth cg2
				  WHERE cg1.base_entity_id = cg2.base_entity_id
				  AND cg1.last_event_date < cg2.last_event_date
			  )
   group by date_part('month', date(last_event_date))
   order by date_part('month', date(last_event_date)) asc;

   /*insert percentage of growth faltering data*/
   insert into table_growth_faltering_percentage(month, growthFalteringPercentage)
   select ht.month, (SELECT round(((ht.growthFalteringPercentage :: numeric)/(70 :: numeric)) * 100, 2))
   from helper_table ht;

   /*Return whole dashboard_data_count data*/
   RETURN QUERY SELECT ttable.month
       , coalesce(ttable.growthFalteringPercentage, 0) as growthFalteringPercentage
       from table_growth_faltering_percentage ttable;
END;
$$ LANGUAGE plpgsql;