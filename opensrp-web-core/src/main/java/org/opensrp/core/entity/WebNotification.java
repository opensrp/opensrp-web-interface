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
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "web_notification", schema = "core")
public class WebNotification implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "web_notification_id_seq")
	@SequenceGenerator(name = "web_notification_id_seq", sequenceName = "web_notification_id_seq", allocationSize = 1)
	private Long id;
	
	@NotEmpty(message = "Notification title name can't be empty")
	@Column(name = "title")
	private String notificationTitle;
	
	@Column(name = "uuid")
	private String uuid;
	
	@Column(name = "notification", columnDefinition = "TEXT")
	private String notification;
	
	@Column(name = "role_id")
	private int roleId;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "send_date")
	private Date sendDate;
	
	@Column(name = "send_time_minute")
	private int sendTimeMinute;
	
	@Column(name = "send_time_hour")
	private int sendTimeHour;
	
	@Column(name = "division_id", nullable = false)
	private int division;
	
	@Column(name = "district_id", nullable = false)
	private int district;
	
	@Column(name = "upazila_id", nullable = false)
	private int upazila;
	
	@Column(name = "branch_id")
	private int branch;
	
	private Long timestamp;
	
	private String status;
	
	private String type;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@JoinColumn(name = "creator")
	private int creator;
	
	@Column(name = "updated_by")
	private int updatedBy;
	
	@OneToMany(mappedBy = "webNotification", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private Set<WebNotificationUser> webNotifications = new HashSet<WebNotificationUser>();
	
	@OneToMany(mappedBy = "webNotification", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private Set<WebNotificationRole> webNotificationRoles = new HashSet<WebNotificationRole>();
	
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
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getNotificationTitle() {
		return notificationTitle;
	}
	
	public void setNotificationTitle(String notificationTitle) {
		this.notificationTitle = notificationTitle;
	}
	
	public String getNotification() {
		return notification;
	}
	
	public void setNotification(String notification) {
		this.notification = notification;
	}
	
	public int getRoleId() {
		return roleId;
	}
	
	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}
	
	public Date getSendDate() {
		return sendDate;
	}
	
	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}
	
	public int getSendTimeMinute() {
		return sendTimeMinute;
	}
	
	public void setSendTimeMinute(int sendTimeMinute) {
		this.sendTimeMinute = sendTimeMinute;
	}
	
	public int getSendTimeHour() {
		return sendTimeHour;
	}
	
	public void setSendTimeHour(int sendTimeHour) {
		this.sendTimeHour = sendTimeHour;
	}
	
	public int getDivision() {
		return division;
	}
	
	public void setDivision(int division) {
		this.division = division;
	}
	
	public int getDistrict() {
		return district;
	}
	
	public void setDistrict(int district) {
		this.district = district;
	}
	
	public int getUpazila() {
		return upazila;
	}
	
	public void setUpazila(int upazila) {
		this.upazila = upazila;
	}
	
	public int getBranch() {
		return branch;
	}
	
	public void setBranch(int branch) {
		this.branch = branch;
	}
	
	public int getCreator() {
		return creator;
	}
	
	public void setCreator(int creator) {
		this.creator = creator;
	}
	
	public int getUpdatedBy() {
		return updatedBy;
	}
	
	public void setUpdatedBy(int updatedBy) {
		this.updatedBy = updatedBy;
	}
	
	public Set<WebNotificationUser> getWebNotifications() {
		return webNotifications;
	}
	
	public void setWebNotifications(Set<WebNotificationUser> webNotifications) {
		this.webNotifications = webNotifications;
	}
	
	public Set<WebNotificationRole> getWebNotificationRoles() {
		return webNotificationRoles;
	}
	
	public void setWebNotificationRoles(Set<WebNotificationRole> webNotificationRoles) {
		this.webNotificationRoles = webNotificationRoles;
	}
	
}
