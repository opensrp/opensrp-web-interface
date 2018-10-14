package org.opensrp.facility.service;

import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.facility.service.FacilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityWorkerService{
	
	private static final Logger logger = Logger.getLogger(FacilityWorkerService.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	public <T> int update(T t) throws Exception {
		return databaseRepositoryImpl.update(t);
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return databaseRepositoryImpl.findByKeys(fielaValues, className);
	}
	
	@Transactional
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return databaseRepositoryImpl.findAllByKeys(fielaValues, className);
	}
	
	@Transactional
	public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
		return databaseRepositoryImpl.findLastByKey(fielaValues, orderByFieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
}
