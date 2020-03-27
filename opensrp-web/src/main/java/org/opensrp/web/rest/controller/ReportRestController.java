package org.opensrp.web.rest.controller;

import org.apache.commons.lang.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.COVID19ReportDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ReportService;
import org.opensrp.core.service.UserService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.springframework.http.HttpStatus.OK;

@RequestMapping("rest/api/v1/report")
@RestController
public class ReportRestController {

    @Autowired private ReportService reportService;
    @Autowired private BranchService branchService;
    @Autowired private UserService userService;

    @RequestMapping(value = "/covid-19", method = RequestMethod.GET)
    public ResponseEntity<String> generateCOVID19Report(HttpServletRequest request) throws JSONException {
        String branchId = request.getParameterMap().containsKey("branch")?request.getParameter("branch") : "";
        String skIds = request.getParameterMap().containsKey("sk")?request.getParameter("sk") : "";
        String startDate = request.getParameterMap().containsKey("startDate")?request.getParameter("startDate") : "";
        String endDate = request.getParameterMap().containsKey("endDate")?request.getParameter("endDate") : "";
        List<COVID19ReportDTO> covid19Reports;
        Integer totalCovidRecords;
        User user = AuthenticationManagerUtil.getLoggedInUser();
        Integer draw = Integer.valueOf(request.getParameter("draw"));
        Integer offset = Integer.valueOf(request.getParameter("start"));
        Integer limit = Integer.valueOf(request.getParameter("length"));

        if (!StringUtils.isBlank(skIds) && !skIds.equals("0")) {
            totalCovidRecords = reportService.getCOVID19ReportBySKCount(startDate, endDate, skIds);
            covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, offset, limit);
        } else {
            if (StringUtils.isBlank(branchId) || branchId.equals("0")) {
                if (AuthenticationManagerUtil.isAdmin()) {
                    totalCovidRecords = reportService.getCOVID19ReportCount(startDate, endDate);
                    covid19Reports = reportService.getCOVID19Report(startDate, endDate, offset, limit);
                } else {
                    String branches = branchService.commaSeparatedBranch(new ArrayList<>(user.getBranches()));
                    skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
                    totalCovidRecords = reportService.getCOVID19ReportBySKCount(startDate, endDate, skIds);
                    covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, offset, limit);
                }
            } else {
                Branch branch = branchService.findById(Integer.valueOf(branchId), "id", Branch.class);
                String branches = branchService.commaSeparatedBranch(Arrays.asList(branch));
                skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
                totalCovidRecords = reportService.getCOVID19ReportBySKCount(startDate, endDate, skIds);
                covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, offset, limit);
            }
        }
        JSONObject response = reportService.getCOVID19DataOfDataTable(draw, totalCovidRecords, covid19Reports);
        return new ResponseEntity<>(response.toString(), OK);
    }
}
