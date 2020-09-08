/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Date;
import java.util.Set;

public class TrainingDTO {
	
	private Long id;
	
	private String title;
	
	private String trainingId;
	
	private Date startDate;
	
	private String duration;
	
	private int participantNumber;
	
	private String nameOfTrainer;
	
	private String designationOfTrainer;
	
	private int division;
	
	private int district;
	
	private int upazila;
	
	private int branch;
	
	private String type;
	
	private String status;
	
	private Set<Integer> roles;
	
	private Set<Integer> users;
	
	private String description;
	
	private String trainingLocationType;
	
	private int blc;
	
	private String audience;
	
	private String locationName;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTrainingId() {
		return trainingId;
	}
	
	public void setTrainingId(String trainingId) {
		this.trainingId = trainingId;
	}
	
	public Date getStartDate() {
		return startDate;
	}
	
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	public String getDuration() {
		return duration;
	}
	
	public void setDuration(String duration) {
		this.duration = duration;
	}
	
	public int getParticipantNumber() {
		return participantNumber;
	}
	
	public void setParticipantNumber(int participantNumber) {
		this.participantNumber = participantNumber;
	}
	
	public String getNameOfTrainer() {
		return nameOfTrainer;
	}
	
	public void setNameOfTrainer(String nameOfTrainer) {
		this.nameOfTrainer = nameOfTrainer;
	}
	
	public String getDesignationOfTrainer() {
		return designationOfTrainer;
	}
	
	public void setDesignationOfTrainer(String designationOfTrainer) {
		this.designationOfTrainer = designationOfTrainer;
	}
	
	public int getDivision() {
		return division;
	}
	
	public void setDivision(int division) {
		this.division = division;
	}
	
	public int getDistrict() {
		return district;
	}
	
	public void setDistrict(int district) {
		this.district = district;
	}
	
	public int getUpazila() {
		return upazila;
	}
	
	public void setUpazila(int upazila) {
		this.upazila = upazila;
	}
	
	public int getBranch() {
		return branch;
	}
	
	public void setBranch(int branch) {
		this.branch = branch;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public Set<Integer> getRoles() {
		return roles;
	}
	
	public void setRoles(Set<Integer> roles) {
		this.roles = roles;
	}
	
	public Set<Integer> getUsers() {
		return users;
	}
	
	public void setUsers(Set<Integer> users) {
		this.users = users;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getTrainingLocationType() {
		return trainingLocationType;
	}
	
	public void setTrainingLocationType(String trainingLocationType) {
		this.trainingLocationType = trainingLocationType;
	}
	
	public int getBlc() {
		return blc;
	}
	
	public void setBlc(int blc) {
		this.blc = blc;
	}

	public String getAudience() {
		return audience;
	}

	public void setAudience(String audience) {
		this.audience = audience;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}
	
}
