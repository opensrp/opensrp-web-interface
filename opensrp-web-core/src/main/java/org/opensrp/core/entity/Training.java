/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "training", schema = "core")
public class Training implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "training_id_seq")
	@SequenceGenerator(name = "training_id_seq", sequenceName = "training_id_seq", allocationSize = 1)
	private Long id;
	
	@NotEmpty(message = "Training name can't be empty")
	@Column(name = "name")
	private String title;
	
	@Column(name = "uuid")
	private String uuid;
	
	@Column(name = "training_id")
	private String trainingId;
	
	@Column(name = "training_location_type")
	private String trainingLocationType;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "start_date")
	private Date startDate;
	
	@Column(name = "duration")
	private Date duration;
	
	@Column(name = "participant_number")
	private int participantNumber;
	
	@Column(name = "name_of_trainer")
	private int nameOfTrainer;
	
	@Column(name = "designation_of_trainer")
	private int designationOfTrainer;
	
	@Column(name = "division_id", nullable = false)
	private Integer division;
	
	@Column(name = "district_id", nullable = false)
	private Integer district;
	
	@Column(name = "upazila_id", nullable = false)
	private Integer upazila;
	
	@Column(name = "branch_id")
	private Integer branch;
	
	private Long timestamp;
	
	private String type;
	
	private String description;
	
	private String status;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@JoinColumn(name = "creator")
	private int creator;
	
	@Column(name = "updated_by")
	private int updatedBy;
	
	@OneToMany(mappedBy = "training", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Set<TrainingRole> trainingRoles = new HashSet<TrainingRole>();
	
	@OneToMany(mappedBy = "training", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Set<TrainingUser> trainingUsers = new HashSet<TrainingUser>();
	
	public Long getId() {
		return id;
		
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public void setCreated() {
		this.created = new Date();
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void setUpdated() {
		this.updated = new Date();
	}
	
	public Long getTimestamp() {
		return timestamp;
	}
	
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
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
	
	public int getCreator() {
		return creator;
	}
	
	public void setCreator(int creator) {
		this.creator = creator;
	}
	
	public int getUpdatedBy() {
		return updatedBy;
	}
	
	public void setUpdatedBy(int updatedBy) {
		this.updatedBy = updatedBy;
	}
	
	public Set<TrainingRole> getTrainingRoles() {
		return trainingRoles;
	}
	
	public void setTrainingRoles(Set<TrainingRole> trainingRoles) {
		this.trainingRoles = trainingRoles;
	}
	
	public Set<TrainingUser> getTrainingUsers() {
		return trainingUsers;
	}
	
	public void setTrainingUsers(Set<TrainingUser> trainingUsers) {
		this.trainingUsers = trainingUsers;
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
	
}
