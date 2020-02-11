package org.opensrp.common.util;

public enum Roles {
    ADMIN(26, "Admin"),
    SK(28, "SK"),
    SS(29, "SS"),
    PK(30, "PK"),
    AM(32, "AM"),
    OTS(33, "OTS"),
    DIV_M(34, "DivM");

    private Integer id;
    private String name;

    Roles(Integer id, String name) {
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
