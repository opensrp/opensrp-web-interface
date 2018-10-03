package org.opensrp.facility.util;

import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.impl.FacilityServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerTrainingServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerTypeServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FacilityServiceFactory {
	
	@Autowired
	private  FacilityServiceImpl facilityServiceImpl;
	@Autowired
	private  FacilityWorkerServiceImpl facilityWorkerServiceImpl;
	@Autowired
	private  FacilityWorkerTrainingServiceImpl facilityWorkerTrainingServiceImpl;
	@Autowired
	private  FacilityWorkerTypeServiceImpl facilityWorkerTypeServiceImpl;
	
	private  FacilityService facilityService;

	public  FacilityService getFacility(String facilityType){
		
		if("FacilityServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityServiceImpl;
		}else if("FacilityWorkerServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerServiceImpl;
		}else if("FacilityWorkerTrainingServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerTrainingServiceImpl;
		}else if("FacilityWorkerTypeServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerTypeServiceImpl;
		}
		
		System.out.println(facilityService.toString());
		return facilityService;
	}
	
	
}
