/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
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
		Session session = getSessionFactory().openSession();
		if (TrainingLocationType.valueOf(dto.getTrainingLocationType()).name().equalsIgnoreCase("BRANCH")) {
			Branch branch = findById(dto.getBranch().longValue(), "id", Branch.class);
			dto.setDivision(branch.getDivision());
			dto.setDistrict(branch.getDistrict());
			dto.setUpazila(branch.getUpazila());
		}
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			if (dto.getId() != 0) {
				training = findById(dto.getId(), "id", Training.class);
				training = trainingMapper.map(dto, training);
			} else {
				training = new Training();
				training = trainingMapper.map(dto, training);
			}
			
			session.saveOrUpdate(training);
			
			logger.info("training saved successfully: ");
			
			if (!tx.wasCommitted())
				tx.commit();
			
		}
		catch (HibernateException e) {
			tx.rollback();
			logger.error(e);
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
		}
		return training;
		
	}
}
