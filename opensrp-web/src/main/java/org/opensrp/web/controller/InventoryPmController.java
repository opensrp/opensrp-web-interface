package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.opensrp.core.entity.Branch;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
		model.addAttribute("show", "block");
		return "stock-report-for-pm";
	}
	
}
