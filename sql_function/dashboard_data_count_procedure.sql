CREATE OR REPLACE FUNCTION core.fn_growplus_dashboard_data_count()
RETURNS TABLE(countType character varying
			  , totalCount float
			  , classColor character varying
			  , isPercentage boolean)
AS $$
DECLARE
BEGIN
  /*Generating Temporary Table to populate aggregated values TEMPORARY*/
  DROP TABLE IF EXISTS core.dashboard_data_count;
  CREATE TABLE IF NOT EXISTS core.dashboard_data_count (
    countType varchar(70),
    totalCount float,
    classColor varchar(70),
	isPercentage boolean
  );

   /*insert total registered child count data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('Total Child Registered'
		  ,(SELECT count(distinct base_entity_id) 
			FROM core."viewJsonDataConversionOfClient" 
			where entity_type = 'child')
		  , 'bg-primary'
		  , false);

   /*insert % of the Children are reaching data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('% of the Children are reaching'
		  , (SELECT round(((SELECT count(distinct base_entity_id)
			 from core."viewJsonDataConversionOfEvent"
			 where entity_type = 'weight') :: numeric /100 :: numeric)*100, 2))
		  , 'bg-warning'
		  , true);

   /*insert % Children who are growth faltering data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('% Children who are growth faltering' 
		  , (SELECT round(
			  ((SELECT count(*)
			  FROM core.child_growth cg1
			  WHERE cg1.growth_status=false and NOT EXISTS (
				  SELECT *
				  FROM core.child_growth cg2
				  WHERE cg1.base_entity_id = cg2.base_entity_id
				  AND cg1.event_date < cg2.event_date
			  )) :: numeric
			  / (SELECT count(distinct base_entity_id)
				FROM core."viewJsonDataConversionOfClient"
				where entity_type = 'child') :: numeric) * 100, 2 ))
		  , 'bg-success'
		  , true);

   /*insert Total Pregnant Women Registered data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('Total Pregnant Women Registered'
		  ,(SELECT count(*) 
			FROM core."viewJsonDataConversionOfEvent"
			where entity_type = 'mother' and is_pregnant = 'Yes')
		  , 'bg-danger'
		  , false);

   /*insert % of the Woman are Reaching data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('% of the Woman are Reaching'
		  , (SELECT round(((SELECT count(distinct base_entity_id)
			 from core."viewJsonDataConversionOfEvent"
			 where (event_type = 'Woman Member Follow Up'
					OR event_type = 'Pregnant Woman Counselling')) :: numeric
				   / 100 :: numeric) * 100, 2))
		  , 'bg-success'
		  , true);
	
   /*insert % of the Woman are followed Counseling data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor, isPercentage)
   values('% of the Woman are followed Counseling'
		  , (SELECT round(((SELECT count(*)
			 FROM core."viewJsonDataConversionOfEvent" view_event1
			 WHERE view_event1.woman_are_followed_counseling = 'Yes'
			 and NOT EXISTS (
				 SELECT *
				 FROM core."viewJsonDataConversionOfEvent" view_event2
				 WHERE view_event1.base_entity_id = view_event2.base_entity_id
				 AND view_event1.event_date < view_event2.event_date
			 )) :: numeric
			/ (SELECT count(*)
			   FROM core."viewJsonDataConversionOfEvent"
			   where entity_type = 'mother'
			  ) :: numeric) * 100, 2 ))
			, 'bg-danger'
			, true);
						
   /*Return whole dashboard_data_count data*/
   RETURN QUERY SELECT ttable.countType
       , coalesce(ttable.totalCount, 0) as totalCount
	   , ttable.classColor
	   , ttable.isPercentage
       from core.dashboard_data_count ttable;
END;
$$ LANGUAGE plpgsql;