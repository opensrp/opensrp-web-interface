/**
 * 
 */
package org.opensrp.web.nutrition.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.common.util.AllConstant;
import org.opensrp.common.util.DateUtil;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.entity.ChildGrowth;
import org.opensrp.web.nutrition.utils.Age;
import org.opensrp.web.nutrition.utils.GrowthValocityChart;
import org.opensrp.web.nutrition.utils.Interval;
import org.opensrp.web.nutrition.utils.Weight;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */

@Service
public class ChildGrowthService {
	
	private static final Logger logger = Logger.getLogger(ChildGrowthService.class);
	
	@Autowired
	private MarkerServiceImpl markerServiceImpl;
	
	@Autowired
	private Marker marker;
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private SessionFactory sessionFactory;
	
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
	public <T> List<T> findAll(String tableClass) {
		// TODO Auto-generated method stub
		return repository.findAll(tableClass);
	}
	
	@Transactional
	public void startCalculateChildGrowth() throws Exception {
		searchBuilder.clear();
		marker = markerServiceImpl.findByName(AllConstant.MRAKER_NAME);
		searchBuilder.clear();
		searchBuilder.setServerVersionn(marker.getTimeStamp());
		List<Object[]> childWeights = repository.getDataFromView(searchBuilder, -1, -1, "viewJsonDataConversionOfWeight",
		    "weight", "server_version");
		
		List<Map<String, Integer>> growthValocityChart = GrowthValocityChart.getGrowthValocityChart();
		
		Map<String, Integer> maleGrowthValocityChart = growthValocityChart.get(0);
		
		Map<String, Integer> femaleGrowthValocityChart = growthValocityChart.get(1);
		if (childWeights != null) {
			for (Object[] row : childWeights) {
				
				double currentWeight = 0;
				double growth = 0;
				boolean growthStatus = false;
				int interval = 0;
				String provider = "";
				int age = 0;
				String key = "";
				String gender = "";
				String first_name = "";
				int expectedGrowthWeight = 0;
				double zScore = 0;
				String gps = "";
				int chronicalFaltering = 0;
				int chronicalGrowth = 0;
				long currentDocumentTimeStamp = Long.parseLong(String.valueOf(row[4]));
				
				//try {
				
				Map<String, Object> fieldValues = new HashMap<String, Object>();
				zScore = Double.parseDouble(String.valueOf(row[6]));
				gps = String.valueOf(row[9]);
				String[] latlon = gps.split(" ");
				String baseEntityId = String.valueOf(row[0]);
				Date dob = DateUtil.parseDate(String.valueOf(row[7]));
				
				Date currentEventDate = DateUtil.parseDate(String.valueOf(row[1]));
				
				currentWeight = Double.parseDouble(String.valueOf(row[5]));
				provider = String.valueOf(row[3]);
				double lastWeight = 0;
				Date lastEventDate = null;
				fieldValues.clear();
				fieldValues.put("provider", provider);
				fieldValues.put("baseEntityId", baseEntityId);
				ChildGrowth previousEvent = repository.findLastByKeyLessThanDateConditionOneField(fieldValues,
				    currentEventDate, "lastEventDate", "lastEventDate", ChildGrowth.class);
				
				if (previousEvent != null) {
					lastEventDate = previousEvent.getLastEventDate();
					lastWeight = previousEvent.getWeight();
				} else {
					lastEventDate = dob;
					lastWeight = Double.parseDouble(String.valueOf(row[10]));
				}
				
				growth = (int) Weight.getWeightInGram(lastWeight, currentWeight);
				interval = Interval.getInterval(lastEventDate, currentEventDate);
				age = Age.getApproximateAge(dob, currentEventDate);
				key = String.valueOf(interval) + String.valueOf(age);
				first_name = String.valueOf(row[11]);
				gender = String.valueOf(row[8]);
				if ("Male".equalsIgnoreCase(gender)) {
					if (maleGrowthValocityChart.containsKey(key)) {
						expectedGrowthWeight = (int) maleGrowthValocityChart.get(key);
					}
					
				} else {
					if (femaleGrowthValocityChart.containsKey(key)) {
						expectedGrowthWeight = (int) femaleGrowthValocityChart.get(key);
					}
					
				}
				
				if (growth >= expectedGrowthWeight) {
					growthStatus = true;
					chronicalGrowth = 1;
				} else {
					chronicalFaltering = 1;
				}
				
				if (previousEvent == null) {
					if (growthStatus) {
						chronicalGrowth = 1;
					} else {
						chronicalFaltering = 1;
					}
					
				} else {
					if (previousEvent.isGrowthStatus() && growthStatus) {
						chronicalGrowth = previousEvent.getChronicalGrowth() + 1;
					} else if (previousEvent.isGrowthStatus() && !growthStatus) {
						chronicalGrowth = 0;
						chronicalFaltering = 1;
					} else if (!previousEvent.isGrowthStatus() && growthStatus) {
						chronicalFaltering = 0;
						chronicalGrowth = 1;
					} else if (!previousEvent.isGrowthStatus() && !growthStatus) {
						chronicalFaltering = previousEvent.getChronicalFaltering() + 1;
					}
					
				}
				
				fieldValues.clear();
				fieldValues.put("lastEventDate", currentEventDate);
				fieldValues.put("baseEntityId", baseEntityId);
				
				ChildGrowth findChildGrowth = repository.findByKeys(fieldValues, ChildGrowth.class);
				
				if (findChildGrowth != null) {
					findChildGrowth.setAge(age);
					findChildGrowth.setBaseEntityId(baseEntityId);
					findChildGrowth.setGrowthStatus(growthStatus);
					findChildGrowth.setzScore(zScore);
					findChildGrowth.setWeight(currentWeight);
					findChildGrowth.setGrowth(growth);
					findChildGrowth.setChronicalFaltering(chronicalFaltering);
					findChildGrowth.setChronicalGrowth(chronicalGrowth);
					findChildGrowth.setLastEventDate(currentEventDate);
					findChildGrowth.setGender(gender);
					findChildGrowth.setFirst_name(first_name);
					findChildGrowth.setInterval(interval);
					findChildGrowth.setProvider(provider);
					findChildGrowth.setLastEvent(false);
					try {
						if (!gps.equalsIgnoreCase("null")) {
							findChildGrowth.setLat(Double.parseDouble(latlon[0]));
							findChildGrowth.setLon(Double.parseDouble(latlon[1]));
						}
					}
					catch (Exception e) {}
					
					update(findChildGrowth);
					
				} else {
					ChildGrowth childGrowth = new ChildGrowth();
					childGrowth.setAge(age);
					childGrowth.setBaseEntityId(baseEntityId);
					childGrowth.setGrowthStatus(growthStatus);
					childGrowth.setzScore(zScore);
					childGrowth.setWeight(currentWeight);
					childGrowth.setGrowth(growth);
					childGrowth.setLastEventDate(currentEventDate);
					childGrowth.setChronicalFaltering(chronicalFaltering);
					childGrowth.setChronicalGrowth(chronicalGrowth);
					childGrowth.setGender(gender);
					childGrowth.setFirst_name(first_name);
					childGrowth.setInterval(interval);
					childGrowth.setProvider(provider);
					childGrowth.setLastEvent(false);
					try {
						if (!gps.equalsIgnoreCase("null")) {
							
							childGrowth.setLat(Double.parseDouble(latlon[0]));
							childGrowth.setLon(Double.parseDouble(latlon[1]));
							
						}
					}
					catch (Exception e) {}
					
					save(childGrowth);
					
				}
				
				falseAllEventByChild(baseEntityId, provider, fieldValues);
				
				markLastEvent(baseEntityId, provider, fieldValues);
				if (marker.getTimeStamp() < currentDocumentTimeStamp) {
					marker.setTimeStamp(currentDocumentTimeStamp);
					markerServiceImpl.update(marker);
				}
				
				/*}
				catch (Exception e) {
					logger.error("error at base entity id :" + String.valueOf(row[0]) + ",cause:" + e.getMessage());
				}*/
			}
		} else {
			logger.info("No child birth record found");
		}
		
	}
	
	private void falseAllEventByChild(String baseEntityId, String provider, Map<String, Object> fielaValues)
	    throws Exception {
		/**
		 * make false all true entity
		 */
		fielaValues.clear();
		fielaValues.put("isLastEvent", true);
		fielaValues.put("baseEntityId", baseEntityId);
		fielaValues.put("provider", provider);
		List<ChildGrowth> childGrowths = repository.findAllByKeys(fielaValues, ChildGrowth.class);
		
		if (childGrowths != null) {
			for (ChildGrowth childGrowth : childGrowths) {
				childGrowth.setLastEvent(false);
				update(childGrowth);
			}
		}
		
	}
	
	private void markLastEvent(String baseEntityId, String provider, Map<String, Object> fielaValues) throws Exception {
		
		fielaValues.clear();
		fielaValues.put("provider", provider);
		fielaValues.put("baseEntityId", baseEntityId);
		ChildGrowth childGrowth = repository.findLastByKey(fielaValues, "lastEventDate", ChildGrowth.class);
		childGrowth.setLastEvent(true);
		update(childGrowth);
	}
	
	@Transactional
	public List<Object[]> getChildFalteredData(SearchBuilder searchBuilder) {
		Session session = sessionFactory.openSession();
		
		String procedureName = "core.child_growth_report";
		String hql = "select * from " + procedureName + "(array[:division,:district,:upazila"
		        + ",:union,:ward,:subunit,:mauzapara,:provider,:start_date,:end_date])";
		Query query = session.createSQLQuery(hql);
		setParameter(searchBuilder, query);
		
		return repository.getDataFromSQLFunction(query, session);
	}
	
	@Transactional
	public List<Object[]> getSummaryData(SearchBuilder searchBuilder) {
		Session session = sessionFactory.openSession();
		
		String procedureName = "core.child_summary_report";
		String hql = "select * from " + procedureName + "(array[:division,:district,:upazila"
		        + ",:union,:ward,:subunit,:mauzapara,:provider,:start_date,:end_date])";
		Query query = session.createSQLQuery(hql);
		setParameter(searchBuilder, query);
		
		return repository.getDataFromSQLFunction(query, session);
	}
	
	private void setParameter(SearchBuilder searchBuilder, Query query) {
		
		if (searchBuilder.getDivision() != null && !searchBuilder.getDivision().isEmpty()) {
			query.setParameter("division", searchBuilder.getDivision());
		} else {
			query.setParameter("division", "");
		}
		if (searchBuilder.getDistrict() != null && !searchBuilder.getDistrict().isEmpty()) {
			query.setParameter("district", searchBuilder.getDistrict());
		} else {
			query.setParameter("district", "");
		}
		
		if (searchBuilder.getUpazila() != null && !searchBuilder.getUpazila().isEmpty()) {
			query.setParameter("upazila", searchBuilder.getUpazila());
		} else {
			query.setParameter("upazila", "");
		}
		
		if (searchBuilder.getUnion() != null && !searchBuilder.getUnion().isEmpty()) {
			query.setParameter("union", searchBuilder.getUnion());
		} else {
			query.setParameter("union", "");
		}
		
		if (searchBuilder.getWard() != null && !searchBuilder.getWard().isEmpty()) {
			query.setParameter("ward", searchBuilder.getWard());
		} else {
			query.setParameter("ward", "");
		}
		
		if (searchBuilder.getSubunit() != null && !searchBuilder.getSubunit().isEmpty()) {
			query.setParameter("subunit", searchBuilder.getSubunit());
		} else {
			query.setParameter("subunit", "");
		}
		
		if (searchBuilder.getMauzapara() != null && !searchBuilder.getMauzapara().isEmpty()) {
			query.setParameter("mauzapara", searchBuilder.getMauzapara());
		} else {
			query.setParameter("mauzapara", "");
		}
		
		if (searchBuilder.getProvider() != null && !searchBuilder.getProvider().isEmpty()) {
			query.setParameter("provider", searchBuilder.getProvider());
		} else {
			query.setParameter("provider", "");
		}
		
		if (searchBuilder.getStart() != null && !searchBuilder.getStart().isEmpty()) {
			query.setParameter("start_date", searchBuilder.getStart());
			
		} else {
			query.setParameter("start_date", "");
		}
		
		if (searchBuilder.getEnd() != null && !searchBuilder.getEnd().isEmpty()) {
			query.setParameter("end_date", searchBuilder.getEnd());
		} else {
			query.setParameter("end_date", "");
		}
		
	}
}
