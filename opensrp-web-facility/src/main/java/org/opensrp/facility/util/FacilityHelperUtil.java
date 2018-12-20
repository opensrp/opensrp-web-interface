package org.opensrp.facility.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Team;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamService;
import org.opensrp.facility.dto.FacilityWorkerDTO;
import org.opensrp.facility.entity.Chcp;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.FacilityWorkerService;
import org.opensrp.facility.service.FacilityWorkerTrainingService;
import org.opensrp.facility.service.FacilityWorkerTypeService;
import org.springframework.beans.factory.annotation.Autowired;
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
	
	public void setFacilityWorkerTypeAndTrainingsToSession(HttpSession session) {
		List<FacilityWorkerType> workerTypeList = facilityWorkerTypeService.findAll("FacilityWorkerType");
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
					if (facilityFromCsv.length >= 1) {
						facility.setName(facilityFromCsv[0]);
					}
					
					if (facilityFromCsv.length >= 2) {
						facility.setHrmId(facilityFromCsv[1]);
					}
					
					if (facilityFromCsv.length >= 4) {
						facility.setDivision(facilityFromCsv[3].toUpperCase());
					}
					
					if (facilityFromCsv.length >= 5) {
						facility.setDivisionCode(facilityFromCsv[4]);
					}
					
					if (facilityFromCsv.length >= 6) {
						facility.setDistrict(facilityFromCsv[5].toUpperCase());
					}
					
					if (facilityFromCsv.length >= 7) {
						facility.setDistrictCode(facilityFromCsv[6]);
					}
					
					if (facilityFromCsv.length >= 8) {
						facility.setUpazila(facilityFromCsv[7].toUpperCase());
					}
					
					if (facilityFromCsv.length >= 9) {
						facility.setUpazilaCode(facilityFromCsv[8]);
					}
					
					if (facilityFromCsv.length >= 10) {
						facility.setUnion(facilityFromCsv[9].toUpperCase());
					}
					
					if (facilityFromCsv.length >= 11) {
						facility.setUnionCode(facilityFromCsv[10]);
					}
					
					if (facilityFromCsv.length >= 12) {
						facility.setWard(facilityFromCsv[11].toUpperCase());
					}
					
					if (facilityFromCsv.length >= 13) {
						facility.setWardCode(facilityFromCsv[12]);
					}
					
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
			e.printStackTrace();
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
					System.out.println("tags >> " + facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> "
					        + facilityFromCsv[3]);
				} else {
					System.out.println(facilityFromCsv[0] + " >> " + facilityFromCsv[1] + " >> " + facilityFromCsv[3]);
					
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
			if (workerTypeIdNum == 8 || workerTypeIdNum == 9) {
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
		for (FacilityWorker worker : workerList) {
			workerNameList.add(worker.getName());
		}
		return workerNameList;
	}
	
	@Transactional
	public List<String> getAllWorkersNameByKeysWithALlMatchesFromView(String name) {
		String query = "select first_name from core.\"viewJsonDataConversionOfClient\""
		        + "where entity_type in ('ec_member', 'ec_woman')" + "and first_name ilike '%" + name + "%'";
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
