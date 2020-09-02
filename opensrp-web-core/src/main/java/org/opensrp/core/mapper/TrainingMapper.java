package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.Status;
import org.opensrp.common.util.TrainingLocationType;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.entity.Training;
import org.opensrp.core.entity.TrainingRole;
import org.opensrp.core.entity.TrainingUser;
import org.opensrp.core.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class TrainingMapper {
	
	@Autowired
	private TrainingService trainingService;
	
	public Training map(TrainingDTO dto, Training training) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		//User user = (User) auth.getPrincipal();
		
		training.setTitle(dto.getTitle());
		training.setDescription(dto.getDescription());
		training.setBranch(dto.getBranch());
		training.setNameOfTrainer(dto.getNameOfTrainer());
		training.setDesignationOfTrainer(dto.getDesignationOfTrainer());
		training.setTimestamp(System.currentTimeMillis());
		training.setStatus(Status.valueOf(dto.getStatus()).name());
		training.setTrainingLocationType(TrainingLocationType.valueOf(dto.getTrainingLocationType()).name());
		training.setType(dto.getType());
		training.setDistrict(dto.getDistrict());
		training.setDivision(dto.getDivision());
		training.setUpazila(dto.getUpazila());
		training.setDuration(dto.getDuration());
		training.setStartDate(dto.getStartDate());
		training.setParticipantNumber(dto.getParticipantNumber());
		training.setTrainingId(dto.getTrainingId());
		if (training.getId() != null && (training.getId() != 0)) {
			
			//training.setUpdatedBy(user.getId());
			
		} else {
			//training.setCreator(user.getId());
			training.setUuid(UUID.randomUUID().toString());
		}
		Set<Integer> trainingRoles = dto.getRoles();
		Set<TrainingRole> _trainingRoles = new HashSet<>();
		for (Integer trainigRole : trainingRoles) {
			TrainingRole _trainingRole = new TrainingRole();
			_trainingRole.setRole(trainigRole);
			_trainingRole.setTraining(training);
			_trainingRoles.add(_trainingRole);
		}
		training.setTrainingRoles(_trainingRoles);
		
		Set<Integer> trainingUsers = dto.getUsers();
		Set<TrainingUser> _trainingUsers = new HashSet<>();
		for (Integer trainigUser : trainingUsers) {
			TrainingUser _trainingUser = new TrainingUser();
			_trainingUser.setUser(trainigUser);
			_trainingUser.setTraining(training);
			_trainingUsers.add(_trainingUser);
		}
		training.setTrainingUsers(_trainingUsers);
		
		return training;
		
	}
}
