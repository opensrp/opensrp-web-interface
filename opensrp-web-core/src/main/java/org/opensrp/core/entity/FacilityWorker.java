package org.opensrp.core.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "facility_worker", schema = "core")
public class FacilityWorker implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "facility_worker_id_seq")
	@SequenceGenerator(name = "facility_worker_id_seq", sequenceName = "facility_worker_id_seq", allocationSize = 1)
	private int id;
	
	@NotNull
	@Column(name = "name")
	private String name;
	
	@NotNull
	@Column(name = "identifier")
	private String identifier;

	@Column(name = "username")
	private String username;
	
	@Column(name = "organization")
	private String organization;
	
	@ManyToOne()
	@JoinColumn(name = "facility_id", referencedColumnName = "id")
	private Facility facility;
	
	@ManyToOne()
	@JoinColumn(name = "facility_worker_type_id", referencedColumnName = "id")
	private FacilityWorkerType facilityWorkerType;
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "facility_worker_training", schema = "core", joinColumns = { @JoinColumn(name = "facility_worker_id") }, inverseJoinColumns = { @JoinColumn(name = "facility_training_id") })
	private Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public void setCreated(Date created) {
		this.created = created;
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void setUpdated(Date updated) {
		this.updated = updated;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
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
	
	public void setName(String name) {
		this.name = name;
	}
	
	public Facility getFacility() {
		return facility;
	}
	
	public void setFacility(Facility facility) {
		this.facility = facility;
	}
	
	public FacilityWorkerType getFacilityWorkerType() {
		return facilityWorkerType;
	}
	
	public void setFacilityWorkerType(FacilityWorkerType facilityWorkerType) {
		this.facilityWorkerType = facilityWorkerType;
	}
	
	public Set<FacilityTraining> getFacilityTrainings() {
		return facilityTrainings;
	}
	
	public void setFacilityTrainings(Set<FacilityTraining> facilityTrainings) {
		this.facilityTrainings = facilityTrainings;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}
