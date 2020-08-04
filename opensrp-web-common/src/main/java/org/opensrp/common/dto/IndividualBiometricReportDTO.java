package org.opensrp.common.dto;

import java.util.Date;

public class IndividualBiometricReportDTO {
    private String locationOrProvider;
    private String providerName;
    private String serviceName;
    private Date eventDate;
    private String identified;
    private String verifiedOrBypass;
    private String memberName;
    private String memberId;
    private String branchName;

    public String getLocationOrProvider() {
        return locationOrProvider;
    }

    public void setLocationOrProvider(String locationOrProvider) {
        this.locationOrProvider = locationOrProvider;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public String getIdentifiedStr() {
        return identified;
    }

    public void setIdentifiedStr(String identifiedStr) {
        this.identified = identifiedStr;
    }

    public String getVerifiedOrBypass() {
        return verifiedOrBypass;
    }

    public void setVerifiedOrBypass(String verifiedOrBypass) {
        this.verifiedOrBypass = verifiedOrBypass;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }
}
