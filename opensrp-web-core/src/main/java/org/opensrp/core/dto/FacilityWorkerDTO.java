package org.opensrp.core.dto;


public class FacilityWorkerDTO {

	private String name;
	private String identifier;
	private String organization;
	private String facilityId;
	private String workerId;
	private String facilityWorkerTypeId;
	private String facilityTrainings;
	private String username;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIdentifier() {
		return identifier;
	}
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getFacilityId() {
		return facilityId;
	}
	public void setFacilityId(String facilityId) {
		this.facilityId = facilityId;
	}
	public String getFacilityWorkerTypeId() {
		return facilityWorkerTypeId;
	}
	public void setFacilityWorkerTypeId(String facilityWorkerTypeId) {
		this.facilityWorkerTypeId = facilityWorkerTypeId;
	}
	public String getFacilityTrainings() {
		return facilityTrainings;
	}
	public void setFacilityTrainings(String facilityTrainings) {
		this.facilityTrainings = facilityTrainings;
	}
	
	public String getWorkerId() {
		return workerId;
	}
	public void setWorkerId(String workerId) {
		this.workerId = workerId;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Override
	public String toString() {
		return "FacilityWorkerDTO [name=" + name + ", identifier=" + identifier
				+ ", organization=" + organization + ", facilityId="
				+ facilityId + ", workerId=" + workerId
				+ ", facilityWorkerTypeId=" + facilityWorkerTypeId
				+ ", facilityTrainings=" + facilityTrainings + "]";
	}
	
	
	
}
