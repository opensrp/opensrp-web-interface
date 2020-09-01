/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.Roles;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Role;
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
	
	@RequestMapping(value = "/set-target-by-position.html", method = RequestMethod.GET)
	public String seTtargetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		String roleName = request.getParameter("role");
		Role role = targetService.findByKey(roleName, "name", Role.class);
		model.addAttribute("targets", targetService.allActiveTarget(role.getId()));
		model.addAttribute("setTargetTo", request.getParameter("setTargetTo"));
		model.addAttribute("role", role.getId());
		model.addAttribute("type", request.getParameter("type"));
		model.addAttribute("locationTag", request.getParameter("locationTag"));
		model.addAttribute("text", request.getParameter("text"));
		return "targets/set-target-by-position";
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
	
	@RequestMapping(value = "/get-target-info", method = RequestMethod.GET)
	public String getTargetInfo(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("locale", locale);
		int role = Integer.parseInt(request.getParameter("role"));
		String typeName = request.getParameter("typeName");
		String locationTag = request.getParameter("locationTag");
		int month = Integer.parseInt(request.getParameter("month"));
		int year = Integer.parseInt(request.getParameter("year"));
		int locationOrBranchOrUserId = Integer.parseInt(request.getParameter("locationOrBranchOrUserId"));
		model.addAttribute("targets", targetService.getTargetInfoByBranchOrLocationOrUserByRoleByMonth(role,
		    locationOrBranchOrUserId, typeName, locationTag, month, year));
		
		return "targets/get-target-info";
	}
	
	@RequestMapping(value = "/target-by-population.html", method = RequestMethod.GET)
	public String targetByPopulation(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "targets/target-by-population-list";
	}
	
	@RequestMapping(value = "/set-individual-target-pk", method = RequestMethod.GET)
	public String indiviualTargetSetForPkB(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(Roles.PK.getId()));
		return "targets/individual-target-by-population-pk";
	}
	
	@RequestMapping(value = "/population-wise-target-set", method = RequestMethod.GET)
	public String populationWiseTargetSet(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(Roles.PK.getId()));
		return "targets/population-wise-target-set";
	}
	
}
