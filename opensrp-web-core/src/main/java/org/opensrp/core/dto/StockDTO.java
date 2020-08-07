/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

public class StockDTO {
	
	private Long id;
	
	private Set<StockDetailsDTO> stockDetailsDTOs;
	
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
	
}
