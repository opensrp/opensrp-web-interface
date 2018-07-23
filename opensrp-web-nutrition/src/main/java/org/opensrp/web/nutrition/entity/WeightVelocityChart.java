/**
 * 
 */
package org.opensrp.web.nutrition.entity;

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

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */

@Entity
@Service
@Table(name = "weight_velocity_chart", schema = "core")
public class WeightVelocityChart implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "weight_velocity_chart_id_seq")
	@SequenceGenerator(name = "weight_velocity_chart_id_seq", sequenceName = "weight_velocity_chart_id_seq", allocationSize = 1)
	private int id;
	
	private int intervals;
	
	private int age;
	
	@Column(name = "male_weight")
	private double maleWeight;
	
	@Column(name = "female_weight")
	private double femaleWeight;
	
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
	
	public int getIntervals() {
		return intervals;
	}
	
	public void setIntervals(int intervals) {
		this.intervals = intervals;
	}
	
	public int getAge() {
		return age;
	}
	
	public void setAge(int age) {
		this.age = age;
	}
	
	public double getMaleWeight() {
		return maleWeight;
	}
	
	public void setMaleWeight(int maleWeight) {
		this.maleWeight = maleWeight;
	}
	
	public double getFemaleWeight() {
		return femaleWeight;
	}
	
	public void setFemaleWeight(int femaleWeight) {
		this.femaleWeight = femaleWeight;
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
		result = prime * result + age;
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		long temp;
		temp = Double.doubleToLongBits(femaleWeight);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + id;
		result = prime * result + intervals;
		temp = Double.doubleToLongBits(maleWeight);
		result = prime * result + (int) (temp ^ (temp >>> 32));
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
		WeightVelocityChart other = (WeightVelocityChart) obj;
		if (age != other.age)
			return false;
		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;
		if (Double.doubleToLongBits(femaleWeight) != Double.doubleToLongBits(other.femaleWeight))
			return false;
		if (id != other.id)
			return false;
		if (intervals != other.intervals)
			return false;
		if (Double.doubleToLongBits(maleWeight) != Double.doubleToLongBits(other.maleWeight))
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
		return "WeightVelocityChart [id=" + id + ", intervals=" + intervals + ", age=" + age + ", maleWeight=" + maleWeight
		        + ", femaleWeight=" + femaleWeight + ", created=" + created + ", updated=" + updated + "]";
	}
	
}
