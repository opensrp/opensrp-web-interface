package org.opensrp.common.dto;

public class ChildNutritionReportDTO {

    private String locationOrProvider;

    private Integer childrenVisited19To36;

    private Integer immunizedChildren18To36;

    private Integer ncdPackage;

    private Integer adolescentPackage;

    private Integer iycfPackage;

    private Integer womenPackage;

    private Integer breastFeedIn1Hour;

    private Integer breastFeedIn24Hour;

    private Integer complementaryFoodAt7Months;

    private Integer pushtikonaInLast24Hour;

    public String getLocationOrProvider() {
        return locationOrProvider;
    }

    public void setLocationOrProvider(String locationOrProvider) {
        this.locationOrProvider = locationOrProvider;
    }

    public Integer getChildrenVisited19To36() {
        return childrenVisited19To36;
    }

    public void setChildrenVisited19To36(Integer childrenVisited19To36) {
        this.childrenVisited19To36 = childrenVisited19To36;
    }

    public Integer getImmunizedChildren18To36() {
        return immunizedChildren18To36;
    }

    public void setImmunizedChildren18To36(Integer immunizedChildren18To36) {
        this.immunizedChildren18To36 = immunizedChildren18To36;
    }

    public Integer getNcdPackage() {
        return ncdPackage;
    }

    public void setNcdPackage(Integer ncdPackage) {
        this.ncdPackage = ncdPackage;
    }

    public Integer getAdolescentPackage() {
        return adolescentPackage;
    }

    public void setAdolescentPackage(Integer adolescentPackage) {
        this.adolescentPackage = adolescentPackage;
    }

    public Integer getIycfPackage() {
        return iycfPackage;
    }

    public void setIycfPackage(Integer iycfPackage) {
        this.iycfPackage = iycfPackage;
    }

    public Integer getWomenPackage() {
        return womenPackage;
    }

    public void setWomenPackage(Integer womenPackage) {
        this.womenPackage = womenPackage;
    }

    public Integer getBreastFeedIn1Hour() {
        return breastFeedIn1Hour;
    }

    public void setBreastFeedIn1Hour(Integer breastFeedIn1Hour) {
        this.breastFeedIn1Hour = breastFeedIn1Hour;
    }

    public Integer getBreastFeedIn24Hour() {
        return breastFeedIn24Hour;
    }

    public void setBreastFeedIn24Hour(Integer breastFeedIn24Hour) {
        this.breastFeedIn24Hour = breastFeedIn24Hour;
    }

    public Integer getComplementaryFoodAt7Months() {
        return complementaryFoodAt7Months;
    }

    public void setComplementaryFoodAt7Months(Integer complementaryFoodAt7Months) {
        this.complementaryFoodAt7Months = complementaryFoodAt7Months;
    }

    public Integer getPushtikonaInLast24Hour() {
        return pushtikonaInLast24Hour;
    }

    public void setPushtikonaInLast24Hour(Integer pushtikonaInLast24Hour) {
        this.pushtikonaInLast24Hour = pushtikonaInLast24Hour;
    }
}
