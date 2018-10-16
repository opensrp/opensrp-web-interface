package org.opensrp.connector.openmrs.service;

import org.json.JSONException;
import org.json.JSONObject;

public interface APIService {
	
	public JSONObject add(String payload, JSONObject jsonObject, String URL) throws JSONException;
	
	public JSONObject update(String payload, JSONObject jsonObject, String uuid, String URL) throws JSONException;
	
	public JSONObject get(String payload, String uuid, String URL) throws JSONException;
	
	public JSONObject getByQuery(String payload, String URL) throws JSONException;
	
	public JSONObject delete(String payload, String uuid, String URL) throws JSONException;
	
}
