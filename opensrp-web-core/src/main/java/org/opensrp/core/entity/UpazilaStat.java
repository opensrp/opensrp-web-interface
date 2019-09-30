package org.opensrp.core.entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

@Service
@Entity
@Table(name = "upazila_stat", schema = "core")
public class UpazilaStat implements Serializable {

	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "upazila_stat_id_seq")
	@SequenceGenerator(name = "upazila_stat_id_seq", sequenceName = "upazila_stat_id_seq", allocationSize = 1)
	private int id;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();

	@OneToOne()
	private Location upazila;

	@Column(name ="total_cc")
	private Integer totalCC;

	@Column(name ="total_mhv")
	private Integer totalMHV;

	@Column(name = "targeted_population")
	private Integer targetedPopulation;

	@Column(name = "collected_population")
	private Integer collectedPopulation;

	@Column(name = "targeted_household")
	private Integer targetedHousehold;

	@Column(name = "collected_household")
	private Integer collectedHousehold;

	@Column(name = "total_prima_cc")
	private Integer totalPrimaCC;

	@Column(name = "total_prima_mhv")
	private Integer totalPrimaMHV;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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

	public Location getUpazila() {
		return upazila;
	}

	public void setUpazila(Location upazila) {
		this.upazila = upazila;
	}

	public Integer getTotalCC() {
		return totalCC;
	}

	public void setTotalCC(Integer totalCC) {
		this.totalCC = totalCC;
	}

	public Integer getTotalMHV() {
		return totalMHV;
	}

	public void setTotalMHV(Integer totalMHV) {
		this.totalMHV = totalMHV;
	}

	public Integer getTargetedPopulation() {
		return targetedPopulation;
	}

	public void setTargetedPopulation(Integer targetedPopulation) {
		this.targetedPopulation = targetedPopulation;
	}

	public Integer getCollectedPopulation() {
		return collectedPopulation;
	}

	public void setCollectedPopulation(Integer collectedPopulation) {
		this.collectedPopulation = collectedPopulation;
	}

	public Integer getTargetedHousehold() {
		return targetedHousehold;
	}

	public void setTargetedHousehold(Integer targetedHousehold) {
		this.targetedHousehold = targetedHousehold;
	}

	public Integer getCollectedHousehold() {
		return collectedHousehold;
	}

	public void setCollectedHousehold(Integer collectedHousehold) {
		this.collectedHousehold = collectedHousehold;
	}

	public Integer getTotalPrimaCC() {
		return totalPrimaCC;
	}

	public void setTotalPrimaCC(Integer totalPrimaCC) {
		this.totalPrimaCC = totalPrimaCC;
	}

	public Integer getTotalPrimaMHV() {
		return totalPrimaMHV;
	}

	public void setTotalPrimaMHV(Integer totalPrimaMHV) {
		this.totalPrimaMHV = totalPrimaMHV;
	}
}
