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
@Table(name = "web_notification_user", schema = "core")
public class WebNotificationUser implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "web_notification_user_id_seq")
	@SequenceGenerator(name = "web_notification_user_id_seq", sequenceName = "web_notification_user_id_seq", allocationSize = 1)
	private Long id;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "web_notification_id", referencedColumnName = "id")
	private WebNotification webNotification;
	
	@Column(name = "user_id")
	private int userId;
	
	public Long getId() {
		return id;
		
	}
	
	public WebNotification getWebNotification() {
		return webNotification;
	}
	
	public void setWebNotification(WebNotification webNotification) {
		this.webNotification = webNotification;
	}
	
	public int getUserId() {
		return userId;
	}
	
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
}
