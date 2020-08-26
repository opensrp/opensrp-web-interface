package org.opensrp.common.dto;

public class TargetCommontDTO extends InventoryDTO {
	
	private int roleId;
	
	private int branchId;
	
	private int userId;
	
	private int userCount;
	
	@Override
	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}
	
	public int getBranchId() {
		return branchId;
	}
	
	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}
	
	public int getUserId() {
		return userId;
	}
	
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public int getUserCount() {
		return userCount;
	}
	
	public void setUserCount(int userCount) {
		this.userCount = userCount;
	}
	
}
