package org.opensrp.core.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
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
			int count =0;
			while ((line = br.readLine()) != null) {
				String[] healthIdFromCsv = line.split(cvsSplitBy);
				if (position == 0) {
					tags = healthIdFromCsv;
					//logger.info("tags >> " + healthIdFromCsv[0]);
				} else {
					
					String hId = healthIdFromCsv[0].trim();
					if(!hId.isEmpty() && hId!= null){
						HealthId matchedHealthId = findByKey(hId, "hId", HealthId.class);
						if(matchedHealthId != null){
							logger.info("<><><> Similar hId :"+ matchedHealthId.toString());
						}else{
							HealthId healthId = new HealthId();
							healthId.sethId(healthIdFromCsv[0].trim()); // health_id
							healthId.setType("RESERVED");
							logger.info(healthId.toString());
							save(healthId);
							count++;
						}
					}
				}
				position++;
			}
			msg = "Number of health-id uploaded successfully :  "+count;
			
		}
		catch (Exception e) {
			e.printStackTrace();
			msg = "Exception occured - " + e.getMessage() + " - "+ e.toString();
			logger.info(msg);
		}
		return msg;
	}

	
}
