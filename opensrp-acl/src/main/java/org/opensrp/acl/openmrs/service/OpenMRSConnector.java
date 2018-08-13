/**
 * @author proshanto
 * */

package org.opensrp.acl.openmrs.service;

import org.json.JSONArray;
import org.json.JSONException;

public interface OpenMRSConnector<T> {
	
	public T add(T jsonObject) throws JSONException;
	
	public String update(T jsonObject, String uuid) throws JSONException;
	
	public String get(String uuid) throws JSONException;
	
	public JSONArray getByQuery(String query) throws JSONException;
	
	public String delete(String uuid) throws JSONException;
}
