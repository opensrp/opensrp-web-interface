package org.opensrp.common.dto;

public class UserDTO {
	
	private String firstName;
	
	private String lastName;
	
	private String email;
	
	private String mobile;
	
	private String idetifier;
	
	private String username;
	
	private String password;
	
	private String roles;
	
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
	
	@Override
	public String toString() {
		return "Usr [firstName=" + firstName + ", lastName=" + lastName + ", email=" + email + ", mobile=" + mobile
		        + ", idetifier=" + idetifier + ", username=" + username + ", password=" + password + ", roles=" + roles
		        + "]";
	}
	
}
