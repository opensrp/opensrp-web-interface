package org.opensrp.core.dto;


public class FacilityDTO {

	private String name;
	private String hrmId;
	private String latitude;
	private String longitude;
	private String location;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getHrmId() {
		return hrmId;
	}
	public void setHrmId(String hrmId) {
		this.hrmId = hrmId;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	
	@Override
	public String toString() {
		return "FacilityDTO [name=" + name + ", hrmId=" + hrmId + ", latitude="
				+ latitude + ", longitude=" + longitude + ", location="
				+ location + "]";
	}
	
}
