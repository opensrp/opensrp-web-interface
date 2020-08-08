/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class TargetDTO {
	
	private Long id;
	
	private Set<Integer> targetTo;
	
	private Set<TargetDetailsDTO> targetDetailsDTOs;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Set<Integer> getTargetTo() {
		return targetTo;
	}
	
	public void setTargetTo(Set<Integer> targetTo) {
		this.targetTo = targetTo;
	}
	
	public Set<TargetDetailsDTO> getTargetDetailsDTOs() {
		return targetDetailsDTOs;
	}
	
	public void setTargetDetailsDTOs(Set<TargetDetailsDTO> targetDetailsDTOs) {
		this.targetDetailsDTOs = targetDetailsDTOs;
	}
	
}
