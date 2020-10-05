package org.opensrp.common.dto;

public class ClientDTO {
	
	private long id;
	
	private String householdHead;
	
	private String householdId;
	
	private int numberOfMember;
	
	private String registrationDate;
	
	private String lastVisitDate;
	
	private String village;
	
	private String branchName;
	
	private String branchCode;
	
	private String contact;
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public String getHouseholdHead() {
		return householdHead;
	}
	
	public void setHouseholdHead(String householdHead) {
		this.householdHead = householdHead;
	}
	
	public String getHouseholdId() {
		return householdId;
	}
	
	public void setHouseholdId(String householdId) {
		this.householdId = householdId;
	}
	
	public int getNumberOfMember() {
		return numberOfMember;
	}
	
	public void setNumberOfMember(int numberOfMember) {
		this.numberOfMember = numberOfMember;
	}
	
	public String getRegistrationDate() {
		return registrationDate;
	}
	
	public void setRegistrationDate(String registrationDate) {
		this.registrationDate = registrationDate;
	}
	
	public String getLastVisitDate() {
		return lastVisitDate;
	}
	
	public void setLastVisitDate(String lastVisitDate) {
		this.lastVisitDate = lastVisitDate;
	}
	
	public String getVillage() {
		return village;
	}
	
	public void setVillage(String village) {
		this.village = village;
	}
	
	public String getBranchName() {
		return branchName;
	}
	
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	
	public String getBranchCode() {
		return branchCode;
	}
	
	public void setBranchCode(String branchCode) {
		this.branchCode = branchCode;
	}
	
	public String getContact() {
		return contact;
	}
	
	public void setContact(String contact) {
		this.contact = contact;
	}
	
	public String getBranchAndCode() {
		return this.branchName + "(" + this.branchCode + ")";
	}
}
