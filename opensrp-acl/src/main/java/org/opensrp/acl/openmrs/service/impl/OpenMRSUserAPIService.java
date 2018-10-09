/**
 * @author proshanto (proshanto123@gmail.com)
 * 
 */
package org.opensrp.acl.openmrs.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.common.util.RoleUtil;
import org.opensrp.connector.openmrs.service.APIServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSUserAPIService implements OpenMRSConnector<Object> {
	
	private static final Logger logger = Logger.getLogger(OpenMRSUserAPIService.class);
	
	final String PERSON_URL = "ws/rest/v1/person";
	
	final String USER_URL = "ws/rest/v1/user";
	
	final String PROVIDER_URL = "ws/rest/v1/provider";
	
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
	
	@Autowired
	private APIServiceFactory apiServiceFactory;
	
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
	
	/***
	 * Limitation if you choose any PRovider and CHCP (means all openmrs role then no update role is
	 * applied in openmrs or no reset support (retain current role) )
	 */
	public JSONObject generateUserJsonObject(User user, boolean isUpdate, JSONObject userOb) throws JSONException {
		JSONArray roleArray = new JSONArray();
		JSONObject userJsonObject = new JSONObject();
		if (!isUpdate) {
			/***
			 * when new user created here come from two point 1. new user create 2. update user a
			 * openmrs role such as Provider / CHCP
			 */
			Set<Role> roles = user.getRoles();
			for (Role role : roles) {
				JSONObject roleObject = new JSONObject();
				if (RoleUtil.containsRole(role.getName())) {
					roleObject.put("role", role.getName());
					roleArray.put(roleObject);
				}
			}
			userJsonObject.put(rolesKey, roleArray);
			userJsonObject.put(passwordKey, user.getPassword());
		} else {
			/**
			 * when update user information..
			 */
			List<String> list = new ArrayList<String>();
			if (userOb != null) {
				JSONArray userRoles = userOb.getJSONArray("roles");
				for (int i = 0; i < userRoles.length(); i++) {
					JSONObject roleOb = (JSONObject) userRoles.get(i);
					list.add(roleOb.getString("name"));
				}
				Set<Role> roles = user.getRoles();
				for (Role role : roles) {
					JSONObject roleObject = new JSONObject();
					if (RoleUtil.containsRole(role.getName()) && !list.contains(role.getName())) {
						roleObject.put("role", role.getName());
						roleArray.put(roleObject);
					}
				}
				if (roleArray.length() != 0) {
					/**
					 * when update passowrd..
					 */
					userJsonObject.put(rolesKey, roleArray);
				}
			} else {
				userJsonObject.put(passwordKey, user.getPassword());
			}
		}
		userJsonObject.put(usernameKey, user.getUsername());
		userJsonObject.put(personKey, user.getPersonUUid());
		
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
		JSONObject createdPerson = apiServiceFactory.getApiService("openmrs").add(PAYLOAD, generatePersonObject(user),
		    PERSON_URL);
		
		if (createdPerson.has("uuid")) {
			user.setPersonUUid(createdPerson.getString("uuid"));
			JSONObject createdUser = apiServiceFactory.getApiService("openmrs").add(PAYLOAD,
			    generateUserJsonObject(user, isUpdate, null), USER_URL);
			if (createdUser.has("uuid")) {
				userUuid = (String) createdUser.get("uuid");
				user.setUuid(userUuid);
				/**
				 * make user as a provider
				 */
				apiServiceFactory.getApiService("openmrs").add(PAYLOAD, makeProviderObject(user), PROVIDER_URL);
			}
		} else {
			// need to handle exception....
		}
		
		return user;
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
}
