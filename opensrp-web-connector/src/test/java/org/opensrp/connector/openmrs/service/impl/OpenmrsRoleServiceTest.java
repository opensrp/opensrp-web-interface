package org.opensrp.connector.openmrs.service.impl;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
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
public class OpenmrsRoleServiceTest {
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIService;
	
	private static final String ROLE_URL = "ws/rest/v1/role";
	
	@Value("#{opensrp['openmrs.url']}")
	protected String OPENMRS_BASE_URL;
	
	@Before
	public void setup() throws IOException {
		
	}

	@Ignore
	@Test
	public void createUpdateGetAndDeleteRole() throws JSONException {
		String name = "Test";
		JSONObject roleObject = new JSONObject();
		roleObject.put("name", name);
		String payload = "";
		roleObject.put("description", "Test description");
		JSONObject returnObject = openMRSAPIService.add(payload, roleObject, ROLE_URL);
		String uuid = (String) returnObject.get("uuid");
		Assert.assertEquals(returnObject.get("name"), name);
		JSONObject getRoleObject = openMRSAPIService.get("v=full", uuid, ROLE_URL);
		
		JSONObject roleObjectForUpdate = new JSONObject();
		roleObjectForUpdate.put("description", "Test description Updated");
		JSONObject returnObjectOfUpdated = openMRSAPIService.update(payload, roleObjectForUpdate, uuid, ROLE_URL);
		Assert.assertEquals((String) returnObjectOfUpdated.get("uuid"), uuid);
		
		JSONObject returnObjectOfDeleted = openMRSAPIService.delete(payload, uuid, ROLE_URL);
		Assert.assertTrue(returnObjectOfDeleted.getString("success"), true);
	}
	
}
