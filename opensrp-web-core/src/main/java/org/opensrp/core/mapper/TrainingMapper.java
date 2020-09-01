package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.Status;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.entity.ProductRole;
import org.opensrp.core.entity.Training;
import org.opensrp.core.entity.User;
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
		User user = (User) auth.getPrincipal();
		
		training.setTitle(dto.getTitle());
		training.setDescription(dto.getDescription());
		training.setBranch(dto.getBranch());
		training.setNameOfTrainer(dto.getNameOfTrainer());
		training.setDesignationOfTrainer(dto.getDesignationOfTrainer());
		training.setTimestamp(System.currentTimeMillis());
		training.setStatus(Status.valueOf(dto.getStatus()).name());
		training.setType(dto.getType());
		training.setDistrict(dto.getDistrict());
		training.setDivision(dto.getDivision());
		training.setUpazila(dto.getUpazila());
		Set<Integer> productRoles = dto.getRoles();
		Set<ProductRole> _productRoles = new HashSet<>();
		
		if (training.getId() != null) {
			
			training.setUpdatedBy(user.getId());
			
		} else {
			training.setCreator(user.getId());
			training.setUuid(UUID.randomUUID().toString());
		}
		
		/*for (Integer productRole : productRoles) {
			TrainingRole _productRole = new TrainingRole();
			_productRole.setRole(productRole);
			_productRole.setProduct(product);
			_productRoles.add(_productRole);
		}
		product.setProductRole(_productRoles);*/
		return training;
		
	}
	
}
