CREATE OR REPLACE FUNCTION core.fn_growplus_dashboard_data_count()
RETURNS TABLE(countType character varying, totalCount float, classColor character varying)
AS $$
DECLARE
BEGIN
  /*Generating Temporary Table to populate aggregated values TEMPORARY*/
  DROP TABLE IF EXISTS core.dashboard_data_count;
  CREATE TABLE IF NOT EXISTS core.dashboard_data_count (
    countType varchar(70),
    totalCount float,
    classColor varchar(70)
  );

   /*insert total registered child count data*/
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('Total Child Registered'
		  ,(SELECT count(distinct base_entity_id) 
			FROM core."viewJsonDataConversionOfClient" 
			where entity_type = 'child')
		  , 'bg-primary');
									
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('% of the Children are reaching', 90, 'bg-warning');	
			
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('% Children who are growth faltering' 
		  , (SELECT round(((SELECT count(*) FROM (SELECT DISTINCT ON (base_entity_id) *
              FROM core.child_growth
              WHERE growth_status = false 
              ORDER BY base_entity_id, last_event_date DESC) growth_faltering) :: numeric
						  / (SELECT count(distinct base_entity_id) 
							FROM core."viewJsonDataConversionOfClient" 
							where entity_type = 'child') :: numeric) * 100, 2 ))
		  , 'bg-success');	
						
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('Total Pregnant Women Registered'
		  ,(SELECT count(*) 
			FROM core."viewJsonDataConversionOfEvent"
			where entity_type = 'mother' and is_pregnant = 'Yes')
		  , 'bg-danger');		
	
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('% of the Woman are Reaching', 70, 'bg-success');
	
   insert into core.dashboard_data_count(countType, totalCount, classColor)
   values('% of the Woman are followed Counseling', 30, 'bg-danger');
						
   /*Return whole dashboard_data_count data*/
   RETURN QUERY SELECT ttable.countType
       , coalesce(ttable.totalCount, 0) as totalCount
	   , ttable.classColor
       from core.dashboard_data_count ttable;
END;
$$ LANGUAGE plpgsql;
