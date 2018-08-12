/**
 * @author proshanto (proshanto123@gmail.com)
 * 
 */
package org.opensrp.acl.openmrs.service.impl;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.common.util.DefaultRole;
import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSUserAPIService implements OpenMRSConnector<User> {
	
	private static final Logger logger = Logger.getLogger(OpenMRSUserAPIService.class);
	
	final String PERSON_URL = "ws/rest/v1/person";
	
	final String USER_URL = "ws/rest/v1/user";
	
	final static String ageKey = "age";
	
	final static String genderKey = "gender";
	
	final static String birthdateKey = "birthdate";
	
	final static String namesKey = "names";
	
	private static String PAYLOAD = "";
	
	public String female = "M";
	
	final static String usernameKey = "username";
	
	final static String passwordKey = "password";
	
	public final static String personKey = "person";
	
	String rolesKey = "roles";
	
	JSONObject person = new JSONObject();
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	public JSONObject generatePersonObject(User user) throws JSONException {
		JSONArray personArray = new JSONArray();
		JSONObject personObject = new JSONObject();
		personObject.put("givenName", user.getFirstName());
		personObject.put("middleName", "");
		personObject.put("familyName", user.getLastName());
		personArray.put(personObject);
		
		person.put(genderKey, female);
		person.put(birthdateKey, "2017-01-01");
		person.put(ageKey, "32");
		person.put(namesKey, personArray);
		return person;
	}
	
	public JSONObject generateUserJsonObject(User user, boolean isUpdate) throws JSONException {
		JSONArray roleArray = new JSONArray();
		JSONObject roleObject = new JSONObject();
		JSONObject userJsonObject = new JSONObject();
		if (!isUpdate) {
			roleObject.put("role", DefaultRole.Provider);
			userJsonObject.put(rolesKey, roleArray);
		}
		roleArray.put(roleObject);
		
		userJsonObject.put(usernameKey, user.getUsername());
		userJsonObject.put(passwordKey, user.getPassword());
		
		userJsonObject.put(personKey, generatePersonObject(user));
		return userJsonObject;
		
	}
	
	@Override
	public User add(User user) throws JSONException {
		String userUuid = "";
		boolean isUpdate = false;
		JSONObject createdPerson = openMRSAPIServiceImpl.add(PAYLOAD, generatePersonObject(user), PERSON_URL);
		logger.info("createdPerson::" + createdPerson);
		if (createdPerson.has("uuid")) {
			
			JSONObject createdUser = openMRSAPIServiceImpl.add(PAYLOAD, generateUserJsonObject(user, isUpdate), USER_URL);
			
			if (createdUser.has("uuid")) {
				JSONObject person = (JSONObject) createdUser.get("person");
				if (person.has("uuid")) {
					user.setPersonUUid(person.getString("uuid"));
				}
				logger.info("createdUole:" + createdUser);
				
				userUuid = (String) createdUser.get("uuid");
				user.setUuid(userUuid);
				personDelete(createdPerson.getString("uuid"));
			}
		} else {
			// need to handle exception....
		}
		
		return user;
	}
	
	@Override
	public String update(User user, String uuid) throws JSONException {
		String userUuid = "";
		boolean isUpdate = true;
		JSONObject updatedRole = openMRSAPIServiceImpl.update(PAYLOAD, generateUserJsonObject(user, isUpdate), uuid,
		    USER_URL);
		logger.info("updatedUser:" + updatedRole);
		if (updatedRole.has("uuid")) {
			userUuid = (String) updatedRole.get("uuid");
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
	
	private JSONObject personDelete(String uuid) throws JSONException {
		return openMRSAPIServiceImpl.delete(PAYLOAD, uuid, PERSON_URL);
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		
		JSONObject user = openMRSAPIServiceImpl.getByQuery(query, USER_URL);
		JSONArray userArray = new JSONArray();
		userArray = (JSONArray) user.get("results");
		return userArray;
	}
}
