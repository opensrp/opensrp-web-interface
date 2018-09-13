package org.opensrp.connector.openmrs.service;

import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class APIServiceFactory {
	
	private APIService apiService;
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	public APIService getApiService(String service) {
		if ("openmrs".equalsIgnoreCase(service)) {
			apiService = openMRSAPIServiceImpl;
		} else {
			apiService = null;
		}
		return apiService;
		
	}
}
