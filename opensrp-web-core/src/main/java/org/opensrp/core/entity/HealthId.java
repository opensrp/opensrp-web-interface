package org.opensrp.core.entity;

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

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "health_id", schema = "core")
public class HealthId {
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "health_id_seq")
	@SequenceGenerator(name = "health_id_seq", sequenceName = "health_id_seq", allocationSize = 1)
	private int id;
	
	@Column(name = "h_id")
	private String hId;
	
	@Column(name = "type")
	private String type;
	
	@Column(name = "status")
	private Boolean status = false;

	@Column(name = "location_id")
	private int locationId;

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

	
    public String gethId() {
    	return hId;
    }

	
    public void sethId(String hId) {
    	this.hId = hId;
    }

	
    public String getType() {
    	return type;
    }

	
    public void setType(String type) {
    	this.type = type;
    }

	
    public Boolean getStatus() {
    	return status;
    }

	
    public void setStatus(Boolean status) {
    	this.status = status;
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

	public int getLocationId() {
		return locationId;
	}

	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}

	@Override
    public int hashCode() {
	    final int prime = 31;
	    int result = 1;
	    result = prime * result + ((created == null) ? 0 : created.hashCode());
	    result = prime * result + ((hId == null) ? 0 : hId.hashCode());
	    result = prime * result + id;
	    result = prime * result + ((status == null) ? 0 : status.hashCode());
	    result = prime * result + ((type == null) ? 0 : type.hashCode());
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
	    HealthId other = (HealthId) obj;
	    if (created == null) {
		    if (other.created != null)
			    return false;
	    } else if (!created.equals(other.created))
		    return false;
	    if (hId == null) {
		    if (other.hId != null)
			    return false;
	    } else if (!hId.equals(other.hId))
		    return false;
	    if (id != other.id)
		    return false;
	    if (status == null) {
		    if (other.status != null)
			    return false;
	    } else if (!status.equals(other.status))
		    return false;
	    if (type == null) {
		    if (other.type != null)
			    return false;
	    } else if (!type.equals(other.type))
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
	    return "HealthId [id=" + id + ", hId=" + hId + ", type=" + type + ", status=" + status + ", created=" + created
	            + ", updated=" + updated + "]";
    }
	
	
}
