package org.opensrp.web.controller;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.opensrp.facility.util.FacilityHelperUtil;
import org.opensrp.facility.util.FacilityServiceFactory;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;


@Controller
@RequestMapping(value = "facility")
public class FacilityController {
	
	@Autowired
	private FacilityServiceFactory facilityServiceFactory;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private Facility facility;
	
	@Autowired
	private FacilityWorker facilityWorker;
	
	
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView addFacility(ModelMap model, HttpSession session){
		String locationName = "";
		
		FacilityHelperUtil.setSessionAttribute(session, facility, locationName);
		return new ModelAndView("facility/add", "command", facility);
       
	}

	@RequestMapping(value = "/add.html", method = RequestMethod.POST)
	 public RedirectView saveFacility(
								 @RequestParam(value = "location", required = false) String locationId,
	                             //@RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("facility") @Valid Facility facility, BindingResult binding, ModelMap model,
	                             HttpSession session) throws Exception {
		
		facilityServiceFactory.getFacility("FacilityServiceImpl").save(facility);
		return new RedirectView("/facility/index.html");
		
	}
	
	@RequestMapping(value = "/index.html", method = RequestMethod.GET)
	public String showFacilityList(HttpServletRequest request, HttpSession session) {
        paginationUtil.createPagination(request, session, Facility.class);
		return "/facility/index";
	}
	
	@RequestMapping(value = "/{id}/addWorker.html", method = RequestMethod.GET)
	public ModelAndView addWorker(ModelMap model, HttpSession session,@PathVariable("id") int id){
		
		List<FacilityWorkerType> workerTypeList = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityServiceFactory.getFacility("FacilityWorkerTrainingServiceImpl").findAll("FacilityTraining");
		FacilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		FacilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		FacilityWorker facilityWorkerObject = facilityWorker;
		facilityWorkerObject.setFacility(facility);
		model.addAttribute("facilityWorker", facilityWorkerObject);
		
		/*List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findById(facility.getId(), "id", FacilityWorker.class);
		FacilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);*/
		
		return new ModelAndView("facility/add-worker", "command", facilityWorker);
       
	}
	
	
	@RequestMapping(value = "/saveWorker.html", method = RequestMethod.POST)
	public RedirectView saveWorker(HttpServletRequest request,
			ModelMap model,
			@ModelAttribute("facility") @Valid FacilityWorker facilityWorker,
			@RequestParam(value = "facilityWorkerTypeId", required = false) int facilityWorkerTypeId,
		    @RequestParam(value = "trainings", required = false) String trainings,
			BindingResult binding,
			HttpSession session) throws Exception{
		
		if(!trainings.equals("")){
		String[] trainingList = trainings.split(",");
		//System.out.println(trainings+" >>>>> <<<<<");
		
		Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
		for(int i=0; i< trainingList.length; i++){
			FacilityTraining facilityTraining = facilityServiceFactory.getFacility("FacilityTrainingServiceImpl").findById(Integer.parseInt(trainingList[i]), "id", FacilityTraining.class);
			if(facilityTraining != null){
				facilityTrainings.add(facilityTraining);
			}
		}
		facilityWorker.setFacilityTrainings(facilityTrainings);
		}
		
		FacilityWorkerType facilityWorkerType = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findById(facilityWorkerTypeId, "id", FacilityWorkerType.class);
		facilityWorker.setFacilityWorkerType(facilityWorkerType);
		facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").save(facilityWorker);
		
		
		return new RedirectView("/facility/index.html");
       
	}
	
	/*@RequestMapping(value = "/showWorkerList.html", method = RequestMethod.GET)
	public  @ResponseBody List<FacilityWorker> showWorkerList (ModelMap model, HttpSession session){
		
		List<FacilityWorker> facilityWorkerList = new ArrayList<FacilityWorker>();
		
		return facilityWorkerList;
       
	}*/
	
	
	@RequestMapping(value = "/{id}/details.html", method = RequestMethod.GET)
	public String facilityDetails(ModelMap model, HttpSession session,@PathVariable("id") int id){
		
		/*List<FacilityWorkerType> workerTypeList = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityServiceFactory.getFacility("FacilityWorkerTrainingServiceImpl").findAll("FacilityTraining");
		FacilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		FacilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);*/
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		FacilityWorker facilityWorkerObject = facilityWorker;
		facilityWorkerObject.setFacility(facility);
		model.addAttribute("facilityWorker", facilityWorkerObject);
		
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findAllByKeys(facilityMap, FacilityWorker.class);
		FacilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		
		model.addAttribute("facility", facility);
		
		//return new ModelAndView("facility/details", "command", facility);
		return "facility/details";
       
	}

}
