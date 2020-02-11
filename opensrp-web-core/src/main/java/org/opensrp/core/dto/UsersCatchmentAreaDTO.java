package org.opensrp.core.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class UsersCatchmentAreaDTO {

    private int id;

    @JsonProperty("location_id")
    private int locationId;

    @JsonProperty("location_parent_id")
    private int locationParentId;

    @JsonProperty("user_id")
    private int userId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public int getLocationParentId() {
        return locationParentId;
    }

    public void setLocationParentId(int locationParentId) {
        this.locationParentId = locationParentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
