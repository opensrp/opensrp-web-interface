package org.opensrp.core.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "union_wise_population", schema = "core")
public class UnionWisePopulation implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "union_wise_population_id_seq")
	@SequenceGenerator(name = "union_wise_population_id_seq", sequenceName = "union_wise_population_id_seq", allocationSize = 1)
	private Long id;
	
	@Column(name = "union_id")
	private int union;
	
	@Column(name = "population")
	private int population;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public int getUnion() {
		return union;
	}
	
	public void setUnion(int union) {
		this.union = union;
	}
	
	public int getPopulation() {
		return population;
	}
	
	public void setPopulation(int population) {
		this.population = population;
	}
	
}
