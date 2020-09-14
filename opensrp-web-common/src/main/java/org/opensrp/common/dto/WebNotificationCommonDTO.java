package org.opensrp.common.dto;

import java.util.Date;

public class WebNotificationCommonDTO {
	
	private long id;
	
	private String title;
	
	private String notification;
	
	private Date sendDate;
	
	private int sendTimeHour;
	
	private int sendTimeMinute;
	
	private String branchName;
	
	private String branchCode;
	
	private String roleName;
	
	private String type;
	
	private String createdTime;
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getNotification() {
		return notification;
	}
	
	public void setNotification(String notification) {
		this.notification = notification;
	}
	
	public Date getSendDate() {
		return sendDate;
	}
	
	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}
	
	public int getSendTimeHour() {
		return sendTimeHour;
	}
	
	public void setSendTimeHour(int sendTimeHour) {
		this.sendTimeHour = sendTimeHour;
	}
	
	public int getSendTimeMinute() {
		return sendTimeMinute;
	}
	
	public void setSendTimeMinute(int sendTimeMinute) {
		this.sendTimeMinute = sendTimeMinute;
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
	
	public String getRoleName() {
		return roleName;
	}
	
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getCreatedTime() {
		return createdTime;
	}
	
	public void setCreatedTime(String createdTime) {
		this.createdTime = createdTime;
	}
	
}
