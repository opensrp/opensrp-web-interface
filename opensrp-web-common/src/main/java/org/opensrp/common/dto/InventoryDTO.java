package org.opensrp.common.dto;

import java.util.Date;

import javax.persistence.Transient;

public class InventoryDTO {
	
	private Long id;
	
	private String branchName;
	
	private String branchCode;
	
	private String invoiceNumber;
	
	private String stockInId;
	
	private Date receiveDate;
	
	private String lastName;
	
	private String firstName;
	
	private String roleName;
	
	private String SKName;
	
	private float salesPrice;
	
	private int quantity;
	
	private float purchasePrice;
	
	private String productName;
	
	private String username;
	
	private Integer roleId;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getBranchName() {
		return branchName;
	}
	
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	
	public String getBranchCode() {
		return branchCode;
	}
	
	public void setBranchCode(String branchCode) {
		this.branchCode = branchCode;
	}
	
	public String getInvoiceNumber() {
		return invoiceNumber;
	}
	
	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber;
	}
	
	public String getStockInId() {
		return stockInId;
	}
	
	public void setStockInId(String stockInId) {
		this.stockInId = stockInId;
	}
	
	public Date getReceiveDate() {
		return receiveDate;
	}
	
	public void setReceiveDate(Date receiveDate) {
		this.receiveDate = receiveDate;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getRoleName() {
		return roleName;
	}
	
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	
	@Transient
	public String getFullName() {
		String fullName = "";
		if (lastName != null) {
			fullName = firstName + " " + lastName.replaceAll("\\.$", "");
		} else
			fullName = firstName;
		return fullName.trim();
	}
	
	@Transient
	public String getBranch() {
		String branch = "";
		
		branch = getBranchName() + " ( " + getBranchCode() + " )";
		
		return branch;
	}
	
	public String getSKName() {
		return SKName;
	}
	
	public void setSKName(String sKName) {
		SKName = sKName;
	}
	
	public float getSalesPrice() {
		return salesPrice;
	}
	
	public void setSalesPrice(float salesPrice) {
		this.salesPrice = salesPrice;
	}
	
	public float getPurchasePrice() {
		return purchasePrice;
	}
	
	public void setPurchasePrice(float purchasePrice) {
		this.purchasePrice = purchasePrice;
	}
	
	public int getQuantity() {
		return quantity;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public String getProductName() {
		return productName;
	}
	
	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Integer getRoleId() {
		return roleId;
	}

	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}

	@Override
	public String toString() {
		return "InventoryDTO [id=" + id + ", branchName=" + branchName + ", branchCode=" + branchCode + ", invoiceNumber="
		        + invoiceNumber + ", stockInId=" + stockInId + ", receiveDate=" + receiveDate + ", lastName=" + lastName
		        + ", firstName=" + firstName + "]";
	}
	
}
