package org.opensrp.core.service;

import org.apache.log4j.Logger;
import org.opensrp.common.dto.ElcoReportDTO;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {
    private static final Logger logger = Logger.getLogger(UserService.class);
    @Autowired
    private DatabaseRepository repository;

    public List<ElcoReportDTO> getElcoReportBySK(String startDate, String endDate, String skIds) {
        String sql = "select * from report.get_elco_report_by_sk(:startDate, :endDate, '{"+skIds+"}');";
        return repository.getElcoReport(startDate, endDate, sql);
    }

    public List<ElcoReportDTO> getElcoReportByLocation(String startDate, String endDate, Integer parentLocationId, String locationTag, String parentLocationTag, String parentLocationName) {
        String sql = "select  * from report.get_elco_report_by_location(:startDate, :endDate, "+parentLocationId+", '"+locationTag+"', '"+parentLocationTag+"', '"+parentLocationName+"');";
        return repository.getElcoReport(startDate, endDate, sql);
    }
}
