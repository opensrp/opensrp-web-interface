package org.opensrp.facility.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.entity.LocationTag;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.facility.dto.FacilityWorkerDTO;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FacilityHelperUtil {
	private static final Logger logger = Logger.getLogger(LocationServiceImpl.class);
	
	@Autowired
	private FacilityServiceFactory facilityServiceFactory;
	

/*	public void setSessionAttribute(HttpSession session, Facility facility, String locationName) {
		if (facility.getLocation() != null) {
			session.setAttribute("selectedLocation", facility.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("locationName", locationName);
	}*/
	
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
		FacilityWorker facilityWorker = new FacilityWorker();
		
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
	
	@SuppressWarnings("resource")
	public String uploadFacility(File csvFile) throws Exception {
		String msg = "";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
		
		int position = 0;
		String[] tags = null;
		try {
			br = new BufferedReader(new FileReader(csvFile));
			while ((line = br.readLine()) != null) {
				String[] facilityFromCsv = line.split(cvsSplitBy);
				if (position == 0) {
					tags = facilityFromCsv;
					System.out.println("tags >> "+facilityFromCsv[0]+" >> "+facilityFromCsv[1]+" >> "+facilityFromCsv[3]);
				} else {
					System.out.println(facilityFromCsv[0]+" >> "+facilityFromCsv[1]+" >> "+facilityFromCsv[3]);
					Facility facility = new Facility();
					if(facilityFromCsv.length >=1){
						facility.setName(facilityFromCsv[0]);
					}
					
					if(facilityFromCsv.length >=2){
						facility.setHrmId(facilityFromCsv[1]);
					}
					
					
					if(facilityFromCsv.length >=4){
						facility.setDivision(facilityFromCsv[3]);
					}
					
					
					if(facilityFromCsv.length >=5){
						facility.setDivisionCode(facilityFromCsv[4]);
					}
					
					
					if(facilityFromCsv.length >=6){
						facility.setDistrict(facilityFromCsv[5]);
					}
					
					
					if(facilityFromCsv.length >=7){
						facility.setDistrictCode(facilityFromCsv[6]);
					}
					
					
					if(facilityFromCsv.length >=8){
						facility.setUpazilla(facilityFromCsv[7]);
					}
					
					
					if(facilityFromCsv.length >=9){
						facility.setUpazillaCode(facilityFromCsv[8]);
					}
					
					
					if(facilityFromCsv.length >=10){
						facility.setUnion(facilityFromCsv[9]);
					}
					
					
					if(facilityFromCsv.length >=11){
						facility.setUnionCode(facilityFromCsv[10]);
					}
					
					
					if(facilityFromCsv.length >=12){
						facility.setWard(facilityFromCsv[11]);
					}
					
					
					if(facilityFromCsv.length >=13){
						facility.setWardCode(facilityFromCsv[12]);
					}
					
					
					facilityServiceFactory.getFacility("FacilityServiceImpl").save(facility);
					
					if(facilityFromCsv.length >=16){
						if((facilityFromCsv[13] != null && !facilityFromCsv[13].isEmpty()) && (facilityFromCsv[15] != null && !facilityFromCsv[15].isEmpty())){
						FacilityWorker facilityWorker = new FacilityWorker();
						facilityWorker.setFacility(facility);
						facilityWorker.setName(facilityFromCsv[13]);
						facilityWorker.setIdentifier(facilityFromCsv[15]);
						
						FacilityWorkerType facilityWorkerType = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findById(1, "id", FacilityWorkerType.class);
						facilityWorker.setFacilityWorkerType(facilityWorkerType);
						facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").save(facilityWorker);
						}

					}
					
				}
				position++;
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
			logger.info("Some problem occured, please contact with admin..");
			msg = "Some problem occured, please contact with admin..";
		}
		return msg;
	}
}
