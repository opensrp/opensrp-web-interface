/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "role", schema = "core")
public class Role implements GrantedAuthority {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "role_id_seq")
	@SequenceGenerator(name = "role_id_seq", sequenceName = "role_id_seq", allocationSize = 1)
	private int id;
	
	@NotEmpty(message = "Role name can't be empty")
	@Column(name = "name")
	private String name;
	
	@Column(name = "uuid")
	private String uuid;
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "role_permission", schema = "core", joinColumns = { @JoinColumn(name = "role_id") }, inverseJoinColumns = { @JoinColumn(name = "permission_id") })
	private Set<Permission> permissions = new HashSet<Permission>();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@ManyToOne(cascade = CascadeType.ALL,fetch = FetchType.LAZY)
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	@Column(name = "IS_ACTIVE")
	private boolean active = true;
	
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
	
	public Set<Permission> getPermissions() {
		return permissions;
	}
	
	public void setPermissions(Set<Permission> permissions) {
		this.permissions = permissions;
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
	
	@Override
	@Transient
	public String getAuthority() {
		return name;
	}
	
	public boolean isActive() {
		return active;
	}
	
	public void setActive(boolean active) {
		this.active = active;
	}
	
	
	
}
