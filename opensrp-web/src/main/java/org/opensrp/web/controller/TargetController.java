/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "target")
public class TargetController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	private int divisionTagId = 28;
	
	@RequestMapping(value = "/target-by-individual.html", method = RequestMethod.GET)
	public String targetByIndividual(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "targets/sk-pa-list-for-individual-target";
	}
	
	@RequestMapping(value = "/target-by-position-list.html", method = RequestMethod.GET)
	public String targetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "targets/target-by-position-list";
	}
	
	@RequestMapping(value = "/set-individual/{branch_id}/{role_id}/{user_id}.html", method = RequestMethod.GET)
	public String targetSetIndividually(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                    @PathVariable("branch_id") int branchId, @PathVariable("role_id") int roleId,
	                                    @PathVariable("user_id") int userId) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(roleId));
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("roleId", roleId);
		model.addAttribute("name", request.getParameter("name"));
		return "targets/sk-pa-individual-target-set";
	}
	
}
