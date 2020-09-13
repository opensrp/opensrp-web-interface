package org.opensrp.common.util;

public enum DefaultHeadQuarter {

    DIVISION(9266, "Division"),
    DISTRICT(9267, "District"),
    UPAZILA_CITY_CORPORATION(9268, "City Corporation Upazila");


    private Integer id;
    private String name;

    DefaultHeadQuarter(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    public Integer getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }
}