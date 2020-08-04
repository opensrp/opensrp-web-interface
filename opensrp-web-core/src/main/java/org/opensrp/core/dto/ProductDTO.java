/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

public class ProductDTO {
	
	private Long id;
	
	private String name;
	
	private String description;
	
	private float purchasePrice;
	
	private float sellingPrice;
	
	private int sellTo;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public float getPurchasePrice() {
		return purchasePrice;
	}
	
	public void setPurchasePrice(float purchasePrice) {
		this.purchasePrice = purchasePrice;
	}
	
	public float getSellingPrice() {
		return sellingPrice;
	}
	
	public void setSellingPrice(float sellingPrice) {
		this.sellingPrice = sellingPrice;
	}
	
	public int getSellTo() {
		return sellTo;
	}
	
	public void setSellTo(int sellTo) {
		this.sellTo = sellTo;
	}
	
}
