package org.opensrp.common.dto;

public class TimestamReportDTO {

    private String fullName;

    private String providerUserName;

    private String branchName;

    private Float iycfTime;

    private Float ancTime;

    private Float ncdTime;

    private Float womenTime;

    private Float adolescentTime;

    private Float hhVisitTime;

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

    public Float getIycfTime() {
        return iycfTime;
    }

    public void setIycfTime(Float iycfTime) {
        this.iycfTime = iycfTime;
    }

    public Float getAncTime() {
        return ancTime;
    }

    public void setAncTime(Float ancTime) {
        this.ancTime = ancTime;
    }

    public Float getNcdTime() {
        return ncdTime;
    }

    public void setNcdTime(Float ncdTime) {
        this.ncdTime = ncdTime;
    }

    public Float getWomenTime() {
        return womenTime;
    }

    public void setWomenTime(Float womenTime) {
        this.womenTime = womenTime;
    }

    public Float getAdolescentTime() {
        return adolescentTime;
    }

    public void setAdolescentTime(Float adolescentTime) {
        this.adolescentTime = adolescentTime;
    }

    public Float getHhVisitTime() {
        return hhVisitTime;
    }

    public void setHhVisitTime(Float hhVisitTime) {
        this.hhVisitTime = hhVisitTime;
    }
}
