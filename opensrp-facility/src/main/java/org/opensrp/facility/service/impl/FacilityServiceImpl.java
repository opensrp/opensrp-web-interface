package org.opensrp.facility.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.acl.entity.Team;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.service.FacilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityServiceImpl implements FacilityService {
	
	private static final Logger logger = Logger.getLogger(FacilityServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	@Override
	public <T> int update(T t) throws Exception {
		return databaseRepositoryImpl.update(t);
	}
	
	@Transactional
	@Override
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return databaseRepositoryImpl.findByKeys(fielaValues, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return databaseRepositoryImpl.findAllByKeys(fielaValues, className);
	}
	
	@Transactional
	@Override
	public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
		return databaseRepositoryImpl.findLastByKey(fielaValues, orderByFieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	public void setSessionAttribute(HttpSession session, Facility facility, String locationName) {
		if (facility.getLocation() != null) {
			session.setAttribute("selectedLocation", facility.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("locationName", locationName);
	}
	
	
}
