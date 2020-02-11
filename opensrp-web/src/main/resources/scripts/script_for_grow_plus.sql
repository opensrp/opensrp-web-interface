CREATE OR REPLACE FUNCTION core.getObsValue (rId bigint, formField varchar) 
RETURNS text
AS $$
  DECLARE json_object json;
  DECLARE item json;
  DECLARE val text;
  BEGIN
    SELECT E.json::json into json_object from core.event E where E.id = rId;
    FOR item IN SELECT * FROM json_array_elements((json_object->>'obs')::json)
    LOOP
        IF (item->>'formSubmissionField') = formField 
        THEN
        val = (item->>'values')::json->>0;
        END IF;
    END LOOP;
    return val;
  END;
  $$ LANGUAGE 'plpgsql';
  
select core.getObsValue (17, 'pregnant');

select core.getObsValue (17, 'age');


/*************************************************/

CREATE OR REPLACE FUNCTION core.latest_child_growth_status (baseEntityId varchar) 
RETURNS text
AS $$
  DECLARE val text;
  BEGIN
    SELECT growth_status into val
	FROM core.child_growth cg1
	WHERE  NOT EXISTS (
          SELECT *
          FROM core.child_growth cg2
          WHERE cg1.base_entity_id = cg2.base_entity_id
            AND cg1.event_date < cg2.event_date
  		)
  	 AND cg1.base_entity_id = baseEntityId;
    return val;
  END;
  $$ LANGUAGE 'plpgsql';
  
select core.latest_child_growth_status ('734eb1f8-97d3-42c5-82a4-275c2b45f1a8');

/*************************************************/

CREATE MATERIALIZED VIEW core."viewJsonDataConversionOfClient"
AS
SELECT DISTINCT c.id as id,
                c.json->>'baseEntityId' as base_entity_id,
                c.json->'addresses'->0->>'addressType' as address_type,
                cast(c.json->>'birthdate' as Date) as birth_date,
                c.json->'addresses'->0->'addressFields'->>'country' as country,
                c.json->>'dateCreated' as date_created,
                c.json->>'dateEdited' as date_edited,
                c.json->'addresses'->0->'addressFields'->>'countyDistrict' as district,
                c.json->'addresses'->0->'addressFields'->>'stateProvince' as division,
                c.json->>'firstName' as first_name,
                c.json->>'gender' as gender,
                c.json->'addresses'->0->'addressFields'->>'address5' as gobhhid,
                c.json->'attributes'->>'householdCode' as household_code,
                c.json->>'lastName' as lastname ,
                c.json->'addresses'->0->'addressFields'->>'address4' as mauzapara,
                c.json->'attributes'->>'nationalId' as national_id,
                c.json->'attributes'->>'Child_Birth_Certificate' as child_birth_certificate,
                c.json->'attributes'->>'phoneNumber' as phone_number,
                c.json->>'serverVersion' as server_version,
                c.json->'attributes'->>'spouseNameEnglish' AS spouse_name,
                c.json->'addresses'->0->'addressFields'->>'address3' as subunit,
                c.json->'addresses'->0->'addressFields'->>'address1' as client_union,
                c.json->'addresses'->0->'addressFields'->>'cityVillage' as upazila,
                UPPER(c.json->'addresses'->0->'addressFields'->>'address2') as ward,
                CASE WHEN (e.json->>'eventType' = 'New Woman Member Registration')
                    THEN e.json->'obs'->3->'values'->>0 ELSE null END latest_lmp,
                c.json->'relationships'->'household'->>0 as relationships_id,
                c.json->'identifiers'->>'Patient_Identifier' as health_id,
                e.json->>'providerId' as provider_id,
                e.json->>'entityType' as entity_type,
                e.json->>'eventType' as event_type,
                core.getObsValue(e.id, 'start') as member_reg_date,
                CASE WHEN (e.json->>'entityType' = 'child')
                    THEN e.json->'obs'->1->'values'->>0 ELSE null END as birth_weight,
                c.json -> 'attributes'::text ->> 'motherNameEnglish'::text AS mother_name,
                c.json->'attributes'->>'fatherNameEnglish' AS father_name,
                CASE WHEN (e.json->>'entityType' = 'child')
                    THEN core.latest_child_growth_status(e.json->>'baseEntityId') ELSE null END as latest_growth_status,
                e.json ->> 'team'::text AS cc_name,
                CASE WHEN (c.json->'attributes'->>'PregnancyStatus' = 'Antenatal Period')
                    THEN 'true'ELSE NULL END AS pregnancy_status,
                c.json -> 'attributes'::text ->> 'Religion'::text AS religion,
                c.json->'attributes'->>'spouseNameBangla' AS spouse_name_bangla,
                c.json -> 'attributes' ->>'fathernameBangla' AS father_name_bangla,
                c.json -> 'attributes'::text ->> 'motherNameBangla'::text AS mother_name_bangla,
                c.json -> 'attributes'::text ->> 'givenNameLocal'::text AS name_bangla,
FROM core.client c JOIN core.event e ON c.json->'baseEntityId' = e.json->'baseEntityId'
WHERE e.json->>'eventType' LIKE '%Registration%' WITH DATA;

GRANT ALL PRIVILEGES ON TABLE core."viewJsonDataConversionOfClient" TO opensrp_admin;

/*************************************************/

CREATE MATERIALIZED VIEW core."viewJsonDataConversionOfEvent"
AS
SELECT id
   , json->>'_id' as _id
   , json->>'baseEntityId' as base_entity_id
   , cast(json->>'dateCreated' as timestamp) as date_created
   , json->>'dateEdited' as date_edited
   , json->>'duration' as duration
   , json->>'entityType' as entity_type 
   , cast(json->>'eventDate' as Date) as event_date
   , json->>'eventType' as event_type
   , json->>'locationId' as location_id
   , json->>'obs' as observations
   , json->>'providerId' as provider_id
   , json->>'serverVersion' as server_version
   , CASE
    WHEN (json->>'eventType' = 'Lactating Woman Counselling') THEN cast(core.getobsvalue(id,'breastfeeding') as varchar)
	ELSE null
    END
	as breastfeeding 
    , CASE
    WHEN (json->>'eventType' = 'Lactating Woman Counselling') THEN cast(core.getobsvalue(id,'additional_liquids_other_than_breastmilk') as varchar)
	ELSE null
    END
	as additional_liquids_other_than_breastmilk 
   , CASE
    WHEN (json->>'eventType' = 'Lactating Woman Counselling') THEN cast(core.getobsvalue(id,'complimentary_amount') as varchar)
	ELSE null
    END 
    as complimentary_amount 
   , CASE
    WHEN (json->>'eventType' = 'Lactating Woman Counselling') THEN cast(core.getobsvalue(id,'lactating_counselling_actions_decided_previous_meeting') as varchar)
	ELSE null
    END
	as lactating_counselling_actions_decided_previous_meeting 
   , CASE
    WHEN (json->>'eventType' = 'Vaccination') THEN json->'obs'->1->'values'->>0
	ELSE null
    END
	as vaccination_name
   , CASE
    WHEN (json->>'entityType' = 'child') THEN json->'obs'->1->'values'->>0
	ELSE null
    END
	as birth_weight
   , CASE
    WHEN (json->>'entityType' = 'child') THEN json->'obs'->3->'values'->>0
	ELSE null
    END
	as mother_name
   ,  CASE
    WHEN ((json->>'eventType' = 'New Woman Member Registration')
	OR (json->>'eventType' = 'Woman Member Follow Up')) THEN cast(core.getObsValue(id, 'pregnant') as varchar)
	ELSE null
    END
	as is_pregnant
   ,  CASE
    WHEN (json->>'eventType' = 'New Woman Member Registration') THEN core.getObsValue(id, 'edd')
	ELSE null
    END
	as edd
   ,  CASE
    WHEN (json->>'eventType' = 'New Woman Member Registration') THEN core.getObsValue(id, 'lmp')
	ELSE null
    END
	as lmp
   , CASE
    WHEN (json->>'eventType' like '%Counselling%') THEN core.getObsValue(id, 'pregnant_counselling_actions_for_next_meeting')
	ELSE null
    END
	as pregnant_counselling_actions_for_next_meeting
   , CASE
    WHEN (json->>'eventType' = 'Woman Member Follow Up') THEN core.getObsValue(id, 'Visit_date')
	ELSE null
    END
	as follow_up_date
   , CASE
    WHEN (json->>'eventType' = 'Woman Member Follow Up') THEN core.getObsValue(id, 'Date_Of_next_appointment')
	ELSE null
    END
	as date_Of_next_appointment
   ,json->>'version' as version
   , CASE
    WHEN (json->>'eventType' like '%Counselling%') THEN json->'obs'->1->'values'->>0
	ELSE null
    END
	as woman_are_followed_counseling
   FROM core.event
WITH DATA;

GRANT ALL ON TABLE core."viewJsonDataConversionOfEvent" TO postgres;
GRANT ALL ON TABLE core."viewJsonDataConversionOfEvent" TO opensrp_admin;



/*************************************************/

CREATE MATERIALIZED VIEW core."viewJsonDataConversionOfWeight"
AS
SELECT cast(e.json->>'baseEntityId' as varchar) as base_entity_id   
   , cast(e.json->>'eventDate' as Date) as current_event_date
   , cast(e.json->>'entityType' as varchar) as entity_type   
   , cast(e.json->>'providerId' as varchar) as provider_id
   , cast(e.json->>'version' as  bigint) as server_version
   , cast(core.getObsValue (e.id, 'Weight_Kgs') as decimal) as current_weight
   , cast(core.getobsvalue(e.id,'Z_Score_Weight_Age') as decimal) as  z_score
   , cast(c.json->>'birthdate' as Date) as dob 
   , c.json->>'gender' as gender
   , cast(c.json->'addresses'->0->'addressFields'->>'gps' as varchar) as gps
   , cast(core.getobsvalue(bre.id,'Birth_Weight')  as decimal) as birth_weight
   , cast(c.json->>'firstName' as varchar) as first_name
   FROM core.event e  JOIN core.client c ON c.json->'baseEntityId' = e.json->'baseEntityId'
   join core.event bre on c.json->'baseEntityId' = bre.json->'baseEntityId'   
   where e.json->>'entityType'='weight' and bre.json->>'eventType'='Birth Registration'
   order by e.id desc
WITH DATA;

GRANT ALL ON TABLE core."viewJsonDataConversionOfWeight" TO postgres;
GRANT ALL ON TABLE core."viewJsonDataConversionOfWeight" TO opensrp_admin;





/*************************************************/


CREATE OR REPLACE FUNCTION core.breastfeed_and_complementary_foods (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$
    DECLARE json_object json;
    DECLARE item json;
    DECLARE breastFeeding varchar = '';
    DECLARE complementaryFood varchar = '';
    DECLARE breastFeedAndcomplementaryFood int = 2;
    DECLARE childs RECORD;
    DECLARE eventRow RECORD;
    DECLARE totalCount int:= 0; 
    DECLARE totalCountInEvent int:= 0; 
   	eventBetweenDateCondition varchar := '';
    clientdateBetweenCondition varchar :='';
    sixToNineAgedCondition varchar := '';
    BEGIN  
    if (startDate != '' AND endDate != '') THEN 
    	endDate = E'\''||endDate || E'\'';
        startDate = E'\''||startDate || E'\'';
		eventBetweenDateCondition := eventBetweenDateCondition || E' and ( event_date between '|| startDate || ' and '
                             || endDate ||')';
         clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        sixToNineAgedCondition =' and (
            ( DATE_PART (' || E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)>181
                 and  DATE_PART('|| E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)<271 and birth_date <'||startDate ||'
                 ) OR ' || clientdateBetweenCondition ||')';
        ELSE
            endDate = E'\''||NOW()|| E'\'';
            eventBetweenDateCondition := '';
            sixToNineAgedCondition =' and (
            ( DATE_PART(' || E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)>181
                 and DATE_PART('|| E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)<271 and birth_date <='|| endDate ||')
            )';
        END IF;
    	FOR childs IN
             EXECUTE 'SELECT c.base_entity_id as baseEntityId,c.birth_date as dob FROM core."viewJsonDataConversionOfClient" as c  
            WHERE c.event_type =' || E' \'Birth Registration\' '|| conditions || sixToNineAgedCondition
           --  and provider_id='joom'
           -- and base_entity_id ='7d8782d9-ded5-4d57-beab-b9f1b5ef1e73'
            LOOP	
            
            EXECUTE 'SELECT count(*) FROM core."viewJsonDataConversionOfEvent" e  
                WHERE e.event_type ='|| E'\'Lactating Woman Counselling\'                
                and e.base_entity_id ='||E' \''||childs.baseEntityId ||E'\'' || eventBetweenDateCondition into totalCountInEvent ;
            IF totalCountInEvent != 0
            THEN
            FOR eventRow IN 
                EXECUTE 'SELECT * FROM core."viewJsonDataConversionOfEvent" e  
                WHERE e.event_type ='|| E'\'Lactating Woman Counselling\'                
                and e.base_entity_id ='||E' \''||childs.baseEntityId ||E'\'' || eventBetweenDateCondition 
               
                LOOP                	
                	breastfeeding = eventRow.breastfeeding;                
                    complementaryFood = eventRow.complimentary_amount;
                    IF breastfeeding = 'No'  OR complementaryFood ='0' OR complementaryFood IS NULL
                        THEN
                        breastFeedAndcomplementaryFood = 1;
                        Exit  ;
                     ELSE
                     breastFeedAndcomplementaryFood = 0;
                    END IF;
                    
                END LOOP;
            ELSE
            	breastFeedAndcomplementaryFood  = 1;
			END IF	;
            IF breastFeedAndcomplementaryFood = 0
            	THEN 
                totalCount = totalCount+1;
                --RAISE NOTICE 'i want to print % ', breastFeedAndcomplementaryFood;
            END IF;
   		END LOOP;
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
  
  
select core.breastfeed_and_complementary_foods('','2018-03-01','2018-08-01');
select core.breastfeed_and_complementary_foods('','','');



/*************************************************/

CREATE OR REPLACE FUNCTION core.child_growth_report(filterArray text[])
RETURNS TABLE(provider_name character varying, falter int
              , growth int)
AS $$
DECLARE
  filterString varchar := '';
  completeCountFilterString varchar := '';  
  div varchar := '';
  dis varchar := '';
  upa varchar := '';
  uni varchar := '';
  war varchar := '';
  sub varchar := '';
  mau varchar := ''; 
  start_date varchar := '';
  end_date varchar := '';
  eventBetweenCondition varchar := '';
  clientDateBetweenCondition varchar := '';
  
BEGIN
  div := filterArray[1];
  dis := filterArray[2];
  upa := filterArray[3];
  uni := filterArray[4];
  war := filterArray[5];
  sub := filterArray[6];
  mau := filterArray[7]; 
  start_date := filterArray[9];
  end_date := filterArray[10];
 
 DROP TABLE IF EXISTS child_growth_temp;
 CREATE TEMP TABLE IF NOT EXISTS child_growth_temp (
  	provider_name varchar(70) ,  
	falter int NOT NULL DEFAULT 0,  
  	growth int NOT NULL DEFAULT 0,  
  	PRIMARY KEY (provider_name)  
);


/*Creating location conditions query string*/
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

   if (sub != '') THEN
       filterString := filterString || E' and subunit=\'' || sub || E'\'';
   END IF;

   if (mau != '') THEN
       filterString := filterString || E' and mauzapara=\'' || mau || E'\'';
   END IF;
   
	IF (start_date != '' AND end_date != '') THEN            
		end_date = E'\''|| end_date || E'\'';
        start_date = E'\''||start_date || E'\'';
		eventBetweenCondition := eventBetweenCondition || E' and ( event_date between '|| start_date || ' and '
                             || end_date ||')';   
   END IF;
   
EXECUTE 'insert into child_growth_temp(provider_name)
select provider_id from  core."viewJsonDataConversionOfClient" as c
where c.event_type =' || E' \'Birth Registration\'' || filterString  ||' group by provider_id';
    
  /* update falter list  */
 EXECUTE 'update child_growth_temp
    set falter = growth_report.falter from
    (select gf.provider,count(gf.provider)
            FROM core."viewJsonDataConversionOfClient" c
            join 
                (SELECT provider, base_entity_id,growth_status,event_date
                 FROM core.child_growth cg1
                 WHERE cg1.growth_status=false ' || eventBetweenCondition ||' and NOT EXISTS (
                   SELECT *
                   FROM core.child_growth cg2
                   WHERE cg1.base_entity_id = cg2.base_entity_id
                     AND cg1.event_date < cg2.event_date
                   ) order by base_entity_id desc
                ) as gf
             on c.base_entity_id = gf.base_entity_id
            WHERE c.event_type =' || E' \'Birth Registration\'' || filterString ||' group by gf.provider) as growth_report(provider_id, falter)
    where child_growth_temp.provider_name = growth_report.provider_id';
   
   
   EXECUTE 'update child_growth_temp
    set growth = growth_report.growth from
    (select gf.provider,count(gf.provider)
            FROM core."viewJsonDataConversionOfClient" c
            join 
                (SELECT provider, base_entity_id,growth_status,event_date
                 FROM core.child_growth cg1
                 WHERE cg1.growth_status=true ' || eventBetweenCondition ||' and NOT EXISTS (
                   SELECT *
                   FROM core.child_growth cg2
                   WHERE cg1.base_entity_id = cg2.base_entity_id
                     AND cg1.event_date < cg2.event_date
                   ) order by base_entity_id desc
                ) as gf
             on c.base_entity_id = gf.base_entity_id
            WHERE c.event_type =' || E' \'Birth Registration\'' || filterString ||' group by gf.provider) as growth_report(provider_id, growth)
    where child_growth_temp.provider_name = growth_report.provider_id';
					

RETURN QUERY SELECT  ttable.provider_name
       , ttable.falter
       , ttable.growth       
       from child_growth_temp ttable;
END;
$$ LANGUAGE plpgsql;

SELECT core.child_growth_report(array['Jessore','','','','','','','','2017-01-02','2018-02-01']); 



/*************************************************/

CREATE OR REPLACE FUNCTION core.counseled_pregnant_women (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalSize int;
    DECLARE returnVal varchar;
    DECLARE i varchar; 
    DECLARE totalCount int:=0; 
   	DECLARE childs RECORD;
    dateBetweenConditionInClient varchar := '';
    dateBetweenConditionInEvent varchar := '';
    BEGIN  
    if (startDate != '' AND endDate != '') THEN            
		dateBetweenConditionInClient := dateBetweenConditionInClient || E' and( member_reg_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
		dateBetweenConditionInEvent := dateBetweenConditionInEvent || E' and( event_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
    END IF; 
    FOR childs IN 
		EXECUTE 'SELECT c.base_entity_id as baseEntityId,c.birth_date as dob FROM core."viewJsonDataConversionOfClient" as c  
            WHERE c.event_type =' || E' \'New Woman Member Registration\' ' || conditions
           --  and provider_id='joom'
           -- and base_entity_id ='45520784-1360-4136-842a-b1dcf5e34537'
            
            LOOP        
                EXECUTE 'SELECT count(*) FROM core."viewJsonDataConversionOfEvent" e  
                WHERE e.event_type ='|| E'\'Pregnant Woman Counselling\'                
                and e.base_entity_id ='||E' \''||childs.baseEntityId ||E'\'' || dateBetweenConditionInEvent  into totalSize;
                IF totalSize > 0 
                    THEN
                 totalCount= totalCount+1;           
                END IF;
            END LOOP;
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';


/*************************************************/

CREATE OR REPLACE FUNCTION core.exclusively_breastfeed (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$
    DECLARE json_object json;
    DECLARE item json;
    DECLARE totalCount int:= 0; 
    DECLARE val varchar = '';   
    DECLARE eventRow RECORD;
    DECLARE childs RECORD;    
    eventBetweenDateCondition varchar := '';
    clientdateBetweenCondition varchar := '';
    underSixCondition varchar := '';
    BEGIN  
    if (startDate != '' AND endDate != '') THEN 
    	endDate = E'\''||endDate|| E'\'';
        startDate = E'\''||startDate|| E'\'';		
        eventBetweenDateCondition := eventBetweenDateCondition || E' and ( event_date between '|| startDate || ' and '
                             || endDate ||')';
        clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        underSixCondition = ' and ( ( DATE_PART('|| E'\'day\',' || startDate ||'::timestamp - c.birth_date::timestamp)<=180 
        and  birth_date<='|| startDate ||') OR '|| clientdateBetweenCondition || ')';
    ELSE
    	endDate = E'\''||NOW()|| E'\'';
		eventBetweenDateCondition := '';
        underSixCondition = ' and DATE_PART('|| E'\'day\',' || endDate ||'::timestamp - c.birth_date::timestamp)<=180 and  birth_date <='|| endDate;
    END IF;
   	FOR childs IN 
           
             EXECUTE 'SELECT c.base_entity_id as baseEntityId,c.birth_date as dob FROM core."viewJsonDataConversionOfClient" as c  
             WHERE c.event_type =' || E' \'Birth Registration\' '|| conditions || underSixCondition
             --and base_entity_id ='82ff2d31-b00f-4767-ade8-3a10079686bb'
            LOOP
            val = '';
            FOR eventRow IN 
                EXECUTE 'SELECT * FROM core."viewJsonDataConversionOfEvent" e  
                WHERE e.event_type ='|| E'\'Lactating Woman Counselling\'                
                and e.base_entity_id ='||E' \''||childs.baseEntityId ||E'\'' || eventBetweenDateCondition                
                LOOP                   
                    val = eventRow.additional_liquids_other_than_breastmilk; 
                    IF val = 'Yes' 
                        THEN
                        EXIT;               
                    END IF;
                END LOOP;
                 IF val='No'
                    THEN 
                    totalCount= totalCount+1;
                   --RAISE NOTICE 'i want to print % ', val;
                 END IF;
                
			END LOOP;
   	
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
  

  
  select core.exclusively_breastfeed('','','');



/*************************************************/

CREATE OR REPLACE FUNCTION core.under_six_child_mother_counseled (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    dateConditionInEvent varchar := '';
    clientdateBetweenCondition varchar := '';
    underSixAgedCondition varchar := '';
    BEGIN      
    if (startDate != '' AND endDate != '') THEN     	
    	endDate = E'\''||endDate || E'\'';
        startDate = E'\''||startDate || E'\'';
		dateConditionInEvent := dateConditionInEvent || E' and ( event_date between '|| startDate || ' and '
                             || endDate ||')';
        clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        underSixAgedCondition = ' and ( ( DATE_PART('|| E'\'day\',' || startDate ||'::timestamp - c.birth_date::timestamp)<=180 
        and  birth_date<='|| startDate ||') OR '|| clientdateBetweenCondition || ')';
	ELSE
        
    	endDate = E'\''||NOW()|| E'\'';
		dateConditionInEvent := '';
        underSixAgedCondition = ' and DATE_PART('|| E'\'day\',' || endDate ||'::timestamp - c.birth_date::timestamp)<=180 and  birth_date <'|| endDate;
    END IF;   
    EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c            
            WHERE c.event_type ='|| E' \'Birth Registration\' ' || underSixAgedCondition || conditions  into totalCount;
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
  
  select core.under_six_child_mother_counseled('','2018-06-01','2018-06-05');


/*************************************************/

CREATE OR REPLACE FUNCTION core.under_six_to_nine_child (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    endDateCondition varchar := '';
    clientdateBetweenCondition varchar :='';
    sixToNineAgedCondition varchar := '';
    BEGIN      
    if (startDate != '' AND endDate != '') THEN            
		endDate = E'\''|| endDate || E'\'';
        startDate = E'\''||startDate || E'\'';
        clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        sixToNineAgedCondition =' and (
            ( DATE_PART (' || E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)>181
                 and  DATE_PART('|| E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)<271 and birth_date <'||startDate ||'
                 ) OR ' || clientdateBetweenCondition ||')';
    ELSE   
        endDate = E'\''||NOW()|| E'\'';
        sixToNineAgedCondition =' and (
            ( DATE_PART(' || E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)>181
                 and DATE_PART('|| E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)<271 and birth_date <='|| endDate ||')
            )';
	END IF; 
     EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c            
            WHERE c.event_type =' || E' \'Birth Registration\'' || sixToNineAgedCondition || conditions  into totalCount ;
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
  
  select core.under_six_to_nine_child('','2018-03-01','2018-08-01');
    select core.under_six_to_nine_child('','','');


/*************************************************/

CREATE OR REPLACE FUNCTION core.growth_faltering (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    betweenCondition varchar := '';
  
    BEGIN  
    if (startDate != '' AND endDate != '') THEN            
		betweenCondition := betweenCondition || E' and( cg1.event_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
	END IF;
    	 EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c
            join 
                (SELECT base_entity_id,growth_status,event_date
                 FROM core.child_growth cg1
                 WHERE cg1.growth_status=false ' || betweenCondition ||' and NOT EXISTS (
                   SELECT *
                   FROM core.child_growth cg2
                   WHERE cg1.base_entity_id = cg2.base_entity_id
                     AND cg1.event_date < cg2.event_date
                   ) order by base_entity_id desc
                ) as gf
             on c.base_entity_id = gf.base_entity_id
            WHERE c.event_type =' || E' \'Birth Registration\'' || conditions   INTO totalCount ;
            --- should be changed next to event date 
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';


/*************************************************/

CREATE OR REPLACE FUNCTION core.total_child (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    betweenCondition varchar := '';
    BEGIN      
    if (startDate != '' AND endDate != '') THEN            
		betweenCondition := betweenCondition || E' and( c.date_created between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
	END IF;
    
     EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c            
            WHERE c.event_type =' || E' \'Birth Registration\'' || betweenCondition || conditions INTO totalCount;
            --- should be changed next to event date 
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';



/*************************************************/

CREATE OR REPLACE FUNCTION core.two_month_growth_faltering_consecutively (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    betweenCondition varchar := '';
    BEGIN  
    if (startDate != '' AND endDate != '') THEN            
		betweenCondition := betweenCondition || E' and( cg.event_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
        END IF;
    	EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c
            join core.child_growth cg 
             on c.base_entity_id = cg.base_entity_id
            WHERE c.event_type =' || E' \'Birth Registration\' and cg.chronical_faltering>=2 '
            || betweenCondition || conditions INTO totalCount ;  
            --- should be changed next to event date 
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';



/*************************************************/

CREATE OR REPLACE FUNCTION core.total_children_measured_over_two_weigth_record(conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    dateBetweenCondition varchar := '';
    BEGIN      
    if (startDate != '' AND endDate != '') THEN            
		dateBetweenCondition := dateBetweenCondition || E' and( cg.event_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
	END IF;
    
    	DROP TABLE IF EXISTS over_two_weigth_record_temp;
         CREATE TEMP TABLE IF NOT EXISTS over_two_weigth_record_temp (
            total int NOT NULL DEFAULT 0 
            
        );
        
      EXECUTE 'insert into over_two_weigth_record_temp(total) 
		select count(*)
        FROM core."viewJsonDataConversionOfClient" c
        join core.child_growth  cg
        on c.base_entity_id = cg.base_entity_id	
        WHERE c.event_type =' || E' \'Birth Registration\'' || conditions || dateBetweenCondition || 'group by cg.base_entity_id having count(cg.base_entity_id)>=2 order by cg.base_entity_id';
	
    return (select count(*) from over_two_weigth_record_temp);
  END;
  $$ LANGUAGE 'plpgsql';
  
  
    SELECT core.total_children_measured_over_two_weigth_record('','2018-02-07','2018-08-15'); 


/*************************************************/

CREATE OR REPLACE FUNCTION core.committed_previous_action (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$
    DECLARE json_object json;
    DECLARE item json;
    DECLARE i varchar; 
    DECLARE totalCount int:=0; 
    DECLARE childs RECORD;
    DECLARE val varchar = '';
    DECLARE returnVal varchar = 'Yes';
    DECLARE eventRow RECORD;
    DECLARE totalSize int;
    dateBetweenCondition varchar := '';
    BEGIN  
    if (startDate != '' AND endDate != '') THEN            
		dateBetweenCondition := dateBetweenCondition || E' and ( event_date between \''|| startDate || E'\' and \''
                             || endDate || E'\')';
        END IF;   
       FOR childs IN            
            EXECUTE 'select c.base_entity_id as baseEntityId,c.birth_date as dob
            FROM core."viewJsonDataConversionOfClient" c
            join 
                (SELECT base_entity_id,growth_status,event_date
                 FROM core.child_growth cg1
                 WHERE cg1.growth_status=false ' || dateBetweenCondition ||' and NOT EXISTS (
                   SELECT *
                   FROM core.child_growth cg2
                   WHERE cg1.base_entity_id = cg2.base_entity_id
                     AND cg1.event_date < cg2.event_date
                   ) order by base_entity_id desc
                ) as gf
             on c.base_entity_id = gf.base_entity_id
            WHERE c.event_type =' || E' \'Birth Registration\'' || conditions 
            -- and base_entity_id ='a159347c-081c-4dce-ab2b-4324aa21f75f' 
            -- and provider_id='joom'
          
        LOOP 
        	val = '';
            FOR eventRow IN 
            	EXECUTE 'SELECT * FROM core."viewJsonDataConversionOfEvent" e  
                WHERE e.event_type ='|| E'\'Lactating Woman Counselling\'                
                and e.base_entity_id ='||E' \''||childs.baseEntityId ||E'\'' || dateBetweenCondition
                
                LOOP
                    val = eventRow.lactating_counselling_actions_decided_previous_meeting; 
                    IF val = 'No' 
                        THEN                    
                        EXIT;               
                    END IF;
            	END LOOP;
            IF val='Yes'
                THEN 
                totalCount= totalCount+1;
             END IF;
        END LOOP; 
    return  totalCount; 
   	
  END;
  $$ LANGUAGE 'plpgsql';
  
  SELECT core.committed_previous_action('','2018-01-01','2018-08-08'); 


/*************************************************/

CREATE OR REPLACE FUNCTION core.severely_underweight (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE weightDifference float;    
    DECLARE totalCount int:=0; 
   	DECLARE childs RECORD;
    dateBetweenCondition varchar := '';
    clientdateBetweenCondition varchar :='';
    sixTotwentythreeAgedCondition varchar := '';
    BEGIN  
    	if (startDate != '' AND endDate != '') THEN  
        endDate = E'\''|| endDate || E'\'';
        startDate = E'\''||startDate || E'\'';                             
        dateBetweenCondition := dateBetweenCondition || E' and ( cg1.event_date between '|| startDate || ' and '
                             || endDate ||')';                             
        clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        sixTotwentythreeAgedCondition =' and (
            ( DATE_PART (' || E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)>181
                 and  DATE_PART('|| E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)<691 and birth_date <'||startDate ||'
                 ) OR ' || clientdateBetweenCondition ||')';
    	ELSE   
        endDate = E'\''||NOW()|| E'\'';
        sixTotwentythreeAgedCondition =' and (
            ( DATE_PART(' || E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)>181
                 and DATE_PART('|| E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)<691 and birth_date <='|| endDate ||')
            )';
        END IF;
        
    	FOR childs IN         
            EXECUTE 'SELECT c.base_entity_id as baseEntityId,c.birth_date as dob FROM core."viewJsonDataConversionOfClient" as c  
            WHERE c.event_type =' || E' \'Birth Registration\' '|| conditions  || sixTotwentythreeAgedCondition         
           --  and provider_id='joom'
           --  and base_entity_id ='536f5c9a-f953-4514-a40b-dd1a454f9705'
            
            LOOP        
               EXECUTE 'SELECT weight - (SELECT  weight   FROM core.child_growth cg 
    			WHERE cg.base_entity_id=cg1.base_entity_id And cg.event_date<cg1.event_date 
    			ORDER BY event_date DESC  limit 1)  as difference   
				FROM core.child_growth cg1
	 			where base_entity_id =' ||E' \''||childs.baseEntityId ||E'\' '|| dateBetweenCondition ||
                'ORDER BY cg1.event_date desc limit 1'
				 into weightDifference ;
                IF weightDifference < 0 
                    THEN
                 totalCount= totalCount+1;           
                END IF;
            END LOOP;
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
  
  SELECT core.severely_underweight('','2018-02-07','2018-08-15'); 



/*************************************************/


CREATE OR REPLACE FUNCTION core.total_child_six_to_twentythree (conditions varchar,startDate varchar,endDate varchar) 
RETURNS int
AS $$    
    DECLARE totalCount int:=0; 
    betweenCondition varchar := '';
    clientdateBetweenCondition varchar :='';
    sixTotwentythreeAgedCondition varchar := '';
    BEGIN      
   	IF (startDate != '' AND endDate != '') THEN            
		endDate = E'\''|| endDate || E'\'';
        startDate = E'\''||startDate || E'\'';
        clientdateBetweenCondition := clientdateBetweenCondition || E'  ( birth_date between '|| startDate || ' and '
                             || endDate ||')';
        sixTotwentythreeAgedCondition =' and (
            ( DATE_PART (' || E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)>181
                 and  DATE_PART('|| E'\'day\','|| startDate || '::timestamp - c.birth_date::timestamp)<691 and birth_date <'||startDate ||'
                 ) OR ' || clientdateBetweenCondition ||')';
    	ELSE   
        endDate = E'\''||NOW()|| E'\'';
        sixTotwentythreeAgedCondition =' and (
            ( DATE_PART(' || E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)>181
                 and DATE_PART('|| E'\'day\','|| endDate || '::timestamp - c.birth_date::timestamp)<691 and birth_date <='|| endDate ||')
            )';
	END IF; 
    
     EXECUTE 'select count(*)
            FROM core."viewJsonDataConversionOfClient" c            
            WHERE c.event_type =' || E' \'Birth Registration\'' || sixTotwentythreeAgedCondition || conditions INTO totalCount;
            --- should be changed next to event date 
    return totalCount;
  END;
  $$ LANGUAGE 'plpgsql';
   select core.total_child_six_to_twentythree('','','');

/*************************************************/

CREATE OR REPLACE FUNCTION core.child_summary_report(filterArray text[])
RETURNS TABLE(indicator_name character varying, indicator_value int
              , total int)
AS $$
DECLARE
  filterString varchar := '';
  dateBetweenCondition varchar := '';  
  div varchar := '';
  dis varchar := '';
  upa varchar := '';
  uni varchar := '';
  war varchar := '';
  sub varchar := '';
  mau varchar := ''; 
  start_date varchar := '';
  end_date varchar := '';

BEGIN
  div := filterArray[1];
  dis := filterArray[2];
  upa := filterArray[3];
  uni := filterArray[4];
  war := filterArray[5];
  sub := filterArray[6];
  mau := filterArray[7]; 
  start_date := filterArray[9];
  end_date := filterArray[10];

/*Creating location conditions query string*/
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

   if (sub != '') THEN
       filterString := filterString || E' and subunit=\'' || sub || E'\'';
   END IF;

   if (mau != '') THEN
       filterString := filterString || E' and mauzapara=\'' || mau || E'\'';
   END IF;

   
   /*Creating date conditions query string*/
	if (start_date != '' AND end_date != '') THEN            
		dateBetweenCondition :=  E' and member_reg_date between \''|| start_date || E'\' and \''
                             || end_date || E'\'';
	END IF; 
   
 DROP TABLE IF EXISTS child_indicator_temp;
 CREATE TEMP TABLE IF NOT EXISTS child_indicator_temp (
  	indicator_name varchar(150) ,  
	indicator_value int NOT NULL DEFAULT 0,  
  	total int NOT NULL DEFAULT 0,  
  	PRIMARY KEY (indicator_name)  
);

EXECUTE 'insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('|| E' \'% of population we are reaching: \',(select count(*) from core."viewJsonDataConversionOfClient" 
where entity_type =' || E' \'child\''||filterString || dateBetweenCondition || '),1000)';



insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of pregnant women counseled:',core.counseled_pregnant_women(filterString, start_date,end_date),100); 

insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of children under six months who are exclusively breastfeed :',core.exclusively_breastfeed( filterString, start_date,end_date),core.under_six_child_mother_counseled(filterString, start_date,end_date));
 				
insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of timely introduction of complementary food :',core.breastfeed_and_complementary_foods(filterString, start_date,end_date),core.under_six_to_nine_child(filterString, start_date,end_date));

insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of children who are growth faltering :',core.growth_faltering(filterString, start_date,end_date),core.total_child(filterString, start_date,end_date));

insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of children growth faltering for 2 months consecutively :',core.two_month_growth_faltering_consecutively(filterString, start_date,end_date),core.total_children_measured_over_two_weigth_record(filterString, start_date,end_date));


insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of women with an underweight child committed to a small doable action before next appointment :',core.committed_previous_action(filterString, start_date,end_date),core.growth_faltering( filterString, start_date,end_date));

insert into child_indicator_temp(indicator_name,indicator_value,total) 
values('% of severely underweight children 6-23 months :',core.severely_underweight(filterString, start_date,end_date),core.total_child_six_to_twentythree(filterString, start_date,end_date));


RETURN QUERY SELECT  ttable.indicator_name
       , ttable.indicator_value
       , ttable.total       
       from child_indicator_temp ttable;
END;
$$ LANGUAGE plpgsql;

SELECT core.child_summary_report(array['Khulna','Jhenaidah','Maheshpur','Fatepur','Fatepur:Ward-2','Fatepur:Ward-2:1-KA','Fatepur:Ward-2:1-KA:EPI center','2018-02-07','2018-08-15']); 
SELECT core.child_summary_report(array['','','','','','','','','']);
  


/*************************************************/

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




/*************************************************/

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
   select date_part('month', date(event_date))
   , count(date_part('month', date(event_date)))
   from core.child_growth cg1
   WHERE cg1.growth_status=false and NOT EXISTS (
				  SELECT *
				  FROM core.child_growth cg2
				  WHERE cg1.base_entity_id = cg2.base_entity_id
				  AND cg1.event_date < cg2.event_date
			  )
   group by date_part('month', date(event_date))
   order by date_part('month', date(event_date)) asc;

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



/*************************************************/


CREATE OR REPLACE FUNCTION core.multi_linegraph_for_growth_faltering()
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


/*************************************************/

CREATE OR REPLACE FUNCTION core.refresh_all_materialized_views (schema_arg TEXT DEFAULT 'core')
RETURNS INT AS $$
DECLARE
    r RECORD;
    successCount INT;
BEGIN
    RAISE NOTICE 'Refreshing materialized view in schema %', schema_arg;
    successCount=0;
    FOR r IN SELECT matviewname FROM pg_matviews WHERE schemaname = schema_arg 
    LOOP
        RAISE NOTICE 'Refreshing %.%', schema_arg, r.matviewname;
        EXECUTE 'REFRESH MATERIALIZED VIEW ' || schema_arg || '."' || r.matviewname || '" WITH DATA'; 
        successCount= successCount+1;
 
    END LOOP;
    
    RETURN successCount;
END 
$$ LANGUAGE plpgsql
SECURITY DEFINER;

select * from core.refresh_all_materialized_views();
  



