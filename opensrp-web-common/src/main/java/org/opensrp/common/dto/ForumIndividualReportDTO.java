package org.opensrp.common.dto;

public class ForumIndividualReportDTO {
    private String locationOrProvider;
    private Integer target;
    private Integer achievement;
    private Integer totalParticipant;
    private Integer serviceSold;

    public String getLocationOrProvider() {
        return locationOrProvider;
    }

    public void setLocationOrProvider(String locationOrProvider) {
        this.locationOrProvider = locationOrProvider;
    }

    public Integer getTarget() {
        return target;
    }

    public void setTarget(Integer target) {
        this.target = target;
    }

    public Integer getAchievement() {
        return achievement;
    }

    public void setAchievement(Integer achievement) {
        this.achievement = achievement;
    }

    public Integer getTotalParticipant() {
        return totalParticipant;
    }

    public void setTotalParticipant(Integer totalParticipant) {
        this.totalParticipant = totalParticipant;
    }

    public Integer getServiceSold() {
        return serviceSold;
    }

    public void setServiceSold(Integer serviceSold) {
        this.serviceSold = serviceSold;
    }
}
