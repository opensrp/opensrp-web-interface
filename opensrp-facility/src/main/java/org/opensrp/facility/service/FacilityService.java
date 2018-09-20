package org.opensrp.facility.service;

import java.util.List;
import java.util.Map;

public interface FacilityService {
	
	public <T> long save(T t) throws Exception;
	
	public <T> int update(T t) throws Exception;
	
	public <T> boolean delete(T t);
	
	public <T> T findById(int id, String fieldName, Class<?> className);
	
	public <T> T findByKey(String value, String fieldName, Class<?> className);
	
	public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className);
	
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className);
	
	public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className);
	
	public <T> List<T> findAll(String tableClass);
}
