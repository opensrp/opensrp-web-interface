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
	
	private String divisionName;
	
	private String districtName;
	
	private String upazillaName;
	
	private String sendTime;
	
	private String status;
	
	private String meetingOrtrainingDateAndTime;
	
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
	
	public String getDivisionName() {
		return divisionName;
	}
	
	public void setDivisionName(String divisionName) {
		this.divisionName = divisionName;
	}
	
	public String getDistrictName() {
		return districtName;
	}
	
	public void setDistrictName(String districtName) {
		this.districtName = districtName;
	}
	
	public String getUpazillaName() {
		return upazillaName;
	}
	
	public void setUpazillaName(String upazillaName) {
		this.upazillaName = upazillaName;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getSendTime() {
		return sendTime;
	}
	
	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}
	
	public String getMeetingOrtrainingDateAndTime() {
		return meetingOrtrainingDateAndTime;
	}
	
	public void setMeetingOrtrainingDateAndTime(String meetingOrtrainingDateAndTime) {
		this.meetingOrtrainingDateAndTime = meetingOrtrainingDateAndTime;
	}
	
}
