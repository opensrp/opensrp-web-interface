/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

public class RequisitionDetailsDTO {
	
	private Long productId;
	
	private int currentStock;
	
	private int qunatity;
	
	public Long getProductId() {
		return productId;
	}
	
	public void setProductId(Long productId) {
		this.productId = productId;
	}
	
	public int getCurrentStock() {
		return currentStock;
	}
	
	public void setCurrentStock(int currentStock) {
		this.currentStock = currentStock;
	}
	
	public int getQunatity() {
		return qunatity;
	}
	
	public void setQunatity(int qunatity) {
		this.qunatity = qunatity;
	}
	
}
