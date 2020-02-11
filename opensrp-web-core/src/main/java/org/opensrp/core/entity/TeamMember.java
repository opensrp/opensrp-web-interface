/**
 * @author proshanto (proshanto123@gmail.com)
 */
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

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "team_member", schema = "core")
public class TeamMember implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "team_member_id_seq")
	@SequenceGenerator(name = "team_member_id_seq", sequenceName = "team_member_id_seq", allocationSize = 1)
	private int id;
	
	@Column(name = "uuid")
	private String uuid;
	
	@Column(name = "identifier")
	private String identifier;
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "team_member_location", schema = "core", joinColumns = { @JoinColumn(name = "team_member_id") }, inverseJoinColumns = { @JoinColumn(name = "location_id") })
	private Set<Location> locations = new HashSet<Location>();
	
	@ManyToOne()
	@JoinColumn(name = "person_id", referencedColumnName = "id")
	private User person;
	
	@Column(name = "is_data_provider")
	private String isDataProvider;
	
	@ManyToOne()
	@JoinColumn(name = "team_id", referencedColumnName = "id")
	private Team team;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@ManyToOne()
	@JoinColumn(name = "creator_id", referencedColumnName = "id")
	private User creator;
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	public String getIdentifier() {
		return identifier;
	}
	
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	
	public Set<Location> getLocations() {
		return locations;
	}
	
	public void setLocations(Set<Location> locations) {
		this.locations = locations;
	}
	
	public User getPerson() {
		return person;
	}
	
	public void setPerson(User person) {
		this.person = person;
	}
	
	public String getIsDataProvider() {
		return isDataProvider;
	}
	
	public void setIsDataProvider(String isDataProvider) {
		this.isDataProvider = isDataProvider;
	}
	
	public Team getTeam() {
		return team;
	}
	
	public void setTeam(Team team) {
		this.team = team;
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
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result + ((creator == null) ? 0 : creator.hashCode());
		result = prime * result + id;
		result = prime * result + ((identifier == null) ? 0 : identifier.hashCode());
		result = prime * result + ((isDataProvider == null) ? 0 : isDataProvider.hashCode());
		result = prime * result + ((locations == null) ? 0 : locations.hashCode());
		result = prime * result + ((person == null) ? 0 : person.hashCode());
//		result = prime * result + ((team == null) ? 0 : team.hashCode());
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
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
		TeamMember other = (TeamMember) obj;
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
		if (id != other.id)
			return false;
		if (identifier == null) {
			if (other.identifier != null)
				return false;
		} else if (!identifier.equals(other.identifier))
			return false;
		if (isDataProvider == null) {
			if (other.isDataProvider != null)
				return false;
		} else if (!isDataProvider.equals(other.isDataProvider))
			return false;
		if (locations == null) {
			if (other.locations != null)
				return false;
		} else if (!locations.equals(other.locations))
			return false;
		if (person == null) {
			if (other.person != null)
				return false;
		} else if (!person.equals(other.person))
			return false;
		if (team == null) {
			if (other.team != null)
				return false;
		} else if (!team.equals(other.team))
			return false;
		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
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
		return "TeamMember [id=" + id + ", uuid=" + uuid + ", identifier=" + identifier + ", locations=" + locations
		        + ", person=" + person + ", isDataProvider=" + isDataProvider + ", team=" + team + ", created=" + created
		        + ", updated=" + updated + ", creator=" + creator + "]";
	}
	
}
