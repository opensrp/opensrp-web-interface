package org.opensrp.facility.util;

import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.impl.FacilityServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerTrainingServiceImpl;
import org.opensrp.facility.service.impl.FacilityWorkerTypeServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;

public class FacilityServiceFactoryUtil {
	
	@Autowired
	private static FacilityServiceImpl facilityServiceImpl;
	@Autowired
	private static FacilityWorkerServiceImpl facilityWorkerServiceImpl;
	@Autowired
	private static FacilityWorkerTrainingServiceImpl facilityWorkerTrainingServiceImpl;
	@Autowired
	private static FacilityWorkerTypeServiceImpl facilityWorkerTypeServiceImpl;
	
	private static FacilityService facilityService;

	public static FacilityService getFacility(String facilityType){
		
		if("FacilityServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityServiceImpl;
		}else if("FacilityWorkerServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerServiceImpl;
		}else if("FacilityWorkerTrainingServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerTrainingServiceImpl;
		}else if("FacilityWorkerTypeServiceImpl".equalsIgnoreCase(facilityType)){
			facilityService = facilityWorkerTypeServiceImpl;
		}
		
		//System.out.println(facilityService.toString());
		return facilityService;
	}
	
	
}
