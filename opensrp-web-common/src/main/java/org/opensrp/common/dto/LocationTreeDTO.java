package org.opensrp.common.dto;

public class LocationTreeDTO {

    private int id;

    private String code;

    private String name;

    private int leaf_loc_id;

    private int member_id;

    private String username;

    private String first_name;

    private String last_name;

    private String loc_tag_name;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLeaf_loc_id() {
        return leaf_loc_id;
    }

    public void setLeaf_loc_id(int leaf_loc_id) {
        this.leaf_loc_id = leaf_loc_id;
    }

    public int getMember_id() {
        return member_id;
    }

    public void setMember_id(int member_id) {
        this.member_id = member_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFirst_name() {
        return first_name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public String getLoc_tag_name() {
        return loc_tag_name;
    }

    public void setLoc_tag_name(String loc_tag_name) {
        this.loc_tag_name = loc_tag_name;
    }
}
