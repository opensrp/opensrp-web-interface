package org.opensrp.core.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javassist.tools.framedump;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Team;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamService;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.util.FacilityHelperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityService {
	
	private static final Logger logger = Logger.getLogger(FacilityService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private FacilityWorkerService facilityWorkerService;
	
	@Autowired
	private TeamService teamService;
	
	@Autowired
	private LocationService locationService;
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	public <T> int update(T t) throws Exception {
		return repository.update(t);
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		return repository.delete(t);
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return repository.findByKeys(fielaValues, className);
	}
	
	@Transactional
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return repository.findAllByKeys(fielaValues, className);
	}
	
	@Transactional
	public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
		return repository.findLastByKey(fielaValues, orderByFieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}
	
	/**
	 * Fulfill all the prerequisites and save new Facility
	 * <p>
	 * <ol>
	 * <li>Set location codes to Facility</li>
	 * <li>Save Facility</li>
	 * </ol>
	 * </p>
	 * 
	 * @param facility Facility-object
	 * @return 1 for success and -1 for failure.
	 */
	@Transactional
	public long saveFacility(Facility facility) throws Exception {
		facility = setLocationCodesToFacility(facility);
		long returnValue = save(facility);
		facilityHelperUtil.addTeamFromCommunity(facility);
		return returnValue;
	}
	
	/**
	 * <p>
	 * Set location codes to Facility. Location code stays in the same string with location name.
	 * This method separates the location-name and code and put them in different fields. Example:
	 * In input Facility-object: divisionName= Dhaka?32 divisionCode= null In output
	 * Facility-object: divisionName= Dhaka divisionCode= 32
	 * </p>
	 * 
	 * @param facility Facility-object in which location name and location code is in the same field
	 * @return Facility Facility-object in which location name and location code is in two fields
	 */
	public Facility setLocationCodesToFacility(Facility facility) {
		if (facility.getDivision() != null && !facility.getDivision().isEmpty()) {
			String[] division = facility.getDivision().split("\\?");
			if (division.length > 1) {
				facility.setDivision(division[1]);
				facility.setDivisionCode(division[0]);
			} else {
				facility.setDivision("");
				facility.setDivisionCode("");
			}
		}
		if (facility.getDistrict() != null && !facility.getDistrict().isEmpty()) {
			String[] district = facility.getDistrict().split("\\?");
			if (district.length > 1) {
				facility.setDistrict(district[1]);
				facility.setDistrictCode(district[0]);
			} else {
				facility.setDistrict("");
				facility.setDistrictCode("");
			}
		}
		if (facility.getUpazila() != null && !facility.getUpazila().isEmpty()) {
			String[] upazilla = facility.getUpazila().split("\\?");
			if (upazilla.length > 1) {
				facility.setUpazila(upazilla[1]);
				facility.setUpazilaCode(upazilla[0]);
			} else {
				facility.setUpazila("");
				facility.setUpazilaCode("");
			}
		}
		if (facility.getUnion() != null && !facility.getUnion().isEmpty()) {
			String[] union = facility.getUnion().split("\\?");
			if (union.length > 1) {
				facility.setUnion(union[1]);
				facility.setUnionCode(union[0]);
			} else {
				facility.setUnion("");
				facility.setUnionCode("");
			}
		}
		if (facility.getWard() != null && !facility.getWard().isEmpty()) {
			String[] ward = facility.getWard().split("\\?");
			if (ward.length > 1) {
				facility.setWard(ward[1]);
				facility.setWardCode(ward[0]);
			} else {
				facility.setWard("");
				facility.setWardCode("");
			}
			
		}
		return facility;
	}
	
	/**
	 * <p>
	 * Get list of all FacilityWorker of a specific Facility.
	 * </p>
	 * 
	 * @param facilityId is id of the Facility
	 * @return List<FacilityWorker> list of FacilityWorker of that Facility
	 */
	public List<FacilityWorker> getFacilityWorkerList(int facilityId) {
		Facility facility = findById(facilityId, "id", Facility.class);
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityWorkerService.findAllByKeys(facilityMap, FacilityWorker.class);
		return facilityWorkerList;
	}

	@Transactional
	public List<Object[]> getCCDataByWardName(String wardName) {
		String sqlQuery = "SELECT facility.name,facility.id from core.facility where ward=:wardName";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("wardName", wardName);
		return repository.executeSelectQuery(sqlQuery, params);
	}

	public List<Object[]> getTable1Data() {
		return repository.getTable1Data();
	}

	public List<Object[]> lastSevenDaysData(String startDate, String endDate) {
		return repository.lastSevenDaysData(startDate, endDate);
	}

	public List<Object[]> countPopulation() {
		return repository.countPopulation();
	}
}
