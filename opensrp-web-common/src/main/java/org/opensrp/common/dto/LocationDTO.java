package org.opensrp.common.dto;

public class LocationDTO {

	private Integer id;

	private String locationName;

	private Integer parentLocationId;

	private String locationTagName;

	private String users;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public Integer getParentLocationId() {
		return parentLocationId;
	}

	public void setParentLocationId(Integer parentLocationId) {
		this.parentLocationId = parentLocationId;
	}

	public String getLocationTagName() {
		return locationTagName;
	}

	public void setLocationTagName(String locationTagName) {
		this.locationTagName = locationTagName;
	}

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		this.users = users;
	}
}
