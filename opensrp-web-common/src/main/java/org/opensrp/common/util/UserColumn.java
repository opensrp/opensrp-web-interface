package org.opensrp.common.util;

public enum UserColumn {
    _1( "username"),
    _0( "full_name"),
    _3( "mobile"),
    _2( "role_name"),
    _4( "branch");

    private String value;

    UserColumn(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

}
