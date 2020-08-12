package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.Status;
import org.opensrp.core.dto.RequisitionDTO;
import org.opensrp.core.dto.RequisitionDetailsDTO;
import org.opensrp.core.entity.Requisition;
import org.opensrp.core.entity.RequisitionDetails;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.RequisitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class RequisitionMapper {
	
	@Autowired
	private RequisitionService requisitionService;
	
	public Requisition map(RequisitionDTO dto, Requisition requisition) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		requisition.setBranchId(dto.getBranchId());
		
		requisition.setTimestamp(System.currentTimeMillis());
		requisition.setStatus(Status.valueOf(dto.getStatus()).name());
		
		Set<RequisitionDetailsDTO> requisitionDetailsDTOs = dto.getRequisitionDetails();
		
		Set<RequisitionDetails> requisitionDetails = new HashSet<>();
		
		if (requisition.getId() != null) {
			requisition.setRequisitionDetails(null);
			requisition.setUpdatedBy(user);
			boolean isDelete = requisitionService.deleteAllByPrimaryKey(requisition.getId(), "requisition_details",
			    "requisition_id");
			if (!isDelete) {
				return null;
			}
		} else {
			requisition.setCreator(user);
			requisition.setUuid(UUID.randomUUID().toString());
		}
		
		for (RequisitionDetailsDTO requisitionDetailsDTO : requisitionDetailsDTOs) {
			RequisitionDetails rDetails = new RequisitionDetails();
			rDetails.setCurrentStock(requisitionDetailsDTO.getCurrentStock());
			rDetails.setProductId(requisitionDetailsDTO.getProductId());
			rDetails.setQunatity(requisitionDetailsDTO.getQunatity());
			rDetails.setUuid(UUID.randomUUID().toString());
			requisitionDetails.add(rDetails);
		}
		requisition.setRequisitionDetails(requisitionDetails);
		return requisition;
		
	}
	
}
