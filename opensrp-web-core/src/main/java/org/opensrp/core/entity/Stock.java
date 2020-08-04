/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "_stock", schema = "core")
public class Stock implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "_stock_id_seq")
	@SequenceGenerator(name = "_stock_id_seq", sequenceName = "_stock_id_seq", allocationSize = 1)
	private Long id;
	
	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "product_id", referencedColumnName = "id")
	private Product productId;
	
	private int credit;
	
	private int debit;
	
	private String uuid;
	
	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "branch_id", referencedColumnName = "id")
	private Branch branchId;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "expirey_date")
	private Date expireyDate;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "receive_date")
	private Date receiveDate;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "date")
	private Date date;
	
	@Column(name = "division_id")
	private int divisionId;
	
	@Column(name = "district_id")
	private int districtId;
	
	@Column(name = "upazila_id")
	private int upazilaId;
	
	@Column(name = "reference_type")
	private String referenceType;
	
	private Long timestamp;
	
	private String status;
	
	@Column(name = "sell_or_pass_to")
	private int sellOrPassTo;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	public Long getId() {
		return id;
		
	}
	
	public String getUuid() {
		return uuid;
	}
	
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public void setCreated() {
		this.created = new Date();
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void setUpdated() {
		this.updated = new Date();
	}
	
	public Long getTimestamp() {
		return timestamp;
	}
	
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	public Branch getBranchId() {
		return branchId;
	}
	
	public void setBranchId(Branch branchId) {
		this.branchId = branchId;
	}
	
	public Product getProductId() {
		return productId;
	}
	
	public void setProductId(Product productId) {
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
	
	public Date getExpireyDate() {
		return expireyDate;
	}
	
	public void setExpireyDate(Date expireyDate) {
		this.expireyDate = expireyDate;
	}
	
	public Date getReceiveDate() {
		return receiveDate;
	}
	
	public void setReceiveDate(Date receiveDate) {
		this.receiveDate = receiveDate;
	}
	
	public int getDivisionId() {
		return divisionId;
	}
	
	public void setDivisionId(int divisionId) {
		this.divisionId = divisionId;
	}
	
	public int getDistrictId() {
		return districtId;
	}
	
	public void setDistrictId(int districtId) {
		this.districtId = districtId;
	}
	
	public int getUpazilaId() {
		return upazilaId;
	}
	
	public void setUpazilaId(int upazilaId) {
		this.upazilaId = upazilaId;
	}
	
	public String getReferenceType() {
		return referenceType;
	}
	
	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}
	
	public int getSellOrPassTo() {
		return sellOrPassTo;
	}
	
	public void setSellOrPassTo(int sellOrPassTo) {
		this.sellOrPassTo = sellOrPassTo;
	}
	
}
