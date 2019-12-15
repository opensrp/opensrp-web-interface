/**
 * @author proshanto (proshanto123@gmail.com)
 * 
 */
package org.opensrp.core.openmrs.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ChangePasswordDTO;
import org.opensrp.connector.openmrs.service.APIServiceFactory;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.core.entity.User;
import org.opensrp.core.openmrs.service.OpenMRSConnector;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSUserAPIService implements OpenMRSConnector<Object> {
	
	private static final Logger logger = Logger.getLogger(OpenMRSUserAPIService.class);
	
	final String PERSON_URL = "ws/rest/v1/person";
	
	final String USER_URL = "ws/rest/v1/user";
	
	final String ROLE_URL = "ws/rest/v1/role";
	
	final String PROVIDER_URL = "ws/rest/v1/provider";
	
	final String CHANGE_PASSWORD = "ws/rest/v1/manage-accounts/change-password";
	
	final static String ageKey = "age";
	
	final static String genderKey = "gender";
	
	final static String birthdateKey = "birthdate";
	
	final static String namesKey = "names";
	
	private static String PAYLOAD = "";
	
	public String female = "M";
	
	final static String usernameKey = "username";
	
	final static String passwordKey = "password";
	
	public final static String personKey = "person";
	
	public final static String identifierKey = "identifier";
	
	String rolesKey = "roles";
	
	JSONObject person = new JSONObject();
	
	@Value("#{opensrp['openmrs.bahmni.uid']}")
	protected String OPENMRS_BAHMNI_UID;
	
	@Autowired
	private APIServiceFactory apiServiceFactory;
	
	public JSONObject generatePersonObject(User user) throws JSONException {
		JSONArray personArray = new JSONArray();
		JSONObject personObject = new JSONObject();
		personObject.put("givenName", user.getFirstName());
		personObject.put("middleName", "");
		if (!StringUtils.isBlank(user.getLastName())) {
			personObject.put("familyName", user.getLastName());
		} else {
			personObject.put("familyName", ".");
		}
		personArray.put(personObject);
		
		person.put(genderKey, female);
		person.put(birthdateKey, "2017-01-01");
		person.put(ageKey, "32");
		person.put(namesKey, personArray);
		return person;
	}
	
	/***
	 * Limitation if you choose any PRovider and CHCP (means all openmrs role then no update role is
	 * applied in openmrs or no reset support (retain current role) )
	 */
	public JSONObject generateUserJsonObject(User user, boolean isUpdate, JSONObject userOb) throws JSONException {
		JSONArray roleArray = new JSONArray();
		JSONObject userJsonObject = new JSONObject();
		JSONObject roleObject = new JSONObject();
		roleObject.put("role", "Provider");
		roleArray.put(roleObject);
		
		if (!isUpdate) {
			userJsonObject.put(passwordKey, user.getPassword());
			userJsonObject.put(rolesKey, roleArray);
		}
		
		userJsonObject.put(usernameKey, user.getUsername());
		userJsonObject.put(personKey, generatePersonObject(user));
		return userJsonObject;
	}
	
	private JSONObject makeProviderObject(User user) throws JSONException {
		JSONObject provider = new JSONObject();
		provider.put(personKey, user.getPersonUUid());
		provider.put(identifierKey, user.getUsername());
		return provider;
	}
	
	@Override
	public User add(Object userOb) throws JSONException {
		User user = (User) userOb;
		String userUuid = "";
		boolean isUpdate = false;
		
		JSONObject createdUser = apiServiceFactory.getApiService("openmrs").add(PAYLOAD,
		    generateUserJsonObject(user, isUpdate, null), USER_URL);
		if (createdUser.has("person")) {
			JSONObject person = createdUser.getJSONObject("person");
			user.setPersonUUid(person.getString("uuid"));
		}
		if (createdUser.has("uuid")) {
			userUuid = (String) createdUser.get("uuid");
			user.setUuid(userUuid);
			apiServiceFactory.getApiService("openmrs").add(PAYLOAD, makeProviderObject(user), PROVIDER_URL);
			
		} else {
			
		}
		
		return user;
	}
	
	@Override
	public HttpResponse post(Object jsonObject) throws JSONException {
		ChangePasswordDTO dto = (ChangePasswordDTO) jsonObject;
		JSONObject changePasswordBody = new JSONObject();
		changePasswordBody.put("userName", dto.getUsername());
		changePasswordBody.put("password", dto.getPassword());
		HttpResponse response = apiServiceFactory.getApiService("openmrs")
		        .post(PAYLOAD, changePasswordBody, CHANGE_PASSWORD);
		return response;
	}
	
	@Override
	public String update(Object userOb, String uuid, JSONObject jsonOb) throws JSONException {
		User user = (User) userOb;
		String userUuid = "";
		boolean isUpdate = true;
		JSONObject updatedUser = apiServiceFactory.getApiService("openmrs").update(PAYLOAD,
		    generateUserJsonObject(user, isUpdate, jsonOb), uuid, USER_URL);
		if (updatedUser.has("uuid")) {
			userUuid = (String) updatedUser.get("uuid");
		} else {
			// need to handle exception....
		}
		return userUuid;
	}
	
	@Override
	public String get(String uuid) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public String delete(String uuid) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		JSONObject user = apiServiceFactory.getApiService("openmrs").getByQuery(query, USER_URL);
		JSONArray userArray = new JSONArray();
		userArray = (JSONArray) user.get("results");
		return userArray;
	}
	
	public void roleUpdate() {
		
		try {
			JSONObject user = apiServiceFactory.getApiService("openmrs").get("", "", ROLE_URL);
			JSONArray userArray = new JSONArray();
			userArray = (JSONArray) user.get("results");
			String name = "";
			String roleUid = "";
			String bahmniID = "";
			for (int i = 0; i < userArray.length(); i++) {
				JSONObject jsonOb = (JSONObject) userArray.get(i);
				name = (String) jsonOb.get("display");
				if (name.equalsIgnoreCase("CHCP")) {
					roleUid = (String) jsonOb.get("uuid");
					
				}
				if (name.equalsIgnoreCase("Bahmni-App")) {
					bahmniID = (String) jsonOb.get("uuid");
					;
				}
			}
			List<String> list = new ArrayList<String>();
			list.add(bahmniID);
			JSONObject roleOb = new JSONObject();
			roleOb.put("inheritedRoles", list);
			JSONObject updatedUser = apiServiceFactory.getApiService("openmrs").update(PAYLOAD, roleOb, roleUid, ROLE_URL);
			
		}
		catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
