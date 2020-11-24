package org.opensrp.core.mapper;

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
		
		targetDetails.setProductId(targetDetailsDTO.getProductId());
		targetDetails.setPercentage(targetDetailsDTO.getPercentage());
		targetDetails.setQuantity(targetDetailsDTO.getQuantity());
		targetDetails.setUnit(targetDetailsDTO.getUnit());
//		targetDetails.setStartDate(targetDetailsDTO.getStartDate());
//		targetDetails.setEndDate(targetDetailsDTO.getEndDate());
		
		targetDetails.setTimestamp(System.currentTimeMillis());
		targetDetails.setStatus(targetDetailsDTO.getStatus());
		
		targetDetails.setYear(targetDetailsDTO.getYear());
		targetDetails.setMonth(targetDetailsDTO.getMonth());
		targetDetails.setDay(targetDetailsDTO.getDay());
		return targetDetails;
	}
	
	public TargetDetails targetMapForUnionWiseTarget(TargetDetailsDTO targetDetailsDTO, TargetDetails targetDetails,
	                                                 Integer population) {
		
		targetDetails.setProductId(targetDetailsDTO.getProductId());
		targetDetails.setPercentage(targetDetailsDTO.getPercentage());
		if (!targetDetailsDTO.getPercentage().isEmpty()) {
			float percentageTarget = Float.parseFloat(targetDetailsDTO.getPercentage());
			Integer targetQuantityByPopulation = (int) Math.round((population * (percentageTarget / 100.0f)));
			targetDetails.setQuantity(targetQuantityByPopulation);
		} else {
			targetDetails.setQuantity(targetDetailsDTO.getQuantity());
		}
		targetDetails.setUnit(targetDetailsDTO.getUnit());
//		targetDetails.setStartDate(targetDetailsDTO.getStartDate());
//		targetDetails.setEndDate(targetDetailsDTO.getEndDate());
		
		targetDetails.setTimestamp(System.currentTimeMillis());
		targetDetails.setStatus(targetDetailsDTO.getStatus());
		
		targetDetails.setYear(targetDetailsDTO.getYear());
		targetDetails.setMonth(targetDetailsDTO.getMonth());
		targetDetails.setDay(targetDetailsDTO.getDay());
		return targetDetails;
	}
}
