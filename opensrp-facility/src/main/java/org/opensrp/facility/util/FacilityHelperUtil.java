package org.opensrp.facility.util;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;

public class FacilityHelperUtil {

	public static void setSessionAttribute(HttpSession session, Facility facility, String locationName) {
		if (facility.getLocation() != null) {
			session.setAttribute("selectedLocation", facility.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("locationName", locationName);
	}
	
	public static void setCHCPTrainingListToSession(HttpSession session, List<FacilityTraining> CHCPTrainingList){
		session.setAttribute("CHCPTrainingList", CHCPTrainingList);
	}
	
	public static void setWorkerTypeListToSession(HttpSession session, List<FacilityWorkerType> workerTypeList){
		session.setAttribute("workerTypeList", workerTypeList);
	}
	
	public static void setFacilityWorkerListToSession(HttpSession session, List<FacilityWorker> facilityWorkerList){
		session.setAttribute("facilityWorkerList", facilityWorkerList);
	}
}
