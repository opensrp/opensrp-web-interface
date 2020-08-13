/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class RequisitionDTO {
	
	private Long id;
	
	private int branchId;
	
	private String status;
	
	private String requisitionId;
	
	private Set<RequisitionDetailsDTO> requisitionDetails;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public int getBranchId() {
		return branchId;
	}
	
	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public Set<RequisitionDetailsDTO> getRequisitionDetails() {
		return requisitionDetails;
	}
	
	public void setRequisitionDetails(Set<RequisitionDetailsDTO> requisitionDetails) {
		this.requisitionDetails = requisitionDetails;
	}
	
	public String getRequisitionId() {
		return requisitionId;
	}
	
	public void setRequisitionId(String requisitionId) {
		this.requisitionId = requisitionId;
	}
	
}
