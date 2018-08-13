/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.openmrs.service.impl;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSLocationAPIService implements OpenMRSConnector<Location> {
	
	final String LOCATION_URL = "ws/rest/v1/location";
	
	public final static String nameKey = "name";
	
	public final static String tagsKey = "tags";
	
	public final static String parentLocationKey = "parentLocation";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	@Override
	public Location add(Location location) throws JSONException {
		String locationUuid = "";
		String query = "";
		JSONArray existinglocation = new JSONArray();
		query = "q=" + location.getName();
		existinglocation = getByQuery(query);
		if (existinglocation.length() == 0) {
			JSONObject createdLocation = openMRSAPIServiceImpl.add(PAYLOAD, makeLocationObject(location), LOCATION_URL);
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
			update(location, locationUuid);
			location.setUuid(locationUuid);
		}
		return location;
	}
	
	@Override
	public String update(Location location, String uuid) throws JSONException {
		String locationUuid = "";
		JSONObject updatedLocation = openMRSAPIServiceImpl.update(PAYLOAD, makeLocationObject(location), uuid, LOCATION_URL);
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
	
	public JSONObject makeLocationObject(Location location) throws JSONException {
		JSONObject locationObject = new JSONObject();
		JSONArray tagsArray = new JSONArray();
		JSONObject tagsObject = new JSONObject();
		String parentLocationUuid = "";
		
		if (location.getParentLocation() != null) {
			parentLocationUuid = location.getParentLocation().getUuid();
		} else {
			parentLocationUuid = "";
		}
		
		if (location.getLocationTag() != null) {
			tagsObject.put("tag", location.getLocationTag().getName());
			tagsArray.put(tagsObject);
			locationObject.put(tagsKey, tagsArray);
		}
		
		locationObject.put(nameKey, location.getName());
		locationObject.put(parentLocationKey, parentLocationUuid);
		
		return locationObject;
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		JSONObject location = openMRSAPIServiceImpl.getByQuery(query, LOCATION_URL);
		JSONArray locationArray = new JSONArray();
		locationArray = (JSONArray) location.get("results");
		return locationArray;
	}
}
