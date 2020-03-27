package org.opensrp.core.service;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.*;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {
    private static final Logger logger = Logger.getLogger(UserService.class);
    @Autowired
    private DatabaseRepository repository;

    public List<AggregatedReportDTO> getAggregatedReportBySK(String startDate, String endDate, String skIds) {
        String sql = "select * from report.get_aggregated_report_by_sk(:startDate, :endDate, '{"+skIds+"}');";
        return repository.getAggregatedReport(startDate, endDate, sql);
    }

    public List<AggregatedReportDTO> getAggregatedReportByLocation(String startDate, String endDate, Integer parentLocationId, String locationTag, String parentLocationTag, String parentLocationName) {
        String sql = "select  * from report.get_aggregated_report_by_location(:startDate, :endDate, "+parentLocationId+", '"+locationTag+"', '"+parentLocationTag+"', '"+parentLocationName+"');";
        return repository.getAggregatedReport(startDate, endDate, sql);
    }

    public List<COVID19ReportDTO> getCOVID19Report(String startDate, String endDate, Integer offset, Integer limit) {
        String sql = "select * from report.get_covid_19_report(:startDate, :endDate, :offset, :limit);";
        return repository.getCOVID19Report(startDate, endDate, sql, offset, limit);
    }

    public Integer getCOVID19ReportCount(String startDate, String endDate) {
        String sql = "select count(*) totalRows from report.corona where submitted_date between '"+startDate+"' and '"+endDate+"';";
        return repository.getCOVID19ReportCount(sql);
    }

    public List<COVID19ReportDTO> getCOVID19ReportBySK(String startDate, String endDate, String skIds, Integer offset, Integer limit) {
        String sql = "select * from report.get_covid_19_report_by_sk(:startDate, :endDate, '{"+skIds+"}', :offset, :limit);";
        return repository.getCOVID19ReportBySK(startDate, endDate, sql, offset, limit);
    }

    public Integer getCOVID19ReportBySKCount(String startDate, String endDate, String skIds) {
        String sql = "select count(*) totalRows from report.corona where submitted_date between '"+startDate+"' and '"+endDate+"' and provider_id = any('{"+skIds+"}');";
        return repository.getCOVID19ReportCount(sql);
    }

    public List<ElcoReportDTO> getElcoReportBySK(String startDate, String endDate, String skIds) {
        String sql = "select * from report.get_elco_report_by_sk(:startDate, :endDate, '{"+skIds+"}');";
        return repository.getElcoReport(startDate, endDate, sql);
    }

    public List<ElcoReportDTO> getElcoReportByLocation(String startDate, String endDate, Integer parentLocationId, String locationTag, String parentLocationTag, String parentLocationName) {
        String sql = "select  * from report.get_elco_report_by_location(:startDate, :endDate, "+parentLocationId+", '"+locationTag+"', '"+parentLocationTag+"', '"+parentLocationName+"');";
        return repository.getElcoReport(startDate, endDate, sql);
    }

    public List<PregnancyReportDTO> getPregnancyReportBySK(String startDate, String endDate, String skIds) {
        String sql = "select * from report.get_pregnancy_report_by_sk(:startDate, :endDate, '{"+skIds+"}');";
        return repository.getPregnancyReport(startDate, endDate, sql);
    }

    public List<PregnancyReportDTO> getPregnancyReportByLocation(String startDate, String endDate, Integer parentLocationId, String locationTag, String parentLocationTag, String parentLocationName) {
        String sql = "select  * from report.get_pregnancy_report_by_location(:startDate, :endDate, "+parentLocationId+", '"+locationTag+"', '"+parentLocationTag+"', '"+parentLocationName+"');";
        return repository.getPregnancyReport(startDate, endDate, sql);
    }

    public List<ChildNutritionReportDTO> getChildNutritionReportBySK(String startDate, String endDate, String skIds) {
        String sql = "select * from report.get_child_nutrition_report_by_sk(:startDate, :endDate, '{"+skIds+"}');";
        return repository.getChildNutritionReport(startDate, endDate, sql);
    }

    public List<ChildNutritionReportDTO> getChildNutritionReportByLocation(String startDate, String endDate, Integer parentLocationId, String locationTag, String parentLocationTag, String parentLocationName) {
        String sql = "select  * from report.get_child_nutrition_report_by_location(:startDate, :endDate, "+parentLocationId+", '"+locationTag+"', '"+parentLocationTag+"', '"+parentLocationName+"');";
        return repository.getChildNutritionReport(startDate, endDate, sql);
    }

    public JSONObject getCOVID19DataOfDataTable(Integer draw, Integer totalNumberOfRecords, List<COVID19ReportDTO> covid19Reports) throws JSONException {
        JSONObject response = new JSONObject();
        response.put("draw", draw+1);
        response.put("recordsTotal", totalNumberOfRecords);
        response.put("recordsFiltered", totalNumberOfRecords);
        JSONArray array = new JSONArray();
        for (COVID19ReportDTO report: covid19Reports) {
            JSONArray covid = new JSONArray();
            covid.put(report.getSkId());
            covid.put(report.getSsName());
            covid.put(report.getVisitNumberToday());
            covid.put(report.getNumberOfSymptomsFound());
            covid.put(report.getNumberOfContactPersonFromAbroad());
            covid.put(report.getNumberOfPersonContactedWithSymptoms());
            covid.put(report.getFirstName());
            covid.put(report.getContactPhone());
            covid.put(report.getGenderCode());
            covid.put(report.getSymptomsFound());
            covid.put(report.getSubmittedDate());
            array.put(covid);
        }
        response.put("data", array);
        return response;
    }
}
