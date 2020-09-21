package org.opensrp.core.dto;

import java.util.Date;

public class StockAdjustDTO {

	private Long id;
	
	private Long productId;
	
	private int branchId;
	
	private Date adjustDate;
	
	private int currentStock;
	
	private int changedStock;
	
	private String adjustReason;
	
	private int month;
	
	private int year;

	public Long getId() {
		return id;
	}

	public Long getProductId() {
		return productId;
	}

	public int getBranchId() {
		return branchId;
	}

	public Date getAdjustDate() {
		return adjustDate;
	}

	public int getCurrentStock() {
		return currentStock;
	}

	public int getChangedStock() {
		return changedStock;
	}

	public String getAdjustReason() {
		return adjustReason;
	}

	public int getMonth() {
		return month;
	}

	public int getYear() {
		return year;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setProductId(Long productId) {
		this.productId = productId;
	}

	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}

	public void setAdjustDate(Date adjustDate) {
		this.adjustDate = adjustDate;
	}

	public void setCurrentStock(int currentStock) {
		this.currentStock = currentStock;
	}

	public void setChangedStock(int changedStock) {
		this.changedStock = changedStock;
	}

	public void setAdjustReason(String adjustReason) {
		this.adjustReason = adjustReason;
	}

	public void setMonth(int month) {
		this.month = month;
	}

	public void setYear(int year) {
		this.year = year;
	}
	
}
