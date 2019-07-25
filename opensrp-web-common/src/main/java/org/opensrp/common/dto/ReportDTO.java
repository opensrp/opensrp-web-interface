package org.opensrp.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.codehaus.jackson.annotate.JsonProperty;

import javax.persistence.Column;
import java.text.DecimalFormat;

public class ReportDTO {

    @Column(name = "mhv_name")
    String mhv;

    @Column(name = "household_count")
    int household;

    int population;

    int female;

    int male;

    public String getMhv() {
        return mhv;
    }

    public void setMhv(String mhv) {
        this.mhv = mhv;
    }

    public int getHousehold() {
        return household;
    }

    public void setHousehold(int household) {
        this.household = household;
    }

    public int getPopulation() {
        return population;
    }

    public void setPopulation(int population) {
        this.population = population;
    }

    public int getFemale() {
        return female;
    }

    public void setFemale(int female) {
        this.female = female;
    }

    public int getMale() {
        return male;
    }

    public void setMale(int male) {
        this.male = male;
    }

    public String getFemalePercentage() {
        DecimalFormat df = new DecimalFormat("#.##");
        if (this.population == 0)return "0";
        return df.format((100.0/population)*female);
    }

    public String getMalePercentage() {
        DecimalFormat df = new DecimalFormat("#.##");
        if (this.population == 0)return "0";
        return df.format((100.0/population)*male);
    }
}
