package org.opensrp.web.controller;

import static org.springframework.http.HttpStatus.OK;

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
import org.springframework.http.ResponseEntity;
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

import com.google.gson.Gson;


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
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;
	
	
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView addFacility(ModelMap model, HttpSession session){
		String locationName = "";
		
		facilityHelperUtil.setSessionAttribute(session, facility, locationName);
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
	
	/*@RequestMapping(value = "/{id}/addWorker.html", method = RequestMethod.GET)
	public ModelAndView addWorker(ModelMap model, HttpSession session,@PathVariable("id") int id){
		
		List<FacilityWorkerType> workerTypeList = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityServiceFactory.getFacility("FacilityWorkerTrainingServiceImpl").findAll("FacilityTraining");
		facilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		facilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		FacilityWorker facilityWorkerObject = new FacilityWorker();
		facilityWorkerObject.setFacility(facility);
		model.addAttribute("facilityWorker", facilityWorkerObject);
		
		return new ModelAndView("facility/add-worker", "command", facilityWorker);
       
	}*/
	
	@RequestMapping(value = "/{id}/addWorker.html", method = RequestMethod.GET)
	public String addWorker(ModelMap model, HttpSession session,@PathVariable("id") int id){
		
		List<FacilityWorkerType> workerTypeList = facilityServiceFactory.getFacility("FacilityWorkerTypeServiceImpl").findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityServiceFactory.getFacility("FacilityWorkerTrainingServiceImpl").findAll("FacilityTraining");
		facilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		facilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		session.setAttribute("facilityId", id);
		return "facility/add-worker-temp";
       
	}
	
	
	@RequestMapping(value = "/saveWorker.html", method = RequestMethod.POST)
	public RedirectView saveWorker(HttpServletRequest request,
			ModelMap model,
			@ModelAttribute("facilityWorker") @Valid FacilityWorker facilityWorker,
			@RequestParam(value = "facilityWorkerTypeId", required = false) int facilityWorkerTypeId,
		    @RequestParam(value = "trainings", required = false) String trainings,
			BindingResult binding,
			HttpSession session) throws Exception{
		
		if(!trainings.equals("")){
		String[] trainingList = trainings.split(",");
		
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
		
		//String facilityDetailsUrlString = "/facility/"+facilityWorker.getFacility().getId()+"/details.html";
		String addWorkerUrlString = "/facility/"+facilityWorker.getFacility().getId()+"/addWorker.html";
		return new RedirectView(addWorkerUrlString);
       
	}
	
	/*@RequestMapping(value = "/{id}/getWorkerList.html", method = RequestMethod.GET)
	public ResponseEntity<String> getWorkerList (ModelMap model, HttpSession session,
			@PathVariable("id") int id){
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findAllByKeys(facilityMap, FacilityWorker.class);
		
		return new ResponseEntity<>(new Gson().toJson(facilityWorkerList), OK);
       
	}*/
	
	@RequestMapping(value = "/{id}/getWorkerList.html", method = RequestMethod.GET)
	public String getWorkerList (ModelMap model, HttpSession session,
			@PathVariable("id") int id){
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findAllByKeys(facilityMap, FacilityWorker.class);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		return "facility/worker-list";
       
	}
	
	
	@RequestMapping(value = "/{id}/details.html", method = RequestMethod.GET)
	public String facilityDetails(ModelMap model, HttpSession session,@PathVariable("id") int id){
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		FacilityWorker facilityWorkerObject = facilityWorker;
		facilityWorkerObject.setFacility(facility);
		model.addAttribute("facilityWorker", facilityWorkerObject);
		
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findAllByKeys(facilityMap, FacilityWorker.class);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		
		model.addAttribute("facility", facility);
		
		return "facility/details-temp";
       
	}

}
