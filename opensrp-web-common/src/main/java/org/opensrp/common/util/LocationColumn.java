package org.opensrp.common.util;

public enum LocationColumn {
    _0( "name"),
    _1( "description"),
    _3( "locationTagName");

    private String value;

    LocationColumn(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }
}
