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
@Table(name = "branch", schema = "core")
public class Branch implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "facility_id_seq")
	@SequenceGenerator(name = "facility_id_seq", sequenceName = "facility_id_seq", allocationSize = 1)
	private int id;
	
	@NotNull(message = "name can't be empty")
	@Column(name = "name")
	private String name;
	
	@NotNull(message = "code can't be empty")
	@Column(name = "code", unique = true, nullable = false)
	private String code;
	
	private Integer division;
	
	private Integer district;
	
	private Integer upazila;
	
	@Column(name = "sk_position")
	private Integer skPosition;
	
	@Column(name = "ss_position")
	private Integer ssPosition;
	
	@Column(name = "pa_position")
	private Integer paPosition;
	
	@Column(name = "pk_position")
	private Integer pkPosition;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
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
	
	public Integer getSkPosition() {
		return skPosition;
	}
	
	public void setSkPosition(Integer skPosition) {
		this.skPosition = skPosition;
	}
	
	public Integer getSsPosition() {
		return ssPosition;
	}
	
	public void setSsPosition(Integer ssPosition) {
		this.ssPosition = ssPosition;
	}
	
	public Integer getPaPosition() {
		return paPosition;
	}
	
	public void setPaPosition(Integer paPosition) {
		this.paPosition = paPosition;
	}
	
	public Integer getPkPosition() {
		return pkPosition;
	}
	
	public void setPkPosition(Integer pkPosition) {
		this.pkPosition = pkPosition;
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
	
	@Override
	public String toString() {
		return "Branch{" + "id=" + id + ", name='" + name + '\'' + ", code='" + code + '\'' + ", created=" + created
		        + ", updated=" + updated + '}';
	}
}
