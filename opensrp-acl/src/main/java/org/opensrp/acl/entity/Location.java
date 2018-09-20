/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
@Table(name = "location", schema = "core")
public class Location implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "location_id_seq")
	@SequenceGenerator(name = "location_id_seq", sequenceName = "location_id_seq", allocationSize = 1)
	private int id;
	
	@NotEmpty(message = "location name can't be empty")
	@Column(name = "name")
	private String name;
	
	@Column(name = "description")
	private String description;
	
	@Column(name = "uuid")
	private String uuid;
	
	@Column(name = "code")
	private String code;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@ManyToOne()
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	@ManyToOne()
	@JoinColumn(name = "parent_location_id", referencedColumnName = "id")
	private Location parentLocation;
	
	@ManyToOne()
	@JoinColumn(name = "location_tag_id", referencedColumnName = "id")
	private LocationTag locationTag;
	
	public int getId() {
		return id;
		
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
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
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	public Location getParentLocation() {
		return parentLocation;
	}
	
	public void setParentLocation(Location parentLocation) {
		this.parentLocation = parentLocation;
	}
	
	public LocationTag getLocationTag() {
		return locationTag;
	}
	
	public void setLocationTag(LocationTag locationTag) {
		this.locationTag = locationTag;
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
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
}
