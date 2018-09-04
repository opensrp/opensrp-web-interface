package org.opensrp.facility.entity;


import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.UpdateTimestamp;
import org.json.JSONArray;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "facility", schema = "core")
public class Facility implements Serializable {

	private static final long serialVersionUID = 1L;

	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "facility_id_seq")
	@SequenceGenerator(name = "facility_id_seq", sequenceName = "facility_id_seq", allocationSize = 1)
	private int id;

	@NotNull
	@Column(name = "name")
	private String name;

	
	@NotNull
	@Column(name = "hrm_id")
	private String hrmId;

	@NotNull
	@Column(name = "latitude")
	private String latitude;
	
	@NotNull
	@Column(name = "longitude")
	private String longitude;

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

	public void setName(String name) {
		this.name = name;
	}

	public String getHrmId() {
		return hrmId;
	}

	public void setHrmId(String hrmId) {
		this.hrmId = hrmId;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;

		result = prime * result + id;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((hrmId == null) ? 0 : hrmId.hashCode());
		result = prime * result + ((latitude == null) ? 0 : latitude.hashCode());
		result = prime * result + ((longitude == null) ? 0 : longitude.hashCode());
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Facility other = (Facility) obj;

		if (id != other.id)
			return false;

		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;

		if (hrmId == null) {
			if (other.hrmId != null)
				return false;
		} else if (!hrmId.equals(other.hrmId))
			return false;

		if (latitude == null) {
			if (other.latitude != null)
				return false;
		} else if (!latitude.equals(other.latitude))
			return false;
		
		if (longitude == null) {
			if (other.longitude != null)
				return false;
		} else if (!longitude.equals(other.longitude))
			return false;

		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;

		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
			return false;

		return true;
	}

	@Override
	public String toString() {
		return "Facility" + " [" 
				+ "id=" + id
				+ ", name=" + name 
				+ ", hrmId=" + hrmId
				+ ", latitude=" + latitude 
				+ ", longitude=" + longitude 
				+ ", created=" + created 
				+ ", updated="+ updated 
				+ "]";
	}

}

