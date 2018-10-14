package org.opensrp.facility.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityWorker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityService {

	private static final Logger logger = Logger
			.getLogger(FacilityService.class);

	@Autowired
	private DatabaseRepository repository;

	@Autowired
	private FacilityWorkerService facilityWorkerService;

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
	public <T> T findOneByKeys(Map<String, Object> fielaValues,
			Class<?> className) {
		return repository.findByKeys(fielaValues, className);
	}

	@Transactional
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues,
			Class<?> className) {
		return repository.findAllByKeys(fielaValues, className);
	}

	@Transactional
	public <T> T findLastByKeys(Map<String, Object> fielaValues,
			String orderByFieldName, Class<?> className) {
		return repository.findLastByKey(fielaValues, orderByFieldName,
				className);
	}

	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}

	@Transactional
	public long saveFacility(Facility facility) throws Exception {
		facility = setLocationCodesToFacility(facility);
		return save(facility);
	}

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

	public List<FacilityWorker> getFacilityWorkerList(int facilityId) {
		Facility facility = findById(facilityId, "id", Facility.class);
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityWorkerService
				.findAllByKeys(facilityMap, FacilityWorker.class);
		return facilityWorkerList;
	}

}
