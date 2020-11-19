package org.opensrp.common.dto;

public class TargetCommontDTO extends InventoryDTO {
	
	private int productId;
	
	private int userId;
	
	private int userCount;
	
	private String percentage;
	
	private int population;
	
	private int locationId;
	
	public int getProductId() {
		return productId;
	}
	
	public void setProductId(int productId) {
		this.productId = productId;
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
	
	public String getPercentage() {
		return percentage;
	}
	
	public void setPercentage(String percentage) {
		this.percentage = percentage;
	}
	
	public int getPopulation() {
		return population;
	}
	
	public void setPopulation(int population) {
		this.population = population;
	}
	
	public int getLocationId() {
		return locationId;
	}
	
	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}
	
}
