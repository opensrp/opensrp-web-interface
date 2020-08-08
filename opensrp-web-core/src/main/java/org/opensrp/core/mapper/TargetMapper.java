package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.dto.TargetDetailsDTO;
import org.opensrp.core.entity.Target;
import org.opensrp.core.entity.TargetDetails;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class TargetMapper {
	
	@Autowired
	private TargetService targetService;
	
	public Target map(TargetDTO dto, Target target) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		//User user = (User) auth.getPrincipal();
		
		Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
		
		Set<TargetDetails> _targetDetails = new HashSet<>();
		
		if (target.getId() != null) {
			target.setTargetDetails(null);
			//target.setUpdatedBy(user);
			boolean isDelete = targetService.deleteAllByPrimaryKey(target.getId(), "target_details", "target_id");
			if (!isDelete) {
				return null;
			}
		} else {
			//target.setCreator(user);
			target.setUuid(UUID.randomUUID().toString());
		}
		Set<Integer> targetTos = dto.getTargetTo();
		for (Integer targetTo : targetTos) {
			
			for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
				TargetDetails targetDetails = new TargetDetails();
				targetDetails.setBranchId(targetDetailsDTO.getBranchId());
				targetDetails.setProductId(targetDetailsDTO.getProductId());
				targetDetails.setPercentage(targetDetailsDTO.getPercentage());
				targetDetails.setQuantity(targetDetailsDTO.getQuantity());
				targetDetails.setUnit(targetDetailsDTO.getUnit());
				targetDetails.setStartDate(targetDetailsDTO.getStartDate());
				targetDetails.setEndDate(targetDetailsDTO.getEndDate());
				targetDetails.setUserId(targetDetailsDTO.getUserId());
				targetDetails.setUuid(UUID.randomUUID().toString());
				targetDetails.setTimestamp(System.currentTimeMillis());
				targetDetails.setStatus(targetDetailsDTO.getStatus());
				targetDetails.setTarget(target);
				_targetDetails.add(targetDetails);
				
			}
			target.setTargetDetails(_targetDetails);
			
		}
		return target;
		
	}
	
}
