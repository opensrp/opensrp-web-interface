package org.opensrp.common.dto;

public class HrReportDTO {

    private String dmName;

    private String amName;

    private String branchName;

    private Integer totalAm;

    private Integer totalBranch;

    private Integer positions;

    private Integer activeUsers;

    private Integer onLeaveUsers;

    public String getDmName() {
        return dmName;
    }

    public void setDmName(String dmName) {
        this.dmName = dmName;
    }

    public String getAmName() {
        return amName;
    }

    public void setAmName(String amName) {
        this.amName = amName;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public Integer getTotalAm() {
        return totalAm;
    }

    public void setTotalAm(Integer totalAm) {
        this.totalAm = totalAm;
    }

    public Integer getTotalBranch() {
        return totalBranch;
    }

    public void setTotalBranch(Integer totalBranch) {
        this.totalBranch = totalBranch;
    }

    public Integer getPositions() {
        return positions;
    }

    public void setPositions(Integer positions) {
        this.positions = positions;
    }

    public Integer getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(Integer activeUsers) {
        this.activeUsers = activeUsers;
    }

    public Integer getOnLeaveUsers() {
        return onLeaveUsers;
    }

    public void setOnLeaveUsers(Integer onLeaveUsers) {
        this.onLeaveUsers = onLeaveUsers;
    }


}
