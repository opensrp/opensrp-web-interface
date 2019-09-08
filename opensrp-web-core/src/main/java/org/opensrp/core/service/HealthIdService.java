package org.opensrp.core.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.math.BigInteger;
import java.util.*;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.json.JSONArray;
import org.json.JSONObject;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.HealthId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HealthIdService {
	
	private static final Logger logger = Logger.getLogger(HealthIdService.class);
	private static int HEALTH_ID_LIMIT = 200;
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	HealthId healthId;
	
	public HealthIdService() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}

	@Transactional
	public <T> long saveAll(List<T> t) throws Exception {
		return repository.saveAll(t);
	}
	
	@Transactional
	public <T> int delete(T t) {
		int i = 0;
		if (repository.delete(t)) {
			i = 1;
		} else {
			i = -1;
		}
		return i;
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return (List<T>) repository.findAll(tableClass);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> long update(T t) throws Exception {
		return repository.update(t);
	}
	
	@SuppressWarnings("resource")
	public String uploadHealthId(File csvFile) throws Exception {
		String msg = "";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
		
		int position = 0;
		String[] tags = null;
		try {
			br = new BufferedReader(new FileReader(csvFile));
			int count = 0;
			List<HealthId> healthIds = new ArrayList<>();
			while ((line = br.readLine()) != null) {
				String[] healthIdFromCsv = line.split(cvsSplitBy);
				if (position == 0) {
					tags = healthIdFromCsv;
					//logger.info("tags >> " + healthIdFromCsv[0]);
				} else {
					
					String hId = healthIdFromCsv[0].trim();
					if (!hId.isEmpty() && hId != null) {
						HealthId matchedHealthId = findByKey(hId, "hId", HealthId.class);
						if (matchedHealthId != null) {
							logger.info("<><><> Similar hId :" + matchedHealthId.toString());
						} else {
							HealthId healthId = new HealthId();
							healthId.sethId(healthIdFromCsv[0].trim()); // health_id
							healthId.setType("Reserved");
							logger.info(healthId.toString());
							healthIds.add(healthId);
							count++;
						}
					}
				}
				position++;
			}
			saveAll(healthIds);
			msg = "Number of health-id uploaded successfully :  " + count;
			
		}
		catch (Exception e) {
			e.printStackTrace();
			msg = "Exception occured - " + e.getMessage() + " - " + e.toString();
			logger.info(msg);
		}
		return msg;
	}

	@Transactional
	public synchronized JSONObject getHealthIdAndUpdateRecord() throws Exception {
		
		JSONObject healthIds = new JSONObject();
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			Criteria criteria = session.createCriteria(HealthId.class);
			criteria.setMaxResults(250);
			criteria.add(Restrictions.eq("status", false));
			criteria.add(Restrictions.eq("type", "Reserved"));
			criteria.addOrder(Order.asc("id"));
			List<HealthId> result = criteria.list();
			List<String> list = new ArrayList<String>();
			for (HealthId healthId : result) {
				healthId.setStatus(true);
				session.saveOrUpdate(healthId);
				list.add(healthId.gethId());
			}
			if (list.size() != 0) {
				healthIds.put("identifiers", list);
			}
		}
		catch (Exception e) {
			logger.error("health id fetch error:" + e.fillInStackTrace());
		}
		finally {
			tx.commit();
			session.close();
		}
		return healthIds;
	}
	
	public JSONObject getSingleHealthIdAndUpdateRecord() throws Exception {
		JSONObject healthIds = new JSONObject();
		Session session = sessionFactory.openSession();
		try {
			Criteria criteria = session.createCriteria(HealthId.class);
			criteria.setMaxResults(1);
			criteria.add(Restrictions.eq("status", false));
			criteria.add(Restrictions.eq("type", "Reserved"));
			criteria.addOrder(Order.asc("id"));
			List<HealthId> result = criteria.list();
			for (HealthId healthId : result) {
				healthId.setStatus(true);
				if (update(healthId) == 1) {
					healthIds.put("identifiers", healthId.gethId());
				}
				;
			}
		}
		catch (Exception e) {
			logger.error("health id fetch error:" + e.fillInStackTrace());
		}
		finally {
			session.close();
		}
		return healthIds;
		
	}

	public JSONArray generateHouseholdId(int[] villageIds) throws Exception {
		JSONArray villageCodes = new JSONArray();
		for (int i = 0; i < villageIds.length; i++) {
			if (villageIds[i] == 0)break;
			BigInteger b = repository.countByField(villageIds[i], "location_id", "health_id");
			int number = b.intValue();
			List<HealthId> healthIds = new ArrayList<>();
			for (int j = 0; j < HEALTH_ID_LIMIT; j++){
				int villageId = villageIds[i];
				number ++;
				String forthDigit = String.valueOf(number%10);
				String thirdDigit = String.valueOf((number/10)%10);
				String secondDigit = String.valueOf((number/100)%10);
				String firstDigit = String.valueOf((number/1000)%10);
				String finalNumber = firstDigit+secondDigit+thirdDigit+forthDigit;

				HealthId healthId = new HealthId();
				healthId.setCreated(new Date());
				healthId.sethId(finalNumber);
				healthId.setLocationId(villageId);
				healthId.setStatus(true);
				healthIds.add(healthId);
			}
			long isSaved = repository.saveAll(healthIds);
			if (isSaved == 1) {
				JSONObject villageCode = new JSONObject();
				villageCode.put("village_id", villageIds[i]);
				JSONArray ids = new JSONArray();
				for (HealthId healthId : healthIds) {
					ids.put(healthId.gethId());
				}
				villageCode.put("generated_code", ids);
				villageCodes.put(villageCode);
			}
		}
		return villageCodes;
	}
}
