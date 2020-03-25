package org.opensrp.common.dto;

import java.util.Date;

public class COVID19ReportDTO {

    private Integer id;

    private String ssName;

    private String skId;

    private Integer visitNumberToday;

    private Integer numberOfSymptomsFound;

    private Integer numberOfContactPersonFromAbroad;

    private Integer numberOfPersonContactedWithSymptoms;

    private String firstName;

    private String contactPhone;

    private String genderCode;

    private String symptomsFound;

    private Date submittedDate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSsName() {
        return ssName;
    }

    public void setSsName(String ssName) {
        this.ssName = ssName;
    }

    public String getSkId() {
        return skId;
    }

    public void setSkId(String skId) {
        this.skId = skId;
    }

    public Integer getVisitNumberToday() {
        return visitNumberToday;
    }

    public void setVisitNumberToday(Integer visitNumberToday) {
        this.visitNumberToday = visitNumberToday;
    }

    public Integer getNumberOfSymptomsFound() {
        return numberOfSymptomsFound;
    }

    public void setNumberOfSymptomsFound(Integer numberOfSymptomsFound) {
        this.numberOfSymptomsFound = numberOfSymptomsFound;
    }

    public Integer getNumberOfContactPersonFromAbroad() {
        return numberOfContactPersonFromAbroad;
    }

    public void setNumberOfContactPersonFromAbroad(Integer numberOfContactPersonFromAbroad) {
        this.numberOfContactPersonFromAbroad = numberOfContactPersonFromAbroad;
    }

    public Integer getNumberOfPersonContactedWithSymptoms() {
        return numberOfPersonContactedWithSymptoms;
    }

    public void setNumberOfPersonContactedWithSymptoms(Integer numberOfPersonContactedWithSymptoms) {
        this.numberOfPersonContactedWithSymptoms = numberOfPersonContactedWithSymptoms;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getGenderCode() {
        return genderCode;
    }

    public void setGenderCode(String genderCode) {
        this.genderCode = genderCode;
    }

    public String getSymptomsFound() {
        return symptomsFound;
    }

    public void setSymptomsFound(String symptomsFound) {
        this.symptomsFound = symptomsFound;
    }

    public Date getSubmittedDate() {
        return submittedDate;
    }

    public void setSubmittedDate(Date submittedDate) {
        this.submittedDate = submittedDate;
    }
}
