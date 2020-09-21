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
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "_stock_adjust", schema = "core")
public class StockAdjust implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "stock_adjust_id_seq")
	@SequenceGenerator(name="stock_adjust_id_seq", sequenceName = "stock_adjust_id_seq", allocationSize=1)
	private Long id;
	
	@Column(name = "product_id")
	private Long productId;
	
	
	@Column(name = "month")
	private int month;
	
	@Column(name = "year")
	private int year;
	
	
	@Column(name = "branch_id")
	private int branchId;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "adjust_date")
	private Date adjustDate;
	
	@Column(name = "current_stock")
	private int currentStock;

	
	@Column(name = "changed_stock")
	private int changedStock;

	
	@Column(name = "adjust_reason")
	private String adjustReason;
	
	@Column(name = "creator")
	private int creator;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();

	public Long getId() {
		return id;
	}

	public Long getProductId() {
		return productId;
	}

	public int getMonth() {
		return month;
	}

	public int getYear() {
		return year;
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

	public int getCreator() {
		return creator;
	}

	public Date getCreated() {
		return created;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setProductId(Long productId) {
		this.productId = productId;
	}

	public void setMonth(int month) {
		this.month = month;
	}

	public void setYear(int year) {
		this.year = year;
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

	public void setCreator(int creator) {
		this.creator = creator;
	}

	public void setCreated(Date created) {
		this.created = created;
	}


	
}
