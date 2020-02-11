package org.opensrp.connector.openmrs.service.impl;

import java.io.IOException;

import org.json.JSONArray;
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
public class OpenmrsUserServiceTest {
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIService;
	
	private static final String ROLE_URL = "ws/rest/v1/role";
	
	@Value("#{opensrp['openmrs.url']}")
	protected String OPENMRS_BASE_URL;
	
	final String PERSON_URL = "ws/rest/v1/person";
	
	final String USER_URL = "ws/rest/v1/user";
	
	final String PERSON_ATTRIBUTE_TYPE = "ws/rest/v1/personattributetype";
	
	final String ENCOUTER_TYPE_URL = "ws/rest/v1/encountertype";
	
	final String RELATIONSHIP_TYPE = "/ws/rest/v1/relationshiptype/";
	
	final String LOCATION = "ws/rest/v1/location";
	
	private static final String PROVIDER_URL = "ws/rest/v1/provider";
	
	JSONObject person = new JSONObject();
	
	JSONObject personAttributeType = new JSONObject();
	
	final static String ageKey = "age";
	
	final static String genderKey = "gender";
	
	final static String birthdateKey = "birthdate";
	
	final static String namesKey = "names";
	
	final static String purgePartUrl = "?purge=true";
	
	public final static String nameKey = "name";
	
	final static String descriptionkey = "description";
	
	final static String usernameKey = "username";
	
	final static String passwordKey = "password";
	
	public final static String personKey = "person";
	
	public final static String formatKey = "format";
	
	public final static String typeString = "java.lang.String";
	
	public String aIsToBKey = "aIsToB";
	
	public String bIsToAKey = "bIsToA";
	
	public String description = "description";
	
	public String uuidKey = "uuid";
	
	public String displayKey = "display";
	
	public String encountersKey = "encounters";
	
	public String relationshipsKey = "relationships";
	
	public String encounterTypeKey = "encounterType";
	
	public String identifierKey = "identifier";
	
	public String relationKey = "relation";
	
	public String childrenKey = "children";
	
	public String labelKey = "label";
	
	public String nodeKey = "node";
	
	public String OPENMRS_UUIDKey = "OPENMRS_UUID";
	
	public String parentLocationKey = "parentLocation";
	
	public String locationsHierarchyKey = "locationsHierarchy";
	
	public String givenName = "givenName";
	
	public String female = "F";
	
	String fn = "testPersov";
	
	String mn = "deshd";
	
	String ln = "asia";
	
	String userName = "testPersov";
	
	String password = "newPerson@34";
	
	String rolesKey = "roles";
	
	String Authenticated = "Authenticated";
	
	String Provider = "Provider";
	
	@Before
	public void setup() throws IOException {
		
	}
	
	public JSONObject createPerson(String fn, String mn, String ln) throws JSONException {
		
		return openMRSAPIService.add("", makePersonObject(fn, mn, ln), PERSON_URL);
	}
	
	public JSONObject makePersonObject(String fn, String mn, String ln) throws JSONException {
		JSONArray personArray = new JSONArray();
		JSONObject personObject = new JSONObject();
		personObject.put("givenName", fn);
		personObject.put("middleName", mn);
		personObject.put("familyName", ln);
		personArray.put(personObject);
		
		person.put(genderKey, female);
		person.put(birthdateKey, "2017-01-01");
		person.put(ageKey, "32");
		person.put(namesKey, personArray);
		return person;
	}
	
	public JSONObject makeUserObject(String userName, String password) throws JSONException {
		
		JSONArray roleArray = new JSONArray();
		JSONObject roleObject = new JSONObject();
		//roleObject.put("role", Authenticated);
		roleObject.put("role", Provider);
		roleArray.put(roleObject);
		
		JSONObject user = new JSONObject();
		user.put(usernameKey, userName);
		user.put(passwordKey, password);
		user.put(rolesKey, roleArray);
		
		user.put(personKey, makePersonObject(fn, mn, ln));
		return user;
	}
	
	public JSONObject updatePerson(String fn, String mn, String ln, String uuid) throws JSONException {
		return openMRSAPIService.update("", makePersonObject(fn, mn, ln), uuid, PERSON_URL);
	}
	
	public String createUpdateAndGetPerson() throws JSONException {
		/**
		 * create person information
		 */
		
		JSONObject returnPerson = createPerson(fn, mn, ln);
		
		String personUuid = (String) returnPerson.get("uuid");
		String crratedPersonName = (String) returnPerson.get("display");
		Assert.assertEquals(fn + " " + mn + " " + ln, crratedPersonName);
		/**
		 * update person information
		 */
		fn = "banglaUpdaetdd";
		JSONObject returnUpdatedPerson = updatePerson(fn, mn, ln, personUuid);
		String updatedPersonName = (String) returnUpdatedPerson.get("display");
		Assert.assertEquals(fn + " " + mn + " " + ln, updatedPersonName);
		/**
		 * get person information
		 */
		JSONObject getPersonObject = openMRSAPIService.get("v=full", personUuid, PERSON_URL);
		System.err.println("getPersonObject:" + getPersonObject);
		String getPersonObjectUuid = (String) getPersonObject.get("uuid");
		Assert.assertEquals(personUuid, getPersonObjectUuid);
		
		return personUuid;
	}
	
	public JSONObject createUser(String userName, String password) throws JSONException {
		return openMRSAPIService.add("", makeUserObject(userName, password), USER_URL);
		
	}
	
	public JSONObject updateUser(String uuid) throws JSONException {
		password = "Abs123";
		//don't update role 
		return openMRSAPIService.update("", makeUserObject(userName, password), uuid, USER_URL);
	}
	
	public JSONObject makeProviderObject(String personUuid, String indetifier) throws JSONException {
		JSONObject provider = new JSONObject();
		provider.put("person", personUuid);
		provider.put("identifier", indetifier);
		return provider;
		
	}
	
	public JSONObject createProvider(String personUuid, String indetifier) throws JSONException {
		return openMRSAPIService.add("", makeProviderObject(personUuid, indetifier), PROVIDER_URL);
		
	}
	
	public JSONObject updateProvider(String personUuid, String indetifier, String uuid) throws JSONException {
		
		return openMRSAPIService.update("", makeProviderObject(personUuid, indetifier), uuid, PROVIDER_URL);
		
	}
	
	public String createUpdateGetAndDeleteUser() throws JSONException {
		String personUuid = createUpdateAndGetPerson();
		/**
		 * create user information
		 */
		
		JSONObject returnUser = createUser(userName, password);
		JSONObject person = (JSONObject) returnUser.get("person");
		System.err.println("uuID" + person.get("uuid"));
		String userUuid = (String) returnUser.get("uuid");
		String returnUserName = (String) returnUser.get("username");
		Assert.assertEquals(userName, returnUserName);
		
		/**
		 * get user information
		 */
		
		JSONObject getUserObject = openMRSAPIService.get("v=full", userUuid, USER_URL);
		
		String getUserObjectUuid = (String) getUserObject.get("uuid");
		Assert.assertEquals(userUuid, getUserObjectUuid);
		
		/**
		 * update user information
		 */
		JSONObject returnUpdatedUser = updateUser(getUserObjectUuid);
		
		/**
		 * delete person information
		 */
		return userUuid;
		
	}
	@Ignore
	@Test
	public void createUpdateGetAndDeleteProvider() throws JSONException {
		String personUuid = createUpdateAndGetPerson();
		String userUuid = createUpdateGetAndDeleteUser();
		String identifier = userName;
		JSONObject createdProvider = createProvider(personUuid, identifier);
		String providerIdentifier = (String) createdProvider.get("identifier");
		Assert.assertEquals(userName, providerIdentifier);

		String providerUuid = (String) createdProvider.get("uuid");
		String updatedIdentifier = "4454646";
		JSONObject updatedProvider = updateProvider(personUuid, updatedIdentifier, providerUuid);
		String getUpdatedProviderIdentifier = (String) updatedProvider.get("identifier");
		Assert.assertEquals(updatedIdentifier, getUpdatedProviderIdentifier);

		JSONObject getProviderObject = openMRSAPIService.get("v=full", providerUuid, PROVIDER_URL);
		String gePproviderUuid = (String) getProviderObject.get("uuid");
		Assert.assertEquals(providerUuid, gePproviderUuid);

		openMRSAPIService.delete("", personUuid, PROVIDER_URL);

		openMRSAPIService.delete("", "add842ef-ffa5-4cb2-bb85-e7f575615ab0", PERSON_URL);
		openMRSAPIService.delete("", userUuid, USER_URL);
	}
	
	@Ignore
	@Test
	public void getUserByNane() throws JSONException {
		JSONObject getProviderObject = openMRSAPIService.getByQuery("v=full&username=admin", USER_URL);
		JSONArray arr = new JSONArray();
		arr = (JSONArray) getProviderObject.get("results");
		System.err.println("" + arr.length());
		JSONObject ob = new JSONObject();
		ob = (JSONObject) arr.get(0);
		JSONObject person = new JSONObject();
		person = (JSONObject) ob.get("person");
		
		//System.err.println("dddd:" + ob);
	}
}
