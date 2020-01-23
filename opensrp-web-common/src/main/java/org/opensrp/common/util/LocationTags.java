package org.opensrp.common.util;

public enum LocationTags {
    COUNTRY(27, "Country"),
    DIVISION(28, "Division"),
    DISTRICT(29, "District"),
    UPAZILA_CITY_CORPORATION(30, "City Corporation Upazila"),
    POURASABHA(31, "Pourasabha"),
    UNION_WARD(32, "Union Ward"),
    VILLAGE(33, "Village");

    private Integer id;
    private String name;

    LocationTags(Integer id, String name) {
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
