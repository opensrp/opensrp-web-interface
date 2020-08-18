/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Set;

import java.util.Date;

public class StockDTO {
	
	private Long id;
	
	private Set<StockDetailsDTO> stockDetailsDTOs;
	
	private Set<Integer> sellTo;
	
	private String stockId;
	
	private int productId;
	
	private int credit;
	
	private int debit;
	
	private String uuid;
	
	private int branchId;
	
	private Date date;
	
	private String referenceType;
	
	private String status;
	
	private int sellOrPassTo;
	
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
	
	public int getProductId() {
		return productId;
	}
	
	public void setProductId(int productId) {
		this.productId = productId;
	}
	
	public int getCredit() {
		return credit;
	}
	
	public void setCredit(int credit) {
		this.credit = credit;
	}
	
	public int getDebit() {
		return debit;
	}
	
	public void setDebit(int debit) {
		this.debit = debit;
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
	
	public Date getDate() {
		return date;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	
	public String getReferenceType() {
		return referenceType;
	}
	
	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public int getSellOrPassTo() {
		return sellOrPassTo;
	}
	
	public void setSellOrPassTo(int sellOrPassTo) {
		this.sellOrPassTo = sellOrPassTo;
>>>>>>> 52e8cda68fc7e23441b5ed5c3ab16f0ef5efd93e
	}
}
