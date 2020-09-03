/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.HashMap;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.opensrp.common.util.TrainingLocationType;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Training;
import org.opensrp.core.mapper.TrainingMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TrainingService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(TrainingService.class);
	
	@Autowired
	private TrainingMapper trainingMapper;
	
	public TrainingService() {
		
	}
	
	@Transactional
	public Training save(TrainingDTO dto) throws Exception {
		Training training;
		Session session = getSessionFactory();
		if (TrainingLocationType.valueOf(dto.getTrainingLocationType()).name().equalsIgnoreCase("BRANCH")) {
			
			Map<String, Object> map = new HashMap<>();
			map.put("id", dto.getBranch());
			Branch branch = findByKeys(map, Branch.class);
			
			dto.setDivision(branch.getDivision());
			dto.setDistrict(branch.getDistrict());
			dto.setUpazila(branch.getUpazila());
		}
		
		deleteAllByPrimaryKey(dto.getId(), "training_role", "training_id", session);
		deleteAllByPrimaryKey(dto.getId(), "training_user", "training_id", session);
		if (dto.getId() != null && dto.getId() != 0) {
			training = findById(dto.getId(), "id", Training.class);
			training = trainingMapper.map(dto, training);
		} else {
			training = new Training();
			training = trainingMapper.map(dto, training);
		}
		
		session.saveOrUpdate(training);
		
		logger.info("training saved successfully: ");
		
		return training;
		
	}
}
