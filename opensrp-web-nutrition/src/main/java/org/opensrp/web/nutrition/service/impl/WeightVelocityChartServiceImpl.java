/**
 * 
 */
package org.opensrp.web.nutrition.service.impl;

import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.web.nutrition.service.NutritionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */
@Service
public class WeightVelocityChartServiceImpl implements NutritionService {
	
	private static final Logger logger = Logger.getLogger(WeightVelocityChartServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
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
		// TODO Auto-generated method stub
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	@Transactional
	public <T> T findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return databaseRepositoryImpl.findByKeys(fielaValues, className);
		
	}
	
}
