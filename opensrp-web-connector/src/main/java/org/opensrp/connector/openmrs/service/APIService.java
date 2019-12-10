package org.opensrp.connector.openmrs.service;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.util.HttpResponse;

public interface APIService {
	
	public JSONObject add(String payload, JSONObject jsonObject, String URL) throws JSONException;

	public HttpResponse post(String payload, JSONObject jsonObject, String URL);

	public JSONObject update(String payload, JSONObject jsonObject, String uuid, String URL) throws JSONException;
	
	public JSONObject get(String payload, String uuid, String URL) throws JSONException;
	
	public JSONObject getByQuery(String payload, String URL) throws JSONException;
	
	public JSONObject delete(String payload, String uuid, String URL) throws JSONException;
	
}
