package org.opensrp.common.dto;


public class RequisitionQueryDto {
	
	private Long id;
	
	private int branchId;
	
	private String requisition_id;
	
	private long requisition_count;
	
	private String requisition_date;
	
	private String branch_name;
	
	private String branch_code;
	
	private String username;
		
	private String first_name;
	
	private String last_name;

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

	public String getRequisition_id() {
		return requisition_id;
	}

	public void setRequisition_id(String requisition_id) {
		this.requisition_id = requisition_id;
	}

	public long getRequisition_count() {
		return requisition_count;
	}

	public void setRequisition_count(long requisition_count) {
		this.requisition_count = requisition_count;
	}

	public String getRequisition_date() {
		return requisition_date;
	}

	public void setRequisition_date(String requisition_date) {
		this.requisition_date = requisition_date;
	}

	public String getBranch_name() {
		return branch_name;
	}

	public void setBranch_name(String branch_name) {
		this.branch_name = branch_name;
	}

	public String getBranch_code() {
		return branch_code;
	}

	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFirst_name() {
		return first_name;
	}

	public void setFirst_name(String first_name) {
		this.first_name = first_name;
	}

	public String getLast_name() {
		return last_name;
	}

	public void setLast_name(String last_name) {
		this.last_name = last_name;
	}
}
