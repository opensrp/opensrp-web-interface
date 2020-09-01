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
	
	private Date duration;
	
	private int participantNumber;
	
	private int nameOfTrainer;
	
	private int designationOfTrainer;
	
	private Integer division;
	
	private Integer district;
	
	private Integer upazila;
	
	private Integer branch;
	
	private String type;
	
	private String status;
	
	private Set<Integer> roles;
	
	private Set<Integer> users;
	
	private String description;
	
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
	
	public Date getDuration() {
		return duration;
	}
	
	public void setDuration(Date duration) {
		this.duration = duration;
	}
	
	public int getParticipantNumber() {
		return participantNumber;
	}
	
	public void setParticipantNumber(int participantNumber) {
		this.participantNumber = participantNumber;
	}
	
	public int getNameOfTrainer() {
		return nameOfTrainer;
	}
	
	public void setNameOfTrainer(int nameOfTrainer) {
		this.nameOfTrainer = nameOfTrainer;
	}
	
	public int getDesignationOfTrainer() {
		return designationOfTrainer;
	}
	
	public void setDesignationOfTrainer(int designationOfTrainer) {
		this.designationOfTrainer = designationOfTrainer;
	}
	
	public Integer getDivision() {
		return division;
	}
	
	public void setDivision(Integer division) {
		this.division = division;
	}
	
	public Integer getDistrict() {
		return district;
	}
	
	public void setDistrict(Integer district) {
		this.district = district;
	}
	
	public Integer getUpazila() {
		return upazila;
	}
	
	public void setUpazila(Integer upazila) {
		this.upazila = upazila;
	}
	
	public Integer getBranch() {
		return branch;
	}
	
	public void setBranch(Integer branch) {
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
	
}
