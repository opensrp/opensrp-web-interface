package org.opensrp.core.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.json.JSONObject;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.HealthId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HealthIdService {
	
	private static final Logger logger = Logger.getLogger(HealthIdService.class);
	
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
							save(healthId);
							count++;
						}
					}
				}
				position++;
			}
			msg = "Number of health-id uploaded successfully :  " + count;
			
		}
		catch (Exception e) {
			e.printStackTrace();
			msg = "Exception occured - " + e.getMessage() + " - " + e.toString();
			logger.info(msg);
		}
		return msg;
	}
	
	public synchronized JSONObject getHealthIdAndUpdateRecord() throws Exception {
		
		JSONObject healthIds = new JSONObject();
		Session session = sessionFactory.openSession();
		try {
			Criteria criteria = session.createCriteria(HealthId.class);
			criteria.setMaxResults(20);
			criteria.add(Restrictions.eq("status", false));
			criteria.add(Restrictions.eq("type", "Reserved"));
			criteria.addOrder(Order.asc("id"));
			List<HealthId> result = criteria.list();
			List<String> list = new ArrayList<String>();
			for (HealthId healthId : result) {
				healthId.setStatus(true);
				if (update(healthId) == 1) {
					list.add(healthId.gethId());
				}
				;
			}
			if (list.size() != 0) {
				healthIds.put("identifiers", list);
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
	
}
