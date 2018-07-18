/**
 * 
 */
package org.opensrp.web.nutrition.entity;

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

/**
 * @author proshanto
 */

@Entity
@Service
@Table(name = "child_growth", schema = "core")
public class ChildGrowth {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "child_growth_id_seq")
	@SequenceGenerator(name = "child_growth_id_seq", sequenceName = "child_growth_id_seq", allocationSize = 1)
	private int id;
	
	private String baseEntityId;
	
	private int age;
	
	private double weight;
	
	@Column(name = "growth_status")
	private boolean growthStatus;
	
	@Column(name = "z_score")
	private double zScore;
	
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
	
	public String getBaseEntityId() {
		return baseEntityId;
	}
	
	public void setBaseEntityId(String baseEntityId) {
		this.baseEntityId = baseEntityId;
	}
	
	public int getAge() {
		return age;
	}
	
	public void setAge(int age) {
		this.age = age;
	}
	
	public double getWeight() {
		return weight;
	}
	
	public void setWeight(double weight) {
		this.weight = weight;
	}
	
	public boolean isGrowthStatus() {
		return growthStatus;
	}
	
	public void setGrowthStatus(boolean growthStatus) {
		this.growthStatus = growthStatus;
	}
	
	public double getzScore() {
		return zScore;
	}
	
	public void setzScore(double zScore) {
		this.zScore = zScore;
	}
	
	public void setCreated(Date created) {
		this.created = created;
	}
	
	public void setUpdated(Date updated) {
		this.updated = updated;
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
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((baseEntityId == null) ? 0 : baseEntityId.hashCode());
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result + (growthStatus ? 1231 : 1237);
		result = prime * result + id;
		result = prime * result + age;
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
		long temp;
		temp = Double.doubleToLongBits(weight);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(zScore);
		result = prime * result + (int) (temp ^ (temp >>> 32));
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
		ChildGrowth other = (ChildGrowth) obj;
		if (baseEntityId == null) {
			if (other.baseEntityId != null)
				return false;
		} else if (!baseEntityId.equals(other.baseEntityId))
			return false;
		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;
		if (growthStatus != other.growthStatus)
			return false;
		if (id != other.id)
			return false;
		if (age != other.age)
			return false;
		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
			return false;
		if (Double.doubleToLongBits(weight) != Double.doubleToLongBits(other.weight))
			return false;
		if (Double.doubleToLongBits(zScore) != Double.doubleToLongBits(other.zScore))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "ChildGrowth [id=" + id + ", baseEntityId=" + baseEntityId + ", age=" + age + ", weight=" + weight
		        + ", growthStatus=" + growthStatus + ", zScore=" + zScore + ", created=" + created + ", updated=" + updated
		        + "]";
	}
	
}
