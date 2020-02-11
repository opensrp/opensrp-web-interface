package org.opensrp.common.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.impl.OpenSRPAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenSRPClientServiceImpl {
final String CLIENT_URL = "rest/event/add";
final String APPROVAL_URL = "rest/client/data-approval";

	private static String PAYLOAD = "";

	@Autowired
	private OpenSRPAPIServiceImpl openSRPAPIServiceImpl;

	public void update(JSONObject jo) throws JSONException {
		openSRPAPIServiceImpl.updateClient(PAYLOAD, jo, CLIENT_URL);
	}

	public JSONObject approval(JSONObject jo) throws JSONException {
		return openSRPAPIServiceImpl.updateClient(PAYLOAD, jo, APPROVAL_URL);
	}

}
