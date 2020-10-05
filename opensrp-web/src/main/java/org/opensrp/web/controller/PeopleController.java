/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "people")
public class PeopleController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@Autowired
	private BranchService branchService;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@RequestMapping(value = "/household.html", method = RequestMethod.GET)
	public String householdList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "people/households";
	}
	
	@RequestMapping(value = "/household-details/{id}.html", method = RequestMethod.GET)
	public String householdDetails(HttpServletRequest request, @PathVariable("id") int id, HttpSession session, Model model,
	                               Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "people/household_details";
	}
	
}
