package org.opensrp.core.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "blc", schema = "core")
public class BLC implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "blc_id_seq")
	@SequenceGenerator(name = "blc_id_seq", sequenceName = "blc_id_seq", allocationSize = 1)
	private int id;
	
	@NotNull(message = "name can't be empty")
	@Column(name = "name")
	private String name;
	
	@Column(name = "code", unique = true, nullable = false)
	private String code;
	
	@Column(name = "division_id")
	private int division;
	
	@Column(name = "district_id")
	private int district;
	
	@Column(name = "upazila_id")
	private int upazila;
	
	public int getId() {
		return id;
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
	
	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public int getDivision() {
		return division;
	}
	
	public void setDivision(int division) {
		this.division = division;
	}
	
	public int getDistrict() {
		return district;
	}
	
	public void setDistrict(int district) {
		this.district = district;
	}
	
	public int getUpazila() {
		return upazila;
	}
	
	public void setUpazila(int upazila) {
		this.upazila = upazila;
	}
	
}
