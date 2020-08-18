/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.util.Collection;
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
import javax.persistence.NamedQuery;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "users", schema = "core")
@NamedQuery(name = "account.byUsername", query = "from User a where a.username = :username")
public class User implements UserDetails {
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_id_seq")
	@SequenceGenerator(name = "user_id_seq", sequenceName = "user_id_seq", allocationSize = 1)
	private Integer id;
	
	//@NotNull
	
	@NotEmpty(message = "username can't be empty")
	@Column(name = "username", unique = true, nullable = false)
	private String username;
	
	@Column(name = "uuid")
	private String uuid;
	
	@Column(name = "first_name")
	private String firstName;
	
	@Column(name = "last_name")
	private String lastName;
	
	@Column(name = "email")
	private String email;
	
	@NotEmpty
	//@Size(min = 4, max = 20, message = "Password must be between 4 and 20 characters")
	@Column(name = "password")
	private String password;
	
	@Column(name = "retype_password")
	@Transient
	private String retypePassword;
	
	@Column(name = "enabled")
	private boolean enabled;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "user_role", schema = "core", joinColumns = { @JoinColumn(name = "user_id") }, inverseJoinColumns = { @JoinColumn(name = "role_id") })
	private Set<Role> roles = new HashSet<Role>();
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "user_branch", schema = "core", joinColumns = { @JoinColumn(name = "user_id") }, inverseJoinColumns = { @JoinColumn(name = "branch_id") })
	private Set<Branch> branches = new HashSet<>();
	
	@ManyToOne(cascade = CascadeType.ALL,fetch = FetchType.LAZY)
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	private String gender;
	
	private String mobile;
	
	private String idetifier;
	
	@Column(name = "provider", columnDefinition = "boolean default false")
	private boolean provider;
	
	@Column(name = "person_uuid")
	public String personUUid;
	
	@ManyToOne(cascade = CascadeType.MERGE,fetch = FetchType.EAGER)
	@JoinColumn(name = "parent_user_id", referencedColumnName = "id")
	private User parentUser;
	
	@Column(name = "chcp")
	private String chcp;
	
	@Column(name = "enable_sim_print")
	private Boolean enableSimPrint;
	
	@Column(name = "ss_no")
	private String ssNo;

	@Column(name = "app_version")
	private String appVersion;

	public User() {
	}
	
	public boolean isProvider() {
		return provider;
	}
	
	public void setProvider(boolean provider) {
		this.provider = provider;
	}
	
	public String getPersonUUid() {
		return personUUid;
	}
	
	public void setPersonUUid(String personUUid) {
		this.personUUid = personUUid;
	}
	
	public User(String username) {
		this.username = username;
	}
	
	public int getId() {
		return id;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	@Transient
	public String getFullName() {
		String fullName = "";
		if (lastName != null) {
			fullName = firstName + " " + lastName.replaceAll("\\.$", "");
		} else fullName = firstName;
		return fullName.trim();
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getRetypePassword() {
		return retypePassword;
	}
	
	public void setRetypePassword(String retypePassword) {
		this.retypePassword = retypePassword;
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	@Transient
	public boolean isAccountNonExpired() {
		return true;
	}
	
	@Transient
	public boolean isAccountNonLocked() {
		return true;
	}
	
	@Transient
	public boolean isCredentialsNonExpired() {
		return true;
	}
	
	public boolean isEnabled() {
		return enabled;
	}
	
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	public Set<Role> getRoles() {
		return roles;
	}
	
	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getMobile() {
		return mobile;
	}
	
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public String getIdetifier() {
		return idetifier;
	}
	
	public void setIdetifier(String idetifier) {
		this.idetifier = idetifier;
	}
	
	public User getParentUser() {
		return parentUser;
	}
	
	public void setParentUser(User parentUser) {
		this.parentUser = parentUser;
	}
	
	public String getChcp() {
		return chcp;
	}
	
	public void setChcp(String chcp) {
		this.chcp = chcp;
	}
	
	public Set<Branch> getBranches() {
		return branches;
	}
	
	public void setBranches(Set<Branch> branches) {
		this.branches = branches;
	}
	
	public Boolean getEnableSimPrint() {
		return enableSimPrint;
	}
	
	public void setEnableSimPrint(Boolean enableSimPrint) {
		this.enableSimPrint = enableSimPrint;
	}
	
	public String getSsNo() {
		return ssNo;
	}
	
	public void setSsNo(String ssNo) {
		this.ssNo = ssNo;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}

	@Transient
	public Set<Permission> getPermissions() {
		Set<Permission> perms = new HashSet<Permission>();
		for (Role role : roles) {
			perms.addAll(role.getPermissions());
		}
		return perms;
	}
	
	@Transient
	public Collection<GrantedAuthority> getAuthorities() {
		Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
		authorities.addAll(getRoles());
		authorities.addAll(getPermissions());
		return authorities;
	}
	
	
	
}
