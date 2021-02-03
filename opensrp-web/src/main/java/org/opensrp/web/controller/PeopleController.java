/**
 * 
 */
package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ActivityListDTO;
import org.opensrp.common.dto.ClientListDTO;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonProcessingException;

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
	
	@Value("#{opensrp['submenu.selected.color']}")
	private String submenuSelectedColor;
	
	@RequestMapping(value = "/households.html", method = RequestMethod.GET)
	public String householdList(HttpServletRequest request, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		model.addAttribute("isHousehold", true);
		model.addAttribute("people", "block");
		
		model.addAttribute("selectHHSubMenu", submenuSelectedColor);
		return "people/households";
	}
	
	@RequestMapping(value = "/households-datatable.html", method = RequestMethod.POST)
	public String householdsDataTable(@RequestBody String dto, HttpSession session, Model model, Locale locale)
	    throws JSONException, JsonProcessingException, InterruptedException {
		model.addAttribute("locale", locale);
		JSONObject jo = new JSONObject(dto);
		List<ClientListDTO> data = peopleService.getHouseholdData(jo);
		
		model.addAttribute("households", data);
		model.addAttribute("people", "block");
		return "people/household-list-table";
	}
	
	@RequestMapping(value = "/household-details/{baseEntityId}/{id}.html", method = RequestMethod.GET)
	public String householdDetails(HttpServletRequest request, @PathVariable("baseEntityId") String baseEntityId,
	                               @PathVariable("id") Long id, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		JSONObject jo = new JSONObject();
		jo.put("relation_id", baseEntityId);
		List<String> data = peopleService.getMemberList(jo, 404, 404);
		List<ClientListDTO> members = new ArrayList<>();
		for (String string : data) {
			ClientListDTO cl = new ClientListDTO();
			
			JSONObject json = new JSONObject(string);
			cl.setMemberName(json.get("first_name") + "");
			cl.setMemberId(json.get("member_id") + "");
			cl.setRelationWithHousehold(json.get("relation_with_household_head") + "");
			cl.setDob(json.get("birthdate") + "");
			cl.setAge(json.get("member_age_year") + "");
			cl.setGender(json.get("gender") + "");
			cl.setVillage(json.get("village") + "");
			cl.setBranchCode(json.getString("code") + "");
			cl.setBranchName(json.get("branch_name") + " ");
			cl.setId(json.getLong("id"));
			cl.setBaseEntityId(json.getString("base_entity_id"));
			
			members.add(cl);
		}
		
		List<ActivityListDTO> dataInfos = peopleService.getServiceInfo(baseEntityId, id, "household");
		
		JSONObject details = new JSONObject();
		for (ActivityListDTO activityListDTO : dataInfos) {
			
			if (activityListDTO.getQuestion().equalsIgnoreCase("unique_id")) {
				details.put("unique_id", activityListDTO.getAnswer());
			} else if (activityListDTO.getQuestion().equalsIgnoreCase("first_name")) {
				details.put("first_name", activityListDTO.getAnswer());
			}
		}
		
		model.addAttribute("infos", dataInfos);
		model.addAttribute("rawData", details);
		
		model.addAttribute("services", peopleService.getServiceList(baseEntityId, "HH"));
		model.addAttribute("configs", dataViewConfigurationService.getConfigurationByNameFormName("household"));
		model.addAttribute("members", members);
		model.addAttribute("people", "block");
		model.addAttribute("selectHHSubMenu", submenuSelectedColor);
		return "people/household_details";
	}
	
	@RequestMapping(value = "/member-details/{baseEntityId}/{id}.html", method = RequestMethod.GET)
	public String memberDetails(HttpServletRequest request, @PathVariable("baseEntityId") String baseEntityId,
	                            @PathVariable("id") Long id, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		
		List<ActivityListDTO> dataInfos = peopleService.getMemberInfo(baseEntityId);
		JSONObject details = new JSONObject();
		for (ActivityListDTO activityListDTO : dataInfos) {
			
			if (activityListDTO.getQuestion().equalsIgnoreCase("member_id")) {
				details.put("member_id", activityListDTO.getAnswer());
			} else if (activityListDTO.getQuestion().equalsIgnoreCase("first_name")) {
				details.put("first_name", activityListDTO.getAnswer());
			} else if (activityListDTO.getQuestion().equalsIgnoreCase("member_age")) {
				details.put("member_age", activityListDTO.getAnswer());
			} else if (activityListDTO.getQuestion().equalsIgnoreCase("gender")) {
				details.put("gender", activityListDTO.getAnswer());
			}
		}
		
		model.addAttribute("infos", dataInfos);
		model.addAttribute("rawData", details);
		model.addAttribute("services", peopleService.getServiceList(baseEntityId, "Member"));
		model.addAttribute("configs", dataViewConfigurationService.getConfigurationByNameFormName("member"));
		model.addAttribute("people", "block");
		model.addAttribute("selectMemberSubMenu", submenuSelectedColor);
		return "people/member_details";
	}
	
	@RequestMapping(value = "/members.html", method = RequestMethod.GET)
	public String memberList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		model.addAttribute("people", "block");
		model.addAttribute("selectMemberSubMenu", submenuSelectedColor);
		return "people/members";
	}
	
	/*@RequestMapping(value = "/members-datatable.html", method = RequestMethod.POST)
	public String memberDataTable(@RequestBody String dto, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		JSONObject jo = new JSONObject(dto);
		
		List<ClientListDTO> data = peopleService.getMemberList(jo, jo.getInt("startAge"), jo.getInt("endAge"));
		model.addAttribute("members", data);
		model.addAttribute("people", "block");
		return "people/member-list-table";
	}*/
	
	@RequestMapping(value = "/activity-details/{formName}/{id}/{serviceName}", method = RequestMethod.GET)
	public String activityDetails(HttpServletRequest request, @PathVariable("formName") String formName,
	                              @PathVariable("id") long id, @PathVariable("serviceName") String serviceName,
	                              HttpSession session, Model model, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		
		List<ActivityListDTO> service = peopleService.getServiceInfo("", id, formName);
		/*String ancPNCServiceName = service.getString("form_name");
		if (!ancPNCServiceName.isEmpty()) {
			serviceName = ancPNCServiceName;
			
		}*/
		model.addAttribute("serviceName", serviceName);
		model.addAttribute("infos", service);
		
		model.addAttribute("configs", dataViewConfigurationService.getConfigurationByNameFormName(formName));
		model.addAttribute("people", "block");
		return "dynamic_content";
	}
}
