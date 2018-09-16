package org.opensrp.connector.openmrs.service.impl;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.APIService;
import org.opensrp.connector.util.HttpUtil;
import org.springframework.stereotype.Service;

@Service
public class OpenSRPAPIServiceImpl extends OpensrpCredentialsService implements APIService{

	@Override
	public JSONObject add(String payload, JSONObject jsonObject, String URL)
			throws JSONException {
		System.out.println("json object: " + jsonObject);
		
		String sample = "{\n  \"clients\": [\n    {\n      \"relationships\": {},\n      \"deathdateApprox\": false,\n      \"clientApplicationVersion\": 1,\n      \"addresses\": [\n        {\n          \"addressFields\": {\n            \"cityVillage\": \"MITHAMAIN\",\n            \"country\": \"BANGLADESH\",\n            \"address2\": \"BAIRATI: WARD 3\",\n            \"address3\": \"null\",\n            \"address4\": \"null\",\n            \"address5\": \"null\",\n            \"address6\": \"null\",\n            \"address1\": \"BAIRATI\",\n            \"stateProvince\": \"DHAKA\",\n            \"countyDistrict\": \"KISHOREGONJ\",\n            \"gps\": \"null null\"\n          },\n          \"addressType\": \"usual_residence\"\n        }\n      ],\n      \"firstName\": \"runizi\",\n      \"baseEntityId\": \"e4595f35-2cc5-9084-1518-1a36866a655e\",\n      \"middleName\": \"null\",\n      \"gender\": \"F\",\n      \"_rev\": \"v1\",\n      \"identifiers\": {\n        \"Patient_Identifier\": \"10005090\"\n      },\n      \"birthdate\": \"1960-01-28T00:00:00.000+06:00\",\n      \"dateCreated\": \"2018-09-13T11:48:57.930+06:00\",\n      \"isSendToOpenMRS\": \"yes\",\n      \"clientDatabaseVersion\": 1,\n      \"lastName\": \"-\",\n      \"birthdateApprox\": false,\n      \"attributes\": {\n        \"phoneNumber\": \"01716435644\",\n        \"householdCode\": \"128\",\n        \"MaritalStatus\": \"Divorced\"\n      },\n      \"_id\": \"13b869ee4-a045-49eb-8d35-129a814ruq\",\n      \"type\": \"Client\",\n      \"serverVersion\": 1536843396000\n    }\n  ],\n  \"events\": [\n    {\n      \"isSendToOpenMRS\": \"yes\",\n      \"eventType\": \"Household Registration\",\n      \"_rev\": \"v2\",\n      \"entityType\": \"ec_household\",\n      \"teamId\": \"1e815e13-f6ca-42ef-97c8-83394c201a47\",\n      \"duration\": 0,\n      \"version\": 1536843396000,\n      \"formSubmissionId\": \"26a88670-e073-4834-962e-2e91ef9b2c19\",\n      \"clientDatabaseVersion\": 1,\n      \"type\": \"Event\",\n      \"serverVersion\": 1536843396000,\n      \"dateCreated\": \"2018-09-13T15:27:50.529+06:00\",\n      \"baseEntityId\": \"e4595f35-2cc5-9084-1518-1a36866a655e\",\n      \"locationId\": \"76d07f22-6c01-4afc-9d38-5c8d5ee74c05\",\n      \"eventDate\": \"2018-09-13T21:29:10.078+06:00\",\n      \"_id\": \"b89e03d4-9516-4a0b-b105-19426c015fa3\",\n      \"identifiers\": {},\n      \"providerId\": \"ftp\",\n      \"team\": \"Dev\",\n      \"clientApplicationVersion\": 1,\n      \"obs\": [\n        {\n          \"formSubmissionField\": \"HIE_FACILITIES\",\n          \"fieldDataType\": \"text\",\n          \"parentCode\": \"\",\n          \"values\": [\n            \"[\\\"BANGLADESH\\\",\\\"DHAKA\\\",\\\"KISHOREGONJ\\\",\\\"MITHAMAIN\\\",\\\"BAIRATI\\\",\\\"BAIRATI: WARD 3\\\"]\"\n          ],\n          \"fieldType\": \"formsubmissionField\",\n          \"humanReadableValues\": [],\n          \"fieldCode\": \"HIE_FACILITIES\"\n        },\n        {\n          \"formSubmissionField\": \"Date_Of_Reg\",\n          \"fieldDataType\": \"text\",\n          \"parentCode\": \"\",\n          \"values\": [\n            \"13-09-2018\"\n          ],\n          \"fieldType\": \"formsubmissionField\",\n          \"humanReadableValues\": [],\n          \"fieldCode\": \"Date_Of_Reg\"\n        }\n      ]\n    }\n  ]\n}";
		
		JSONObject jo = new JSONObject();
		JSONObject joarrayelement = new JSONObject();
		joarrayelement.put("firstName", "Jerry");
		joarrayelement.put("baseEntityId", "e4595f35-2cc5-9084-1518-1a36866a655e");
		JSONArray ja = new JSONArray();
		ja.put(joarrayelement);
		jo.put("clients", ja);
		
		System.out.println("first char: " +jo.toString().charAt(0));
		
		System.out.println("jo object: " + jo.toString());
		return new JSONObject(HttpUtil.post(getURL() + "/" + URL, payload, jo.toString(), OPENSRP_USER, OPENSRP_PWD)
		        .body());
	}
	
	public void updateClient(String payload, JSONObject jsonObject, String URL)
			throws JSONException {
		System.out.println("json object: " + jsonObject);
		
		String sample = "{\n  \"clients\": [\n    {\n      \"relationships\": {},\n      \"deathdateApprox\": false,\n      \"clientApplicationVersion\": 1,\n      \"addresses\": [\n        {\n          \"addressFields\": {\n            \"cityVillage\": \"MITHAMAIN\",\n            \"country\": \"BANGLADESH\",\n            \"address2\": \"BAIRATI: WARD 3\",\n            \"address3\": \"null\",\n            \"address4\": \"null\",\n            \"address5\": \"null\",\n            \"address6\": \"null\",\n            \"address1\": \"BAIRATI\",\n            \"stateProvince\": \"DHAKA\",\n            \"countyDistrict\": \"KISHOREGONJ\",\n            \"gps\": \"null null\"\n          },\n          \"addressType\": \"usual_residence\"\n        }\n      ],\n      \"firstName\": \"runizi\",\n      \"baseEntityId\": \"e4595f35-2cc5-9084-1518-1a36866a655e\",\n      \"middleName\": \"null\",\n      \"gender\": \"F\",\n      \"_rev\": \"v1\",\n      \"identifiers\": {\n        \"Patient_Identifier\": \"10005090\"\n      },\n      \"birthdate\": \"1960-01-28T00:00:00.000+06:00\",\n      \"dateCreated\": \"2018-09-13T11:48:57.930+06:00\",\n      \"isSendToOpenMRS\": \"yes\",\n      \"clientDatabaseVersion\": 1,\n      \"lastName\": \"-\",\n      \"birthdateApprox\": false,\n      \"attributes\": {\n        \"phoneNumber\": \"01716435644\",\n        \"householdCode\": \"128\",\n        \"MaritalStatus\": \"Divorced\"\n      },\n      \"_id\": \"13b869ee4-a045-49eb-8d35-129a814ruq\",\n      \"type\": \"Client\",\n      \"serverVersion\": 1536843396000\n    }\n  ],\n  \"events\": [\n    {\n      \"isSendToOpenMRS\": \"yes\",\n      \"eventType\": \"Household Registration\",\n      \"_rev\": \"v2\",\n      \"entityType\": \"ec_household\",\n      \"teamId\": \"1e815e13-f6ca-42ef-97c8-83394c201a47\",\n      \"duration\": 0,\n      \"version\": 1536843396000,\n      \"formSubmissionId\": \"26a88670-e073-4834-962e-2e91ef9b2c19\",\n      \"clientDatabaseVersion\": 1,\n      \"type\": \"Event\",\n      \"serverVersion\": 1536843396000,\n      \"dateCreated\": \"2018-09-13T15:27:50.529+06:00\",\n      \"baseEntityId\": \"e4595f35-2cc5-9084-1518-1a36866a655e\",\n      \"locationId\": \"76d07f22-6c01-4afc-9d38-5c8d5ee74c05\",\n      \"eventDate\": \"2018-09-13T21:29:10.078+06:00\",\n      \"_id\": \"b89e03d4-9516-4a0b-b105-19426c015fa3\",\n      \"identifiers\": {},\n      \"providerId\": \"ftp\",\n      \"team\": \"Dev\",\n      \"clientApplicationVersion\": 1,\n      \"obs\": [\n        {\n          \"formSubmissionField\": \"HIE_FACILITIES\",\n          \"fieldDataType\": \"text\",\n          \"parentCode\": \"\",\n          \"values\": [\n            \"[\\\"BANGLADESH\\\",\\\"DHAKA\\\",\\\"KISHOREGONJ\\\",\\\"MITHAMAIN\\\",\\\"BAIRATI\\\",\\\"BAIRATI: WARD 3\\\"]\"\n          ],\n          \"fieldType\": \"formsubmissionField\",\n          \"humanReadableValues\": [],\n          \"fieldCode\": \"HIE_FACILITIES\"\n        },\n        {\n          \"formSubmissionField\": \"Date_Of_Reg\",\n          \"fieldDataType\": \"text\",\n          \"parentCode\": \"\",\n          \"values\": [\n            \"13-09-2018\"\n          ],\n          \"fieldType\": \"formsubmissionField\",\n          \"humanReadableValues\": [],\n          \"fieldCode\": \"Date_Of_Reg\"\n        }\n      ]\n    }\n  ]\n}";
		
		JSONObject jo = new JSONObject();
		JSONObject joarrayelement = new JSONObject();
		joarrayelement.put("firstName", "NewEntity");
		joarrayelement.put("baseEntityId", "e4595f35-2cc5-9084-1518-1a36866a655e");
		JSONArray ja = new JSONArray();
		ja.put(joarrayelement);
		jo.put("clients", ja);
		
		System.out.println("first char: " +jo.toString().charAt(0));
		
		System.out.println("jo object: " + jo.toString());
		HttpUtil.post(getURL() + "/" + URL, payload, jo.toString(), OPENSRP_USER, OPENSRP_PWD).body();
	}

	@Override
	public JSONObject update(String payload, JSONObject jsonObject,
			String id, String URL) throws JSONException {
		/*return new JSONObject(HttpUtil.post(getURL() + "/" + URL + "/" + id, payload, jsonObject.toString(),
			    OPENSRP_USER, OPENSRP_PWD).body());*/
		return null;
	}

	@Override
	public JSONObject get(String payload, String uuid, String URL)
			throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public JSONObject getByQuery(String payload, String URL)
			throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public JSONObject delete(String payload, String uuid, String URL)
			throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}

}
