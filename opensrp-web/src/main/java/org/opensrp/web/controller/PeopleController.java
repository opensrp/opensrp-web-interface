/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ClientCommonDTO;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.DataViewConfigurationService;
import org.opensrp.core.service.PeopleService;
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
	private PeopleService peopleService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@Autowired
	private DataViewConfigurationService dataViewConfigurationService;
	
	@Autowired
	private BranchService branchService;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@RequestMapping(value = "/households.html", method = RequestMethod.GET)
	public String householdList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "people/households";
	}
	
	@RequestMapping(value = "/household-details/{baseEntityId}/{id}.html", method = RequestMethod.GET)
	public String householdDetails(HttpServletRequest request, @PathVariable("baseEntityId") String baseEntityId,
	                               @PathVariable("id") int id, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		
		ClientCommonDTO data = peopleService.getMemberData(baseEntityId, "", "", 0, 10, 0, "", "");
		JSONObject dataInfos = peopleService.getHouseholdInfor(baseEntityId);
		model.addAttribute("reg_info", dataInfos.get("data"));
		
		model.addAttribute("services", peopleService.getServiceList(baseEntityId));
		model.addAttribute("configs",
		    dataViewConfigurationService.getConfigurationByNameFormName(dataInfos.getString("form_name")));
		model.addAttribute("members", data.getClientDTO());
		return "people/household_details";
	}
	
	@RequestMapping(value = "/member-details/{baseEntityId}/{id}.html", method = RequestMethod.GET)
	public String memberDetails(HttpServletRequest request, @PathVariable("baseEntityId") String baseEntityId,
	                            @PathVariable("id") int id, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		
		JSONObject dataInfos = peopleService.getHouseholdInfor(baseEntityId);
		model.addAttribute("reg_info", dataInfos.get("data"));
		
		model.addAttribute("services", peopleService.getServiceList(baseEntityId));
		model.addAttribute("configs",
		    dataViewConfigurationService.getConfigurationByNameFormName(dataInfos.getString("form_name")));
		
		return "people/member_details";
	}
	
	@RequestMapping(value = "/members.html", method = RequestMethod.GET)
	public String memberList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "people/members";
	}
	
	@RequestMapping(value = "/activity-details/{formName}/{id}", method = RequestMethod.GET)
	public String activityDetails(HttpServletRequest request, @PathVariable("formName") String formName,
	                              @PathVariable("id") long id, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		
		JSONObject service = peopleService.getServiceDetails(formName, id);
		model.addAttribute("reg_info", service.get("data"));
		
		model.addAttribute("configs",
		    dataViewConfigurationService.getConfigurationByNameFormName(service.getString("form_name")));
		
		return "dynamic_content";
	}
}
