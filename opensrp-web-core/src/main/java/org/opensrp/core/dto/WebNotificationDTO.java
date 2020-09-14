/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dto;

import java.util.Date;
import java.util.Set;

public class WebNotificationDTO {
	
	private Long id;
	
	private String notificationTitle;
	
	private String notification;
	
	private int roleId;
	
	private Date sendDate;
	
	private int sendTimeMinute;
	
	private int sendTimeHour;
	
	private int division;
	
	private int district;
	
	private int upazila;
	
	private int branch;
	
	private String type;
	
	private String locationType;
	
	private int locationTypeId;
	
	private String status;
	
	private Set<Integer> users;
	
	private Set<Integer> roles;
	
	private String sendDateAndTime;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
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
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public Set<Integer> getUsers() {
		return users;
	}
	
	public void setUsers(Set<Integer> users) {
		this.users = users;
	}
	
	public String getLocationType() {
		return locationType;
	}
	
	public void setLocationType(String locationType) {
		this.locationType = locationType;
	}
	
	public int getLocationTypeId() {
		return locationTypeId;
	}
	
	public void setLocationTypeId(int locationTypeId) {
		this.locationTypeId = locationTypeId;
	}
	
	public Set<Integer> getRoles() {
		return roles;
	}
	
	public void setRoles(Set<Integer> roles) {
		this.roles = roles;
	}
	
	public String getSendDateAndTime() {
		return sendDateAndTime;
	}
	
	public void setSendDateAndTime(String sendDateAndTime) {
		this.sendDateAndTime = sendDateAndTime;
	}
	
}
