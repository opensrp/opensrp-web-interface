package org.opensrp.common.dto;

public class TimestamReportDTO {

    private String fullName;

    private String providerUserName;

    private String branchName;

    private Integer iycfTime;

    private Integer ancTime;

    private Integer ncdTime;

    private Integer womenTime;

    private Integer adolescentTime;

    private Integer hhVisitTime;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getProviderUserName() {
        return providerUserName;
    }

    public void setProviderUserName(String providerUserName) {
        this.providerUserName = providerUserName;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public Integer getIycfTime() {
        return iycfTime;
    }

    public void setIycfTime(Integer iycfTime) {
        this.iycfTime = iycfTime;
    }

    public Integer getAncTime() {
        return ancTime;
    }

    public void setAncTime(Integer ancTime) {
        this.ancTime = ancTime;
    }

    public Integer getNcdTime() {
        return ncdTime;
    }

    public void setNcdTime(Integer ncdTime) {
        this.ncdTime = ncdTime;
    }

    public Integer getWomenTime() {
        return womenTime;
    }

    public void setWomenTime(Integer womenTime) {
        this.womenTime = womenTime;
    }

    public Integer getAdolescentTime() {
        return adolescentTime;
    }

    public void setAdolescentTime(Integer adolescentTime) {
        this.adolescentTime = adolescentTime;
    }

    public Integer getHhVisitTime() {
        return hhVisitTime;
    }

    public void setHhVisitTime(Integer hhVisitTime) {
        this.hhVisitTime = hhVisitTime;
    }
}
