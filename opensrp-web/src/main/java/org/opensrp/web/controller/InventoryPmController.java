package org.opensrp.web.controller;

import org.apache.commons.lang.StringUtils;
import org.opensrp.common.dto.StockReportDTO;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.StockService;
import org.opensrp.core.service.TargetService;
import org.opensrp.core.service.UserService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpSession;

import java.util.List;
import java.util.Locale;

@Controller
public class InventoryPmController {

    @Autowired
    private TargetService targetService;

    @Autowired
    private BranchService branchService;

    @Value("#{opensrp['division.tag.id']}")
    private int divisionTagId;


    @RequestMapping(value = "inventorypm/stock-report.html", method = RequestMethod.GET)
    public String stockReport(Model model, Locale locale, HttpSession session) {
        model.addAttribute("locale", locale);

        model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
        List<Branch> branches = branchService.findAll("Branch");
        model.addAttribute("branches", branches);
        return "stock-report-for-pm";
    }

}
