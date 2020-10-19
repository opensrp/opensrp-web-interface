package org.opensrp.common.dto;

public class ClientListDTO {
	
	private long id;
	
	private String baseEntityId;
	
	private String householdHead;
	
	private String householdId;
	
	private int numberOfMember;
	
	private String registrationDate;
	
	private String lastVisitDate;
	
	private String village;
	
	private String branchName;
	
	private String branchCode;
	
	private String contact;
	
	private String memberName;
	
	private String memberId;
	
	private String eventDate;
	
	private String relationWithHousehold;
	
	private String age;
	
	private String dob;
	
	private String gender;
	
	private String memberType;
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public String getBaseEntityId() {
		return baseEntityId;
	}
	
	public void setBaseEntityId(String baseEntityId) {
		this.baseEntityId = baseEntityId;
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
	
	public String getMemberName() {
		return memberName;
	}
	
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	
	public String getMemberId() {
		return memberId;
	}
	
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	
	public String getRelationWithHousehold() {
		return relationWithHousehold;
	}
	
	public void setRelationWithHousehold(String relationWithHousehold) {
		this.relationWithHousehold = relationWithHousehold;
	}
	
	public String getAge() {
		return age;
	}
	
	public void setAge(String age) {
		this.age = age;
	}
	
	public String getDob() {
		return dob;
	}
	
	public void setDob(String dob) {
		this.dob = dob;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getMemberType() {
		return memberType;
	}
	
	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}
	
	public String getEventDate() {
		return eventDate;
	}
	
	public void setEventDate(String eventDate) {
		this.eventDate = eventDate;
	}
	
}
