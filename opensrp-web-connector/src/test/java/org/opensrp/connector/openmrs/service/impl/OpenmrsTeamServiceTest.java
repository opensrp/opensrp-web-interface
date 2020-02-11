package org.opensrp.connector.openmrs.service.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
@Ignore
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "classpath:test-applicationContext.xml" })
public class OpenmrsTeamServiceTest {
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIService;
	
	private static final String ROLE_URL = "ws/rest/v1/team/teammember";
	
	@Value("#{opensrp['openmrs.url']}")
	protected String OPENMRS_BASE_URL;
	
	@Before
	public void setup() throws IOException {
		
	}
	

	@Test
	public void createUpdateGetAndDeleteRole() throws JSONException {
		String name = "Test";
		String payload = "";
		List<String> list = new ArrayList<String>();
		list.add("4c8cb044-7b15-40b7-8ca2-6eceaa6c4e9a");
		
		JSONObject roleObject = new JSONObject();
		roleObject.put("person", "94dd1f74-c69a-40b6-a31c-f55b5215bfea");
		roleObject.put("identifier", "ID345");
		roleObject.put("team", "bfad0e3f-9f96-4a3b-960d-9e1b5fbe8f4a");
		roleObject.put("isDataProvider", "true");
		roleObject.put("locations", list);
		/**
		 * { "person": "29d5d7a6-0b68-40b2-86c2-786aa56e21a4",
		 * "locations":["4c8cb044-7b15-40b7-8ca2-6eceaa6c4e9a"], "identifier": "43267", "team":
		 * "Test", "isDataProvider": "true" }
*/		/**
		 * { "teamName": "Rty", "location": "4c8cb044-7b15-40b7-8ca2-6eceaa6c4e9a" } { "name":
		 * "ROlee", "identifier": "233" }
		 */
		
		JSONObject returnObject = openMRSAPIService.add(payload, roleObject, ROLE_URL);
		System.err.println("returnObject:" + returnObject);
		String uuid = (String) returnObject.get("uuid");
		/*	Assert.assertEquals(returnObject.get("name"), name);
		JSONObject getRoleObject = openMRSAPIService.get("v=full", uuid, ROLE_URL);
		
		JSONObject roleObjectForUpdate = new JSONObject();
		roleObjectForUpdate.put("description", "Test description Updated");
		JSONObject returnObjectOfUpdated = openMRSAPIService.update(payload, roleObjectForUpdate, uuid, ROLE_URL);
		Assert.assertEquals((String) returnObjectOfUpdated.get("uuid"), uuid);*/
		
		JSONObject returnObjectOfDeleted = openMRSAPIService.delete(payload, uuid, ROLE_URL);
		System.err.println(returnObjectOfDeleted);
		//Assert.assertTrue(returnObjectOfDeleted.getString("success"), true);
	}
}
