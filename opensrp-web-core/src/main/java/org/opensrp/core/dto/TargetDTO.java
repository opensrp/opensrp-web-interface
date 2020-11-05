/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class TargetDTO {
	
	private Long id;
	
	private String targetTo;
	
	private int role;
	
	private String type;
	
	private Set<TargetDetailsDTO> targetDetailsDTOs;
	
	private int month;
	
	private int year;
	
	private int day;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getTargetTo() {
		return targetTo;
	}
	
	public void setTargetTo(String targetTo) {
		this.targetTo = targetTo;
	}
	
	public Set<TargetDetailsDTO> getTargetDetailsDTOs() {
		return targetDetailsDTOs;
	}
	
	public void setTargetDetailsDTOs(Set<TargetDetailsDTO> targetDetailsDTOs) {
		this.targetDetailsDTOs = targetDetailsDTOs;
	}
	
	public int getRole() {
		return role;
	}
	
	public void setRole(int role) {
		this.role = role;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public int getMonth() {
		return month;
	}
	
	public void setMonth(int month) {
		this.month = month;
	}
	
	public int getYear() {
		return year;
	}
	
	public void setYear(int year) {
		this.year = year;
	}
	
	public int getDay() {
		return day;
	}
	
	public void setDay(int day) {
		this.day = day;
	}
	
}
