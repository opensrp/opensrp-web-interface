package org.opensrp.common.dto;

import java.util.Arrays;

public class UserDTO {
	
	private String firstName;
	
	private String lastName;
	
	private String email;
	
	private String mobile;
	
	private String idetifier;
	
	private String username;
	
	private String password;
	
	private String roles;

	private String branches;
	
	private int parentUser;
	
	private String locationList;
	
	private int team;
	
	private boolean teamMember;

	private Boolean enableSimPrint;
	
	public boolean isTeamMember() {
		return teamMember;
	}
	
	public void setTeamMember(boolean teamMember) {
		this.teamMember = teamMember;
	}
	
	public String getLocationList() {
		return locationList;
	}
	
	public void setLocationList(String locationList) {
		this.locationList = locationList;
	}
	
	public int getTeam() {
		return team;
	}
	
	public void setTeam(int team) {
		this.team = team;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getMobile() {
		return mobile;
	}
	
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public String getIdetifier() {
		return idetifier;
	}
	
	public void setIdetifier(String idetifier) {
		this.idetifier = idetifier;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getRoles() {
		return roles;
	}
	
	public void setRoles(String roles) {
		this.roles = roles;
	}
	
	public int getParentUser() {
		return parentUser;
	}
	
	public void setParentUser(int parentUser) {
		this.parentUser = parentUser;
	}

	public String getBranches() {
		return branches;
	}

	public void setBranches(String branches) {
		this.branches = branches;
	}

	public Boolean getEnableSimPrint() {
		return enableSimPrint;
	}

	public void setEnableSimPrint(Boolean enableSimPrint) {
		this.enableSimPrint = enableSimPrint;
	}

	@Override
	public String toString() {
		return "UserDTO [firstName=" + firstName + ", lastName=" + lastName + ", email=" + email + ", mobile=" + mobile
		        + ", idetifier=" + idetifier + ", username=" + username + ", password=" + password + ", roles=" + roles
		        + ", parentUser=" + parentUser + ", locationList=" + locationList + ", team=" + team + ", teamMember="
		        + teamMember + "]";
	}
	
}
