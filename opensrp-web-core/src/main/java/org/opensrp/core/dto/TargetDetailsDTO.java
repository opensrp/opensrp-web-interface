/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Date;

public class TargetDetailsDTO {
	
	private Long id;
	
	private Long productId;
	
	private String uuid;
	
	private int branchId;
	
	private Date endDate;
	
	private Date startDate;
	
	private String unit;
	
	private int quantity;
	
	private String percentage;
	
	private String status;
	
	private int userId;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	public int getBranchId() {
		return branchId;
	}
	
	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}
	
	public String getUnit() {
		return unit;
	}
	
	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public int getQuantity() {
		return quantity;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public String getPercentage() {
		return percentage;
	}
	
	public void setPercentage(String percentage) {
		this.percentage = percentage;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public int getUserId() {
		return userId;
	}
	
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public Long getProductId() {
		return productId;
	}
	
	public void setProductId(Long productId) {
		this.productId = productId;
	}
	
	public Date getEndDate() {
		return endDate;
	}
	
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	public Date getStartDate() {
		return startDate;
	}
	
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
}
