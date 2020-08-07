/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "requisition_details", schema = "core")
public class RequisitionDetails implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "requisition_details_id_seq")
	@SequenceGenerator(name = "requisition_details_id_seq", sequenceName = "requisition_details_id_seq", allocationSize = 1)
	private Long id;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "requisition_id", referencedColumnName = "id")
	private Requisition requisition;
	
	@Column(name = "product_id")
	private Long productId;
	
	@Column(name = "current_stock")
	private int currentStock;
	
	private int qunatity;
	
	private String uuid;
	
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
