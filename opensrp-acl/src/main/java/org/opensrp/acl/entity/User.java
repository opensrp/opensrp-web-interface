/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.acl.entity;

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
	
	@NotEmpty(message = "email can't be empty")
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
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	private String gender;
	
	private String mobile;
	
	private String idetifier;
	
	@Column(name = "provider", columnDefinition = "boolean default false")
	private boolean provider;
	
	@Column(name = "person_uuid")
	public String personUUid;
	@ManyToOne()
	@JoinColumn(name = "parent_user_id", referencedColumnName = "id")
	private User parentUser;
	
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
		return firstName + " " + lastName;
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result + ((creator == null) ? 0 : creator.hashCode());
		result = prime * result + ((email == null) ? 0 : email.hashCode());
		result = prime * result + (enabled ? 1231 : 1237);
		result = prime * result
				+ ((firstName == null) ? 0 : firstName.hashCode());
		result = prime * result + ((gender == null) ? 0 : gender.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result
				+ ((idetifier == null) ? 0 : idetifier.hashCode());
		result = prime * result
				+ ((lastName == null) ? 0 : lastName.hashCode());
		result = prime * result + ((mobile == null) ? 0 : mobile.hashCode());
		result = prime * result
				+ ((parentUser == null) ? 0 : parentUser.hashCode());
		result = prime * result
				+ ((password == null) ? 0 : password.hashCode());
		result = prime * result
				+ ((personUUid == null) ? 0 : personUUid.hashCode());
		result = prime * result + (provider ? 1231 : 1237);
		result = prime * result
				+ ((retypePassword == null) ? 0 : retypePassword.hashCode());
		result = prime * result + ((roles == null) ? 0 : roles.hashCode());
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
		result = prime * result
				+ ((username == null) ? 0 : username.hashCode());
		result = prime * result + ((uuid == null) ? 0 : uuid.hashCode());
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
		User other = (User) obj;
		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;
		if (creator == null) {
			if (other.creator != null)
				return false;
		} else if (!creator.equals(other.creator))
			return false;
		if (email == null) {
			if (other.email != null)
				return false;
		} else if (!email.equals(other.email))
			return false;
		if (enabled != other.enabled)
			return false;
		if (firstName == null) {
			if (other.firstName != null)
				return false;
		} else if (!firstName.equals(other.firstName))
			return false;
		if (gender == null) {
			if (other.gender != null)
				return false;
		} else if (!gender.equals(other.gender))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (idetifier == null) {
			if (other.idetifier != null)
				return false;
		} else if (!idetifier.equals(other.idetifier))
			return false;
		if (lastName == null) {
			if (other.lastName != null)
				return false;
		} else if (!lastName.equals(other.lastName))
			return false;
		if (mobile == null) {
			if (other.mobile != null)
				return false;
		} else if (!mobile.equals(other.mobile))
			return false;
		if (parentUser == null) {
			if (other.parentUser != null)
				return false;
		} else if (!parentUser.equals(other.parentUser))
			return false;
		if (password == null) {
			if (other.password != null)
				return false;
		} else if (!password.equals(other.password))
			return false;
		if (personUUid == null) {
			if (other.personUUid != null)
				return false;
		} else if (!personUUid.equals(other.personUUid))
			return false;
		if (provider != other.provider)
			return false;
		if (retypePassword == null) {
			if (other.retypePassword != null)
				return false;
		} else if (!retypePassword.equals(other.retypePassword))
			return false;
		if (roles == null) {
			if (other.roles != null)
				return false;
		} else if (!roles.equals(other.roles))
			return false;
		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
			return false;
		if (username == null) {
			if (other.username != null)
				return false;
		} else if (!username.equals(other.username))
			return false;
		if (uuid == null) {
			if (other.uuid != null)
				return false;
		} else if (!uuid.equals(other.uuid))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", username=" + username + ", uuid=" + uuid
				+ ", firstName=" + firstName + ", lastName=" + lastName
				+ ", email=" + email + ", password=" + password
				+ ", retypePassword=" + retypePassword + ", enabled=" + enabled
				+ ", created=" + created + ", updated=" + updated + ", roles="
				+ roles + ", creator=" + creator + ", gender=" + gender
				+ ", mobile=" + mobile + ", idetifier=" + idetifier
				+ ", provider=" + provider + ", personUUid=" + personUUid
				+ ", parentUser=" + parentUser + "]";
	}
	
}
