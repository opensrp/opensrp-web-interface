package org.opensrp.core.entity;

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
@Table(name = "duplicate_matching_criteria_definition", schema = "core")
public class SimilarityMatchingCriteriaDefinition implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "dup_matching_criteria_def_id_seq")
	@SequenceGenerator(name = "dup_matching_criteria_def_id_seq", sequenceName = "dup_matching_criteria_def_id_seq", allocationSize = 1)
	private int id;
	
	@NotNull
	@Column(name = "view_name")
	private String viewName;
	
	@NotNull
	@Column(name = "matching_keys")
	private String matchingKeys;
	
	@NotNull
	@Column(name = "status")
	private Boolean status;
	
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
	
	public String getViewName() {
		return viewName;
	}
	
	public void setViewName(String viewName) {
		this.viewName = viewName;
	}
	
	public String getMatchingKeys() {
		return matchingKeys;
	}
	
	public void setMatchingKeys(String matchingKeys) {
		this.matchingKeys = matchingKeys;
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
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		
		result = prime * result + id;
		result = prime * result + ((viewName == null) ? 0 : viewName.hashCode());
		result = prime * result + ((matchingKeys == null) ? 0 : matchingKeys.hashCode());
		result = prime * result + ((status == null) ? 0 : status.hashCode());
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
		
		SimilarityMatchingCriteriaDefinition other = (SimilarityMatchingCriteriaDefinition) obj;
		
		if (id != other.id)
			return false;
		
		if (viewName == null) {
			if (other.viewName != null)
				return false;
		} else if (!viewName.equals(other.viewName))
			return false;
		
		if (matchingKeys == null) {
			if (other.matchingKeys != null)
				return false;
		} else if (!matchingKeys.equals(other.matchingKeys))
			return false;
		
		if (status == null) {
			if (other.status != null)
				return false;
		} else if (!status.equals(other.status))
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
		return "SimilarityMatchingCriteriaDefinition" + " [" + "id=" + id + ", viewName=" + viewName + ", matchingKeys="
		        + matchingKeys + ", status=" + status + ", created=" + created + ", updated=" + updated + "]";
	}
}
