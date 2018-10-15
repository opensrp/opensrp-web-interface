package org.opensrp.common.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import org.exolab.castor.types.DateTime;
import org.springframework.stereotype.Service;

@Service
@Entity
public class ClientEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "clientEntity_id_seq")
	@SequenceGenerator(name = "clientEntity_id_seq", sequenceName = "clientEntity_id_seq", allocationSize = 1)
	private int id;
	
	private String baseEntityId;
	
	private String firstName;
	
	private String middleName;
	
	private String lastName;
	
	private DateTime birthdate;
	
	private DateTime deathdate;
	
	private String gender;
	
	private String phoneNumber;
	
	private String spouseName;
	
	private String nid;
	
	private String motherName;
	
	private String fatherName;
	
	private String householdCode;
	
	public String getBaseEntityId() {
		return baseEntityId;
	}
	
	public void setBaseEntityId(String baseEntityId) {
		this.baseEntityId = baseEntityId;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getMiddleName() {
		return middleName;
	}
	
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public DateTime getBirthdate() {
		return birthdate;
	}
	
	public void setBirthdate(DateTime birthdate) {
		this.birthdate = birthdate;
	}
	
	public DateTime getDeathdate() {
		return deathdate;
	}
	
	public void setDeathdate(DateTime deathdate) {
		this.deathdate = deathdate;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getPhoneNumber() {
		return phoneNumber;
	}
	
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	
	public String getSpouseName() {
		return spouseName;
	}
	
	public void setSpouseName(String spouseName) {
		this.spouseName = spouseName;
	}
	
	public String getNid() {
		return nid;
	}
	
	public void setNid(String nid) {
		this.nid = nid;
	}
	
	public String getMotherName() {
		return motherName;
	}
	
	public void setMotherName(String motherName) {
		this.motherName = motherName;
	}
	
	public String getFatherName() {
		return fatherName;
	}
	
	public void setFatherName(String fatherName) {
		this.fatherName = fatherName;
	}
	
	public String getHouseholdCode() {
		return householdCode;
	}
	
	public void setHouseholdCode(String householdCode) {
		this.householdCode = householdCode;
	}
	
	public int getId() {
		return id;
	}
}
