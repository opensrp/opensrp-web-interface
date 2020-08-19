/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
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
	
	@OneToMany(mappedBy = "stock", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Set<StockDetails> stockDetails = new HashSet<StockDetails>();
	
	private String uuid;
	
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
	
	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "updated_by", referencedColumnName = "id")
	private User updatedBy;
	
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
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	public Set<StockDetails> getStockDetails() {
		return stockDetails;
	}
	
	public void setStockDetails(Set<StockDetails> stockDetails) {
		this.stockDetails = stockDetails;
	}
	
	public User getUpdatedBy() {
		return updatedBy;
	}
	
	public void setUpdatedBy(User updatedBy) {
		this.updatedBy = updatedBy;
	}
	
}
