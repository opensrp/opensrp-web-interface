CREATE OR REPLACE FUNCTION core.web_notification_details(_notification_id bigint)
 RETURNS TABLE(title text, notification text, status text, notification_type text, send_date_and_time text, branch_name text, division_name text, district_name text, upazilla_name text, role_name text,meeting_training_date_and_time text)
 LANGUAGE plpgsql
AS $function$
begin
	return query
WITH notification_details  AS ( select wn.id,
     	wn.title,
		wn.notification,wn.status,
		wn."type",
		wn.send_date_and_time,
		coalesce(split_part(l."name", ':', 1),'N/A')  as divisionName,		
		coalesce(split_part(ld."name", ':', 1),'N/A')  as district_name,		
		coalesce(split_part(lu."name", ':', 1),'N/A')  as upazilla_name,
		String_agg(b."name", ',') as branch,
		wn.meeting_training_date_and_time 
		
		
		from core.web_notification wn
		left join core."location" l on wn.division_id = l.id
		left join core."location" ld on wn.district_id = ld.id
		left join core."location" lu on wn.upazila_id = lu.id
		left join core.web_notification_branch wnb on wn.id= wnb.web_notification_id
		left join core.branch b on wnb.branch_id = b.id 
		group by wn.id,wn.title,l."name",wn."type",wn.send_date_and_time,ld."name",lu."name"
		),
		
 role_details  AS (SELECT  String_agg(r."name", ',')role_name,n.id
         FROM   core."role" r 
                JOIN core.web_notification_role  wrole
                join core.web_notification n on wrole.web_notification_id = n.id
                  ON wrole.role_id = r .id 
         GROUP  BY n.id) 
  
	SELECT  nd.title::text,
		nd.notification::text,
		nd.status::text,
		nd."type"::text as notification_type,
		nd.send_date_and_time::text,
		coalesce(nd.branch::text,'N/A') as branch_name,
		nd.divisionName::text as division_name,
		nd.district_name::text,
		nd.upazilla_name::text,
		coalesce(rd.role_name::text,'N/A') role_name,
		coalesce(nd.meeting_training_date_and_time::text,'N/A') meeting_training_date_and_time

FROM   notification_details nd 
       JOIN role_details rd 
         ON nd.id = rd.id 
         
WHERE  nd.id = 	_notification_id;
	

end;
$function$
;

