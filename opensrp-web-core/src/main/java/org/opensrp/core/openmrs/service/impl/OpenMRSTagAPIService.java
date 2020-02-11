/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.openmrs.service.impl;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.APIServiceFactory;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.core.entity.LocationTag;
import org.opensrp.core.openmrs.service.OpenMRSConnector;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSTagAPIService implements OpenMRSConnector<Object> {
	
	final String LOCATION_TAG_URL = "ws/rest/v1/locationtag";
	
	public final static String nameKey = "name";
	
	public final static String tagsKey = "tags";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private APIServiceFactory apiServiceFactory;
	
	@Override
	public LocationTag add(Object tagOb) throws JSONException {
		LocationTag tag = (LocationTag) tagOb;
		String tagUuid = "";
		JSONObject createdTag = apiServiceFactory.getApiService("openmrs").add(PAYLOAD, makeTagObject(tag.getName()),
		    LOCATION_TAG_URL);
		if (createdTag.has("uuid")) {
			tagUuid = (String) createdTag.get("uuid");
			tag.setUuid(tagUuid);
		} else {
			
		}
		return tag;
	}

	@Override
	public HttpResponse post(Object jsonObject) {
		return null;
	}

	@Override
	public String update(Object tagOb, String uuid, JSONObject jsonObject) throws JSONException {
		LocationTag tag = (LocationTag) tagOb;
		String tagUuid = "";
		JSONObject updatedTag = apiServiceFactory.getApiService("openmrs").update(PAYLOAD, makeTagObject(tag.getName()),
		    uuid, LOCATION_TAG_URL);
		if (updatedTag.has("uuid")) {
			tagUuid = (String) updatedTag.get("uuid");
		}
		return tagUuid;
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
	
	public JSONObject makeTagObject(String name) throws JSONException {
		JSONObject tag = new JSONObject();
		tag.put(nameKey, name);
		return tag;
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
}
