CREATE OR REPLACE FUNCTION fn_dashboard_data_count()
RETURNS TABLE(registerType character varying, totalCount integer
              , thisMonthCount integer, lastSevenDaysCount integer
              , todaysCount integer)
AS $$
DECLARE
  
BEGIN

  /*Generating Temporary Table to populate aggregated values TEMPORARY*/
  DROP TABLE IF EXISTS dashboard_data_count;
  EXECUTE format('
   CREATE TEMPORARY TABLE IF NOT EXISTS %I (
    registerType varchar(70),
    totalCount int,
    thisMonthCount int,
    lastSevenDaysCount int,
    todaysCount int
   )', 'dashboard_data_count');

   /* insert household count data */
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('household',(select count(*) from household),
          (select count(*) from household where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from household where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from household where date(received_time)= current_date ));
          
          
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('elco',(select count(*) from elco),
          (select count(*) from elco where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from elco where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from elco where date(received_time)= current_date ));
          
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('mother',(select count(*) from mother),
          (select count(*) from mother where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from mother where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from mother where date(received_time)= current_date ));
           
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('child',(select count(*) from child),
          (select count(*) from child where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from child where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from child where date(received_time)= current_date ));
          
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('anc',(select count(*) from anc),
          (select count(*) from anc where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from anc where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from anc where date(received_time)= current_date ));
          
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('pnc',(select count(*) from pnc),
          (select count(*) from pnc where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from pnc where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from pnc where date(received_time)= current_date ));
          
   insert into dashboard_data_count(registerType,totalCount,thisMonthCount,lastSevenDaysCount,todaysCount)
   values('encc',(select count(*) from encc),
          (select count(*) from encc where date(received_time) between 
           date_trunc('month', current_date) and date_trunc('month',current_date)+ INTERVAL '1 MONTH - 1 day' ),
          (select count(*) from encc where date(received_time) between 
           CURRENT_DATE -INTERVAL '7 day' and CURRENT_DATE ),
          (select count(*) from encc where date(received_time)= current_date ));

   
   RETURN QUERY SELECT ttable.registerType
       , ttable.totalCount
       , ttable.thisMonthCount
       , ttable.lastSevenDaysCount
       , ttable.todaysCount
       from dashboard_data_count ttable;

END;
