package org.opensrp.core.openmrs.service;

import org.opensrp.core.openmrs.service.impl.OpenMRSLocationAPIService;
import org.opensrp.core.openmrs.service.impl.OpenMRSTagAPIService;
import org.opensrp.core.openmrs.service.impl.OpenMRSTeamAPIService;
import org.opensrp.core.openmrs.service.impl.OpenMRSTeamMemberAPIService;
import org.opensrp.core.openmrs.service.impl.OpenMRSUserAPIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class OpenMRSServiceFactory {
	
	private OpenMRSConnector<Object> openMRSConnector;
	
	@Autowired
	private OpenMRSLocationAPIService openMRSLocationAPIService;
	
	@Autowired
	private OpenMRSTagAPIService openMRSTagAPIService;
	
	@Autowired
	private OpenMRSTeamAPIService openMRSTeamAPIService;
	
	@Autowired
	private OpenMRSTeamMemberAPIService openMRSTeamMemberAPIService;
	
	@Autowired
	private OpenMRSUserAPIService openMRSUserAPIService;
	
	public OpenMRSConnector<Object> getOpenMRSConnector(String connector) {
		
		if ("location".equalsIgnoreCase(connector)) {
			openMRSConnector = openMRSLocationAPIService;
		} else if ("tag".equalsIgnoreCase(connector)) {
			openMRSConnector = openMRSTagAPIService;
		} else if ("team".equalsIgnoreCase(connector)) {
			openMRSConnector = openMRSTeamAPIService;
		} else if ("member".equalsIgnoreCase(connector)) {
			openMRSConnector = openMRSTeamMemberAPIService;
		} else if ("user".equalsIgnoreCase(connector)) {
			openMRSConnector = openMRSUserAPIService;
		} else {
			openMRSConnector = null;
		}
		return openMRSConnector;
		
	}
}
