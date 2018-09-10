package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.util.FacilityHelperUtil;
import org.opensrp.facility.util.FacilityServiceFactory;
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
	
	@Autowired
	private Facility facility;
	@Autowired
	private FacilityServiceFactory facilityServiceFactory;
	
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView addFacility(ModelMap model, HttpSession session){
		model.addAttribute("facility", new Facility());
		String locationName = "";
		
		FacilityHelperUtil.setSessionAttribute(session, facility, locationName);
		return new ModelAndView("facility/add", "command", facility);
       
	}

	@RequestMapping(value = "/add.html", method = RequestMethod.POST)
	public ModelAndView saveFacility(
								 @RequestParam(value = "location", required = false) String locationId,
	                             //@RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("facility") @Valid Facility facility, BindingResult binding, ModelMap model,
	                             HttpSession session) throws Exception {
		
		facilityServiceFactory.getFacility("FacilityServiceImpl").save(facility);
		return new ModelAndView("/facility/add", "command", facility);
		
	}
	
	@RequestMapping(value = "/index.html", method = RequestMethod.GET)
	public String showFacilityList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, Facility.class);
		return "/facility/index";
	}
	
	/*@RequestMapping(value = "/addWorker.html", method = RequestMethod.GET)
	public ModelAndView addWorker(ModelMap model, HttpSession session){
		model.addAttribute("facilityWorker", new FacilityWorker());
		
		List<String> workerTypeList = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findAll("FacilityWorkerType");
		List<String> CHCPTrainingList = facilityServiceFactory.getFacility("FacilityWorkerTrainingServiceImpl").findAll("FacilityTraining");
		
		FacilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		FacilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		return new ModelAndView("facility/add", "command", facility);
       
	}*/
	
	

}
