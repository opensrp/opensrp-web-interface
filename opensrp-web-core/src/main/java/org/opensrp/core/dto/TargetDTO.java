/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class TargetDTO {
	
	private Long id;
	
	private int targetTo;
	
	private int role;
	
	private String type;
	
	private Set<TargetDetailsDTO> targetDetailsDTOs;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public int getTargetTo() {
		return targetTo;
	}
	
	public void setTargetTo(int targetTo) {
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
	
}
