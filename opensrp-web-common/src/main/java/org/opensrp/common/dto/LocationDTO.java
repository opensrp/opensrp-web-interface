package org.opensrp.common.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class LocationDTO {
	@JsonProperty("id")
	private Integer id;

	@JsonProperty("name")
	private String name;

	@JsonIgnore
	private String locationName;

	@JsonIgnore
	private String locationTagName;

	@JsonIgnore
	private String users;

	@JsonProperty("code")
	private String code;

	@JsonProperty("description")
	private String description;

	@JsonProperty("parent_location_id")
	private Integer parentLocationId;

	@JsonProperty("location_tag_id")
	private Integer locationTagId;

	@JsonProperty("creator_id")
	private Integer creatorId;

	@JsonProperty("division_id")
	private Integer divisionId;

	@JsonProperty("district_id")
	private Integer districtId;

	@JsonProperty("upazila_id")
	private Integer upazilaId;

	@JsonProperty("pourasabha_id")
	private Integer pourasabhaId;

	@JsonProperty("union_id")
	private Integer unionId;

	@JsonProperty("created_at")
	private Date created;

	@JsonProperty("updated_at")
	private Date updated;

	@JsonProperty("is_login_location")
	private boolean loginLocation;

	@JsonProperty("is_visit_location")
	private boolean visitLocation;

	public boolean isLoginLocation() {
		return loginLocation;
	}

	public void setLoginLocation(boolean loginLocation) {
		this.loginLocation = loginLocation;
	}

	public boolean isVisitLocation() {
		return visitLocation;
	}

	public void setVisitLocation(boolean visitLocation) {
		this.visitLocation = visitLocation;
	}

	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public Date getUpdated() {
		return updated;
	}

	public void setUpdated(Date updated) {
		this.updated = updated;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getParentLocationId() {
		return parentLocationId;
	}

	public void setParentLocationId(Integer parentLocationId) {
		this.parentLocationId = parentLocationId;
	}

	public Integer getLocationTagId() {
		return locationTagId;
	}

	public void setLocationTagId(Integer locationTagId) {
		this.locationTagId = locationTagId;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	public Integer getDivisionId() {
		return divisionId;
	}

	public void setDivisionId(Integer divisionId) {
		this.divisionId = divisionId;
	}

	public Integer getDistrictId() {
		return districtId;
	}

	public void setDistrictId(Integer districtId) {
		this.districtId = districtId;
	}

	public Integer getUpazilaId() {
		return upazilaId;
	}

	public void setUpazilaId(Integer upazilaId) {
		this.upazilaId = upazilaId;
	}

	public Integer getPourasabhaId() {
		return pourasabhaId;
	}

	public void setPourasabhaId(Integer pourasabhaId) {
		this.pourasabhaId = pourasabhaId;
	}

	public Integer getUnionId() {
		return unionId;
	}

	public void setUnionId(Integer unionId) {
		this.unionId = unionId;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
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

	@Override
	public String toString() {
		return "LocationDTO{" +
				"id=" + id +
				", name='" + name + '\'' +
				", locationName='" + locationName + '\'' +
				", locationTagName='" + locationTagName + '\'' +
				", users='" + users + '\'' +
				", code='" + code + '\'' +
				", description='" + description + '\'' +
				", parentLocationId=" + parentLocationId +
				", locationTagId=" + locationTagId +
				", creatorId=" + creatorId +
				", divisionId=" + divisionId +
				", districtId=" + districtId +
				", upazilaId=" + upazilaId +
				", pourasabhaId=" + pourasabhaId +
				", unionId=" + unionId +
				", created=" + created +
				", updated=" + updated +
				", loginLocation=" + loginLocation +
				", visitLocation=" + visitLocation +
				'}';
	}
}
