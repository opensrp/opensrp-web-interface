package org.opensrp.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.opensrp.acl.entity.Team;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.impl.FacilityServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping(value = "facility")
public class FacilityController {
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	
    private FacilityServiceImpl facilityServiceImpl;
	private FacilityService facilityService;
	@Autowired
	private Facility facility;
	FacilityController(FacilityServiceImpl facilityServiceImpl){
		this.facilityService = this.facilityServiceImpl;
	}
	
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateEvent(ModelMap model, HttpSession session){
		model.addAttribute("facility", new Facility());
		String locationName = "";
		
		facilityServiceImpl.setSessionAttribute(session, facility, locationName);
		return new ModelAndView("facility/add", "command", facility);
       
	}

	@RequestMapping(value = "/add.html", method = RequestMethod.POST)
	public ModelAndView saveTeam(
								 @RequestParam(value = "location", required = false) String locationId,
	                             //@RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("facility") @Valid Facility facility, BindingResult binding, ModelMap model,
	                             HttpSession session) throws Exception {
		
		facilityServiceImpl.save(facility);
		return new ModelAndView("/facility/add", "command", facility);
		
	}
	
	@RequestMapping(value = "/index.html", method = RequestMethod.GET)
	public String showChildList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, Facility.class);
		return "/facility/index";
	}
	
	

}
