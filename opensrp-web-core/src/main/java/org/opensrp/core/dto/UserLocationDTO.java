package org.opensrp.core.dto;

import java.util.Arrays;

public class UserLocationDTO {

    private int[] locations;

    private int[] allLocation;

    private int userId;

    private String role;

    public int[] getLocations() {
        return locations;
    }

    public void setLocations(int[] locations) {
        this.locations = locations;
    }

    public int[] getAllLocation() {
        return allLocation;
    }

    public void setAllLocation(int[] allLocation) {
        this.allLocation = allLocation;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "UserLocationDTO{" +
                "locations=" + Arrays.toString(locations) +
                ", userId=" + userId +
                '}';
    }
}
