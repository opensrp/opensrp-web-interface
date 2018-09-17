package org.opensrp.facility.util;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.opensrp.acl.entity.User;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.facility.dto.FacilityWorkerDTO;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FacilityHelperUtil {
	
	@Autowired
	private FacilityServiceFactory facilityServiceFactory;
	
	@Autowired
	private FacilityWorker facilityWorker;

	public void setSessionAttribute(HttpSession session, Facility facility, String locationName) {
		if (facility.getLocation() != null) {
			session.setAttribute("selectedLocation", facility.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("locationName", locationName);
	}
	
	public void setCHCPTrainingListToSession(HttpSession session, List<FacilityTraining> CHCPTrainingList){
		session.setAttribute("CHCPTrainingList", CHCPTrainingList);
	}
	
	public void setWorkerTypeListToSession(HttpSession session, List<FacilityWorkerType> workerTypeList){
		session.setAttribute("workerTypeList", workerTypeList);
	}
	
	public void setFacilityWorkerListToSession(HttpSession session, List<FacilityWorker> facilityWorkerList){
		session.setAttribute("facilityWorkerList", facilityWorkerList);
	}
	
	public FacilityWorker convertFacilityWorkerDTO(FacilityWorkerDTO facilityWorkerDTO) {
		
		facilityWorker.setName(facilityWorkerDTO.getName());
		facilityWorker.setIdentifier(facilityWorkerDTO.getIdentifier());
		facilityWorker.setOrganization(facilityWorkerDTO.getOrganization());
		
		int facilityId = Integer.parseInt(facilityWorkerDTO.getFacilityId());
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(facilityId, "id", Facility.class);
		facilityWorker.setFacility(facility);
		
		int facilityWorkerTypeId = Integer.parseInt(facilityWorkerDTO.getFacilityWorkerTypeId());
		FacilityWorkerType facilityWorkerType = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findById(facilityWorkerTypeId, "id", FacilityWorkerType.class);
		facilityWorker.setFacilityWorkerType(facilityWorkerType);
		
		String trainings = facilityWorkerDTO.getFacilityTrainings();
		if(!trainings.equals("")){
			String[] trainingList = trainings.split(",");
			
			Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
			for(int i=0; i< trainingList.length; i++){
				FacilityTraining facilityTraining = facilityServiceFactory.getFacility("FacilityTrainingServiceImpl").findById(Integer.parseInt(trainingList[i]), "id", FacilityTraining.class);
				if(facilityTraining != null){
					facilityTrainings.add(facilityTraining);
				}
			}
			facilityWorker.setFacilityTrainings(facilityTrainings);
			}
		
		return facilityWorker;
		
	}
}
