package org.opensrp.connector.openmrs.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.APIService;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.connector.util.HttpUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSAPIServiceImpl extends OpenmrsCredentialsService implements APIService {
	
	private static final String PURGE_PART = "?purge=true";
	
	private static Logger logger = LoggerFactory.getLogger(OpenMRSAPIServiceImpl.class.toString());
	
	public OpenMRSAPIServiceImpl() {
	}
	
	public OpenMRSAPIServiceImpl(String openmrsUrl, String user, String password) {
		super(openmrsUrl, user, password);
	}
	
	@Override
	public JSONObject add(String payload, JSONObject jsonObject, String URL) throws JSONException {
		return new JSONObject(HttpUtil.post(getURL() + "/" + URL, payload, jsonObject.toString(), OPENMRS_USER, OPENMRS_PWD)
		        .body());
	}

	public HttpResponse post(String payload, JSONObject jsonObject, String URL) {
		return HttpUtil.post(getURL() + "/" + URL, payload, jsonObject.toString(), OPENMRS_USER, OPENMRS_PWD);
	}

	public JSONObject update(String payload, JSONObject jsonObject, String URL) throws JSONException {
		return null;
	}

	@Override
	public JSONObject update(String payload, JSONObject roleObjectForUpdate, String uuid, String URL) throws JSONException {
		return new JSONObject(HttpUtil.post(getURL() + "/" + URL + "/" + uuid, payload, roleObjectForUpdate.toString(),
		    OPENMRS_USER, OPENMRS_PWD).body());
	}
	
	@Override
	public JSONObject delete(String payload, String uuid, String URL) throws JSONException {
		return new JSONObject(HttpUtil.delete(getURL() + "/" + URL + "/" + uuid + PURGE_PART, payload, OPENMRS_USER,
		    OPENMRS_PWD));
	}
	
	/**
	 * payload example "v=full"
	 */
	
	@Override
	public JSONObject get(String payload, String uuid, String URL) throws JSONException {
		HttpResponse op = HttpUtil.get(HttpUtil.removeEndingSlash(OPENMRS_BASE_URL) + "/" + URL + "/" + uuid, payload,
		    OPENMRS_USER, OPENMRS_PWD);
		return new JSONObject(op.body());
	}
	
	@Override
	public JSONObject getByQuery(String payload, String URL) throws JSONException {
		HttpResponse op = HttpUtil.get(HttpUtil.removeEndingSlash(OPENMRS_BASE_URL) + "/" + URL, payload, OPENMRS_USER,
		    OPENMRS_PWD);
		return new JSONObject(op.body());
	}
	
}
