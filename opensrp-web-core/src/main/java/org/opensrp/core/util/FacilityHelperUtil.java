package org.opensrp.core.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Team;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamService;
import org.opensrp.core.dto.FacilityWorkerDTO;
import org.opensrp.core.entity.Chcp;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityTraining;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.FacilityWorkerType;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.FacilityWorkerService;
import org.opensrp.core.service.FacilityWorkerTrainingService;
import org.opensrp.core.service.FacilityWorkerTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class FacilityHelperUtil {
	
	private static final Logger logger = Logger.getLogger(FacilityHelperUtil.class);
	
	@Autowired
	private FacilityService facilityService;
	
	@Autowired
	private FacilityWorkerService facilityWorkerService;
	
	@Autowired
	private FacilityWorkerTrainingService facilityWorkerTrainingService;
	
	@Autowired
	private FacilityWorkerTypeService facilityWorkerTypeService;
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private TeamService teamService;
	
	@Autowired
	private LocationService locationService;
	
	public void setCHCPTrainingListToSession(HttpSession session, List<FacilityTraining> CHCPTrainingList) {
		session.setAttribute("CHCPTrainingList", CHCPTrainingList);
	}
	
	public void setWorkerTypeListToSession(HttpSession session, List<FacilityWorkerType> workerTypeList) {
		session.setAttribute("workerTypeList", workerTypeList);
	}
	
	public void setFacilityWorkerListToSession(HttpSession session, List<FacilityWorker> facilityWorkerList) {
		session.setAttribute("facilityWorkerList", facilityWorkerList);
	}
	
	public void setBahmniVisitURLToSession(HttpSession session, String openmrsBaseURL) {
		logger.info("\n\n OpenMRS_Base_URL : "+ openmrsBaseURL + "\n");
		String bahmniVisitURL = "";
		String replacedStr = openmrsBaseURL.replaceAll("openmrs/", "bahmni/home/index.html#/login");
		bahmniVisitURL = replacedStr;
		logger.info("\n\n Bahmni_Visit_URL : "+ bahmniVisitURL + "\n");
		session.setAttribute("bahmniVisitURL", bahmniVisitURL);
	}
	
	
	public void setFacilityWorkerTypeAndTrainingsToSession(HttpSession session) {
		List<FacilityWorkerType> workerTypeList = facilityWorkerTypeService.findAll("FacilityWorkerType");
		 Collections.reverse(workerTypeList); 
		//added on dec 21, 2018: remove chcp and multiPurposeHealthVolunteer form dropdown
		/*Iterator<FacilityWorkerType> i = workerTypeList.iterator();
		while (i.hasNext()) {
			FacilityWorkerType workerType = i.next();
			if(workerType.getName().equals("CHCP") || workerType.getName().equals("MULTIPURPOSE HEALTH VOLUNTEER")){
				i.remove();
			}
		}*/
		//end
		List<FacilityTraining> CHCPTrainingList = facilityWorkerTrainingService.findAll("FacilityTraining");
		setWorkerTypeListToSession(session, workerTypeList);
		setCHCPTrainingListToSession(session, CHCPTrainingList);
	}
	
	public Map<Integer, Integer> getDistinctWorkerCount(List<FacilityWorker> facilityWorkerList) {
		List<FacilityWorkerType> workerTypeList = facilityWorkerTypeService.findAll("FacilityWorkerType");
		Map<Integer, Integer> distinctWorkerCountMap = new HashMap<Integer, Integer>();
		for (FacilityWorkerType facilityWorkerType : workerTypeList) {
			distinctWorkerCountMap.put(facilityWorkerType.getId(), 0);
		}
		if (facilityWorkerList != null) {
			for (FacilityWorker worker : facilityWorkerList) {
				int workerType = worker.getFacilityWorkerType().getId();
				int prevCount = distinctWorkerCountMap.get(workerType);
				distinctWorkerCountMap.put(workerType, prevCount + 1);
			}
		}
		return distinctWorkerCountMap;
	}
	
	public FacilityWorker convertFacilityWorkerDTO(FacilityWorkerDTO facilityWorkerDTO) {
		FacilityWorker facilityWorker = new FacilityWorker();
		facilityWorker.setName(facilityWorkerDTO.getName());
		facilityWorker.setIdentifier(facilityWorkerDTO.getIdentifier());
		facilityWorker.setOrganization(facilityWorkerDTO.getOrganization());
		facilityWorker.setUsername(facilityWorkerDTO.getUsername());
		
		int facilityId = Integer.parseInt(facilityWorkerDTO.getFacilityId());
		Facility facility = facilityService.findById(facilityId, "id", Facility.class);
		facilityWorker.setFacility(facility);
		
		int facilityWorkerTypeId = Integer.parseInt(facilityWorkerDTO.getFacilityWorkerTypeId());
		FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findById(facilityWorkerTypeId, "id",
		    FacilityWorkerType.class);
		facilityWorker.setFacilityWorkerType(facilityWorkerType);
		
		String trainings = facilityWorkerDTO.getFacilityTrainings();
		if (!trainings.equals("")) {
			String[] trainingList = trainings.split(",");
			
			Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
			for (int i = 0; i < trainingList.length; i++) {
				FacilityTraining facilityTraining = facilityWorkerTrainingService.findById(
				    Integer.parseInt(trainingList[i]), "id", FacilityTraining.class);
				if (facilityTraining != null) {
					facilityTrainings.add(facilityTraining);
				}
			}
			facilityWorker.setFacilityTrainings(facilityTrainings);
		}
		
		return facilityWorker;
		
	}
	
	//save cc form jsonObject - April 9, 2019
	public Facility saveCCFromJSONObject (JSONObject inputJSONObject){
	String msg = "";
	Facility facilityToRetrun = null;
	if(inputJSONObject != null){
		try {
			Facility facility = new Facility();
			
			String name = inputJSONObject.getString("name");
			if(name!= null && !name.isEmpty()){
				facility.setName(name); // name
			}
			
			String hrmId = inputJSONObject.getString("code");
			if(hrmId!= null && !hrmId.isEmpty()){
				Facility existingFacility = null;
				existingFacility = facilityService.findByKey(hrmId, "hrmId",  Facility.class);
				if(existingFacility!= null){
					logger.info("\nExisting Facility <><><><> "+existingFacility.toString()+"\n");
					facilityToRetrun = existingFacility;
					return facilityToRetrun;
				}else{
					facility.setHrmId(hrmId);// code
				}
			}
			
			String division = inputJSONObject.getString("division_name");
			if(division!= null && !division.isEmpty()){
				facility.setDivision(trimAndUpper(division));// division
			}
			
			String divisionCode = inputJSONObject.getString("division_code");
			if(divisionCode!= null && !divisionCode.isEmpty()){
				facility.setDivisionCode(divisionCode); // division code
			}
			
			String district = inputJSONObject.getString("district_name");
			if(district!= null && !district.isEmpty()){
				facility.setDistrict(trimAndUpper(district)); // district 
			}
			
			String districtCode = inputJSONObject.getString("district_code");
			if(districtCode!= null && !districtCode.isEmpty()){
				facility.setDistrictCode(districtCode); // district code 
			}
			
			String upazila = inputJSONObject.getString("upazila_name");
			if(upazila!= null && !upazila.isEmpty()){
				facility.setUpazila(trimAndUpper(upazila)); // upazilla
			}
			
			String upazilaCode = inputJSONObject.getString("upazila_code");
			if(upazilaCode!= null && !upazilaCode.isEmpty()){
				facility.setUpazilaCode(upazilaCode); // upazilla code
			}
			
			String union = inputJSONObject.getString("union_name");
			if(union!= null && !union.isEmpty()){
				facility.setUnion(trimAndUpper(union)); //union 
			}
			
			String unionCode = inputJSONObject.getString("union_code");
			if(unionCode!= null && !unionCode.isEmpty()){
				facility.setUnionCode(unionCode); // union code
			}
			
			String wardCode = inputJSONObject.getString("ward_code");
			wardCode = removeLeadingZeroes(wardCode);
			if(wardCode!= null && !wardCode.isEmpty()){
				facility.setWardCode(wardCode);// ward code
			}
			
			String ward = trimAndUpper(union) + ":WARD " + removeLeadingZeroes(wardCode);
			if(ward!= null && !ward.isEmpty()){
				facility.setWard(ward);// ward
			}
			
			logger.info("\n<><><><> "+facility.toString()+"\n");
			if (facility.getWardCode() != null && !facility.getWardCode().isEmpty()) {
				facilityService.save(facility);
				addTeamFromCommunity(facility);
				facilityToRetrun = facilityService.findById(facility.getId(), "id", Facility.class);
			}
			else {
				logger.info("Ward code --> "+ wardCode);
				throw new Exception("Ward code is empty!!!");
			}
		} catch (Exception e) {
			logger.info("Some problem occured, please contact admin..");
			msg = "Some problem occured, please contact with admin..";
			e.printStackTrace();
		}
	}
	return facilityToRetrun;
	}
	//end : save cc form JSONObject
	
	public String trimAndUpper(String inputString){
		String outputString;
		outputString = inputString.trim().toUpperCase();
		return outputString;
	}
	
	public String removeLeadingZeroes(String value) {
	     return value.replaceAll("[^1-9]+", "");
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
					logger.info("tags >> " + facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> " + facilityFromCsv[3]);
				} else {
					logger.info(facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> " + facilityFromCsv[3]);
					Facility facility = new Facility();
					facility.setName(facilityFromCsv[0].trim()); // name
					
					facility.setHrmId(facilityFromCsv[1].trim());// code
					
					facility.setDivision(facilityFromCsv[3].toUpperCase().trim());// division
					
					facility.setDivisionCode(facilityFromCsv[4].trim()); // division code
					
					facility.setDistrict(facilityFromCsv[5].toUpperCase()); // district 
					
					facility.setDistrictCode(facilityFromCsv[6].trim()); // district code
					
					facility.setUpazila(facilityFromCsv[7].toUpperCase()); // upazilla
					
					facility.setUpazilaCode(facilityFromCsv[8].trim()); // upazilla code
					
					facility.setUnion(facilityFromCsv[9].toUpperCase()); //union 
					
					facility.setUnionCode(facilityFromCsv[10].trim()); // union code
					
					facility.setWard(facilityFromCsv[11].toUpperCase().trim());// ward
					
					facility.setWardCode(facilityFromCsv[12].trim());// ward code
					
					logger.info(facility.toString());
					facilityService.save(facility);
					addTeamFromCommunity(facility);
					
					/*if (facilityFromCsv.length >= 16) {
						if ((facilityFromCsv[13] != null && !facilityFromCsv[13].isEmpty())
						        && (facilityFromCsv[15] != null && !facilityFromCsv[15].isEmpty())) {
							FacilityWorker facilityWorker = new FacilityWorker();
							facilityWorker.setFacility(facility);
							facilityWorker.setName(facilityFromCsv[13]);
							facilityWorker.setIdentifier(facilityFromCsv[15]);
							
							FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findById(1, "id",
							    FacilityWorkerType.class);
							facilityWorker.setFacilityWorkerType(facilityWorkerType);
							facilityWorkerService.save(facilityWorker);
						}
						
					}*/
					
				}
				position++;
			}
			
		}
		catch (Exception e) {
			logger.info("Some problem occured, please contact admin..");
			msg = "Some problem occured, please contact with admin..";
		}
		return msg;
	}
	
	@SuppressWarnings("resource")
	public String uploadChcp(File csvFile) throws Exception {
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
					logger.info("tags >> " + facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> "
					        + facilityFromCsv[3]);
				} else {
					logger.info(facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> " + facilityFromCsv[3]);
					
					if (facilityFromCsv.length >= 16) {
						if ((facilityFromCsv[13] != null && !facilityFromCsv[13].isEmpty())
						        && (facilityFromCsv[15] != null && !facilityFromCsv[15].isEmpty())) {
							Chcp chcp = new Chcp();
							chcp.setName(facilityFromCsv[13]);
							chcp.setIdentifier(facilityFromCsv[15]);
							facilityWorkerService.save(chcp);
						}
						
					}
					
				}
				position++;
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
			logger.info("Some problem occured, please contact admin..");
			msg = "Some problem occured, please contact with admin..";
		}
		return msg;
	}
	
	@Transactional
	public List<String> getAllWorkersNameByKeysWithALlMatches(String name, String workerTypeId) {
		int workerTypeIdNum;
		if (workerTypeId != null && !workerTypeId.isEmpty()) {
			workerTypeIdNum = Integer.parseInt(workerTypeId);
			if (workerTypeIdNum == 8 
					|| workerTypeIdNum == 9
					|| workerTypeIdNum == 10
					|| workerTypeIdNum == 11) {
				return getAllWorkersNameByKeysWithALlMatchesFromView(name);
			}
		}
		return getAllWorkersNameByKeysWithALlMatchesFromTable(name);
	}
	
	@Transactional
	public List<String> getAllWorkersNameByKeysWithALlMatchesFromTable(String name) {
		Map<String, String> fieldValues = new HashMap<String, String>();
		fieldValues.put("name", name);
		boolean isProvider = false;
		List<FacilityWorker> workerList = repository.findAllByKeysWithALlMatches(isProvider, fieldValues,
		    FacilityWorker.class);
		List<String> workerNameList = new ArrayList<String>();
		if(workerList!= null){
			for (FacilityWorker worker : workerList) {
				workerNameList.add(worker.getName());
			}
		}
		return workerNameList;
	}
	
	@Transactional
	public List<String> getAllWorkersNameByKeysWithALlMatchesFromView(String name) {
		String query = "select concat(first_name,' ', lastname, ' # ', phone_number) from core.\"viewJsonDataConversionOfClient\""
		        + " where entity_type in ('ec_member', 'ec_woman')" + "and first_name ilike '%" + name + "%'";
		List<String> workerNameList = repository.executeSelectQuery(query);
		return workerNameList;
	}
	
	public void addTeamFromCommunity(Facility facility) {
		try {
			Location location = (Location) locationService.findByKey(facility.getWard(), "name", Location.class);
			
			Team team = new Team();
			team.setIdentifier(facility.getName());
			team.setName(facility.getName());
			team.setLocation(location);
			team.setLocationUuid(location.getUuid());
			teamService.save(team);
		}
		catch (Exception e) {
			logger.info("team created message:" + e.getMessage());
		}
	}
	
}
