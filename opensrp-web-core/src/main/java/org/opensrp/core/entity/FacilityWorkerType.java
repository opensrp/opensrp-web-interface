package org.opensrp.core.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
@Table(name = "facility_worker_type", schema = "core")
public class FacilityWorkerType implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "facility_worker_type_id_seq")
	@SequenceGenerator(name = "facility_worker_type_id_seq", sequenceName = "facility_worker_type_id_seq", allocationSize = 1)
	private int id;
	
	@NotNull
	@Column(name = "name")
	private String name;
	
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
	
	public void setName(String name) {
		this.name = name;
	}
	
}
