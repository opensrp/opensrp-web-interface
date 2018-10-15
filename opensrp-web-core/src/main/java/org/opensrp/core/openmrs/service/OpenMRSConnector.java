/**
 * @author proshanto
 * */

package org.opensrp.core.openmrs.service;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public interface OpenMRSConnector<T> {
	
	public T add(T jsonObject) throws JSONException;
	
	public String update(T jsonObject, String uuid, JSONObject ob) throws JSONException;
	
	public String get(String uuid) throws JSONException;
	
	public JSONArray getByQuery(String query) throws JSONException;
	
	public String delete(String uuid) throws JSONException;
}
