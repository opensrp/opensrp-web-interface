/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

public class RequisitionDTO {
	
	private Long id;
	
	private int productId;
	
	private int currentStock;
	
	private int qunatity;
	
	private int branchId;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public int getProductId() {
		return productId;
	}
	
	public void setProductId(int productId) {
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
	
	public int getBranchId() {
		return branchId;
	}
	
	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}
	
}
