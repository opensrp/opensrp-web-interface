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
import org.opensrp.common.util.AllConstant;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.service.NutritionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */

@Service
public class ChildGrowthServiceImpl implements NutritionService {
	
	private static final Logger logger = Logger.getLogger(ChildGrowthServiceImpl.class);
	
	@Autowired
	private MarkerServiceImpl markerServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private Marker marker;
	
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
		// TODO Auto-generated method stub
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	public void startCalculateChildGrowth() {
		marker = markerServiceImpl.findByName(AllConstant.MRAKER_NAME);
		searchBuilder.setServerVersionn(marker.getTimeStamp());
		List<Object> childWeights = databaseRepositoryImpl.getDataFromView(searchBuilder, -1, -1,
		    "viewJsonDataConversionOfWeight", "weight");
		
		for (Object childWeight : childWeights) {
			//long currentDocumentTimeStamp = childWeight[]
			System.err.println("childWeight:" + childWeight);
			/*if (marker.getTimeStamp() < currentDocumentTimeStamp) {
				marker.setTimeStamp(currentDocumentTimeStamp);
				markerServiceImpl.update(marker);
			}*/
		}
		
	}
}
