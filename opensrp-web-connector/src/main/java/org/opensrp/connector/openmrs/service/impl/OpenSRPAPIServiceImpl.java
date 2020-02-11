package org.opensrp.connector.openmrs.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.APIService;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.connector.util.HttpUtil;
import org.springframework.stereotype.Service;

@Service
public class OpenSRPAPIServiceImpl extends OpensrpCredentialsService implements APIService {
	
	public JSONObject updateClient(String payload, JSONObject jsonObject, String URL) throws JSONException {
		
		return new JSONObject(HttpUtil.post(getURL() + "/" + URL, payload, jsonObject.toString(), OPENSRP_USER, OPENSRP_PWD).body());
	}
	
	@Override
	public JSONObject add(String payload, JSONObject jsonObject, String URL) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}

	public HttpResponse post(String payload, JSONObject jsonObject, String URL) {
		return null;
	}

	@Override
	public JSONObject update(String payload, JSONObject jsonObject, String uuid, String URL) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public JSONObject get(String payload, String uuid, String URL) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public JSONObject getByQuery(String payload, String URL) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public JSONObject delete(String payload, String uuid, String URL) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
}
