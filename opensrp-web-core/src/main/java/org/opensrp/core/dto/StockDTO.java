/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class StockDTO {
	
	private Long id;
	
	private Set<StockDetailsDTO> stockDetailsDTOs;
	
	private Set<Integer> sellTo;
	
	private String referenceType;
	
	private String stockId;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Set<StockDetailsDTO> getStockDetailsDTOs() {
		return stockDetailsDTOs;
	}
	
	public void setStockDetailsDTOs(Set<StockDetailsDTO> stockDetailsDTOs) {
		this.stockDetailsDTOs = stockDetailsDTOs;
	}
	
	public Set<Integer> getSellTo() {
		return sellTo;
	}
	
	public void setSellTo(Set<Integer> sellTo) {
		this.sellTo = sellTo;
	}
	
	public String getStockId() {
		return stockId;
	}
	
	public void setStockId(String stockId) {
		this.stockId = stockId;
	}
	
	public String getReferenceType() {
		return referenceType;
	}
	
	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}
	
}
