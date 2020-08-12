package org.opensrp.core.mapper;

import java.util.UUID;

import org.opensrp.core.dto.TargetDetailsDTO;
import org.opensrp.core.entity.TargetDetails;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TargetMapper {
	
	@Autowired
	private TargetService targetService;
	
	public TargetDetails map(TargetDetailsDTO targetDetailsDTO, TargetDetails targetDetails) {
		targetDetails.setBranchId(targetDetailsDTO.getBranchId());
		targetDetails.setProductId(targetDetailsDTO.getProductId());
		targetDetails.setPercentage(targetDetailsDTO.getPercentage());
		targetDetails.setQuantity(targetDetailsDTO.getQuantity());
		targetDetails.setUnit(targetDetailsDTO.getUnit());
		targetDetails.setStartDate(targetDetailsDTO.getStartDate());
		targetDetails.setEndDate(targetDetailsDTO.getEndDate());
		
		targetDetails.setUuid(UUID.randomUUID().toString());
		targetDetails.setTimestamp(System.currentTimeMillis());
		targetDetails.setStatus(targetDetailsDTO.getStatus());
		
		targetDetails.setYear(targetDetailsDTO.getYear());
		targetDetails.setMonth(targetDetailsDTO.getMonth());
		return targetDetails;
	}
}
