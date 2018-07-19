/**
 * 
 */
package org.opensrp.web.nutrition.service.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.common.util.AllConstant;
import org.opensrp.common.util.DateUtil;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.service.NutritionService;
import org.opensrp.web.nutrition.utils.GrowthValocityChart;
import org.opensrp.web.nutrition.utils.Interval;
import org.opensrp.web.nutrition.utils.Weight;
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
	
	@Transactional
	public void startCalculateChildGrowth() throws ParseException {
		marker = markerServiceImpl.findByName(AllConstant.MRAKER_NAME);
		searchBuilder.setServerVersionn(marker.getTimeStamp());
		List<Object[]> childWeights = databaseRepositoryImpl.getDataFromView(searchBuilder, -1, -1,
		    "viewJsonDataConversionOfWeight", "weight");
		double previousWeightInDouble = 0;
		double currentWeight = 0;
		double weight = 0;
		double birthWeight = 0;
		List<Map<String, Integer>> growthValocityChart = GrowthValocityChart.getGrowthValocityChart();
		for (Map<String, Integer> map : growthValocityChart) {
			System.err.println(map);
		}
		for (Object[] row : childWeights) {
			try {
				birthWeight = Double.parseDouble(row[8].toString());
				
				String previousWeight = (String) row[9];
				currentWeight = Double.parseDouble(row[5].toString());
				System.err.println(previousWeight);
				if (previousWeight != null) {
					previousWeightInDouble = Double.parseDouble(row[9].toString());
					weight = Weight.getWeightInGram(previousWeightInDouble, currentWeight);
				} else {
					weight = Weight.getWeightInGram(birthWeight, currentWeight);
				}
				
				System.err.println("weight:" + weight);
				Date dob = DateUtil.parseDate(row[7].toString());
				Date eventDate = DateUtil.parseDate(row[1].toString());
				System.err.println(row[0] + ",Interval:" + Interval.getInterval(dob, eventDate));
			}
			catch (Exception e) {
				logger.error("Error:" + e.getMessage());
			}
		}
		
	}
}
