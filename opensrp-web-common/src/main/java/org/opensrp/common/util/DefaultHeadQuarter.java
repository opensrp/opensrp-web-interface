package org.opensrp.common.util;

public enum DefaultHeadQuarter {

    DIVISION(28, "Division"),
    DISTRICT(29, "District"),
    UPAZILA_CITY_CORPORATION(30, "City Corporation Upazila");


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