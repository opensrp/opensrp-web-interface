package org.opensrp.common.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.impl.OpenSRPAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenSRPClientServiceImpl {
final String CLIENT_URL = "rest/event/add";

	private static String PAYLOAD = "";

	@Autowired
	private OpenSRPAPIServiceImpl openSRPAPIServiceImpl;

	public String update(JSONObject jo) throws JSONException {
		String tagUuid = "";
		openSRPAPIServiceImpl.updateClient(PAYLOAD, jo, CLIENT_URL);

		return tagUuid;
	}

}
