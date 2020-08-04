package org.opensrp.core.dto;

public class BranchDTO {

    private int id = 0;

    private String name;

    private String code;

    private Integer division;

    private Integer district;

    private Integer upazila;

    private Integer skPosition;

    private Integer ssPosition;

    private Integer paPosition;

    private Integer pkPosition;

    public int getId() {
        return id;
    }

    public void setId(int id) {
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

    public Integer getDivision() {
        return division;
    }

    public void setDivision(Integer division) {
        this.division = division;
    }

    public Integer getDistrict() {
        return district;
    }

    public void setDistrict(Integer district) {
        this.district = district;
    }

    public Integer getUpazila() {
        return upazila;
    }

    public void setUpazila(Integer upazila) {
        this.upazila = upazila;
    }

    public Integer getSkPosition() {
        return skPosition;
    }

    public void setSkPosition(Integer skPosition) {
        this.skPosition = skPosition;
    }

    public Integer getSsPosition() {
        return ssPosition;
    }

    public void setSsPosition(Integer ssPosition) {
        this.ssPosition = ssPosition;
    }

    public Integer getPaPosition() {
        return paPosition;
    }

    public void setPaPosition(Integer paPosition) {
        this.paPosition = paPosition;
    }

    public Integer getPkPosition() {
        return pkPosition;
    }

    public void setPkPosition(Integer pkPosition) {
        this.pkPosition = pkPosition;
    }

    @Override
    public String toString() {
        return "BranchDTO{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", code='" + code + '\'' +
                ", division=" + division +
                ", district=" + district +
                ", upazila=" + upazila +
                ", skPosition=" + skPosition +
                ", ssPosition=" + ssPosition +
                ", paPosition=" + paPosition +
                ", pkPosition=" + pkPosition +
                '}';
    }
}
