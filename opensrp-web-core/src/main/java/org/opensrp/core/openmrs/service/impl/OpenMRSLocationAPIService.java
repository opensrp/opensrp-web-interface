/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.openmrs.service.impl;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.util.OpensrpProperties;
import org.opensrp.connector.openmrs.service.APIServiceFactory;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.core.entity.Location;
import org.opensrp.core.openmrs.service.OpenMRSConnector;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSLocationAPIService extends OpensrpProperties implements OpenMRSConnector<Object> {
	
	final String LOCATION_URL = "ws/rest/v1/location";
	
	public final static String nameKey = "name";
	
	public final static String tagsKey = "tags";
	
	public final static String parentLocationKey = "parentLocation";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private APIServiceFactory apiServiceFactory;
	
	@Override
	public Location add(Object locationOb) throws JSONException {
		Location location = (Location) locationOb;
		String locationUuid = "";
		String query = "";
		JSONArray existinglocation = new JSONArray();
		query = "q=" + location.getName();
		existinglocation = getByQuery(query);
		if (existinglocation.length() == 0) {
			JSONObject createdLocation = apiServiceFactory.getApiService("openmrs").add(PAYLOAD,
			    makeLocationObject(location), LOCATION_URL);
			if (createdLocation.has("uuid")) {
				locationUuid = (String) createdLocation.get("uuid");
				location.setUuid(locationUuid);
			} else {
				//TODO
			}
		} else {
			JSONObject locationObject = new JSONObject();
			locationObject = (JSONObject) existinglocation.get(0);
			locationUuid = (String) locationObject.get("uuid");
			update(location, locationUuid, null);
			location.setUuid(locationUuid);
		}
		return location;
	}

	@Override
	public HttpResponse post(Object jsonObject) {
		return null;
	}

	@Override
	public String update(Object locationOb, String uuid, JSONObject jsonObject) throws JSONException {
		Location location = (Location) locationOb;
		String locationUuid = "";
		JSONObject updatedLocation = apiServiceFactory.getApiService("openmrs").update(PAYLOAD,
		    makeLocationObject(location), uuid, LOCATION_URL);
		if (updatedLocation.has("uuid")) {
			locationUuid = (String) updatedLocation.get("uuid");
		} else {
			//TODO
		}
		return locationUuid;
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
	
	/**
	 * loginLocationId and visitLocationId gets from opensrp.properties file
	 **/
	public JSONObject makeLocationObject(Location location) throws JSONException {
		JSONObject locationObject = new JSONObject();
		JSONArray tagsArray = new JSONArray();
		String parentLocationUuid = "";
		
		if (location.getParentLocation() != null) {
			parentLocationUuid = location.getParentLocation().getUuid();
		} else {
			parentLocationUuid = "";
		}
		
		if (location.getLocationTag() != null) {
			tagsArray.put(location.getLocationTag().getUuid());
		}
		if (location.getLocationTag().getName().equalsIgnoreCase("Ward")) {
			tagsArray.put(loginLocationId);
			tagsArray.put(visitLocationId);
		}
		/*if (location.isVisitLocation()) {
			
			tagsArray.put(visitLocationId);
		}*/
		if (tagsArray.length() != 0) {
			locationObject.put(tagsKey, tagsArray);
		}
		locationObject.put(nameKey, location.getName());
		locationObject.put(parentLocationKey, parentLocationUuid);
		
		return locationObject;
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		JSONObject location = apiServiceFactory.getApiService("openmrs").getByQuery(query, LOCATION_URL);
		JSONArray locationArray = new JSONArray();
		locationArray = (JSONArray) location.get("results");
		return locationArray;
	}
}
