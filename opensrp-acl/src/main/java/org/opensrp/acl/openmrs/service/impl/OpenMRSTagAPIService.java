/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.openmrs.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.LocationTag;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSTagAPIService implements OpenMRSConnector<LocationTag> {
	
	final String LOCATION_TAG_URL = "ws/rest/v1/locationtag";
	
	public final static String nameKey = "name";
	
	public final static String tagsKey = "tags";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	@Override
	public LocationTag add(LocationTag tag) throws JSONException {
		String tagUuid = "";
		JSONObject createdTag = openMRSAPIServiceImpl.add(PAYLOAD, makeTagObject(tag.getName()), LOCATION_TAG_URL);
		if (createdTag.has("uuid")) {
			tagUuid = (String) createdTag.get("uuid");
			tag.setUuid(tagUuid);
		} else {
			
		}
		return tag;
	}
	
	@Override
	public String update(LocationTag tag, String uuid) throws JSONException {
		String tagUuid = "";
		JSONObject updatedTag = openMRSAPIServiceImpl.update(PAYLOAD, makeTagObject(tag.getName()), uuid, LOCATION_TAG_URL);
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
	
}
