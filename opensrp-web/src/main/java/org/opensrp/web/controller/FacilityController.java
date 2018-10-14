package org.opensrp.web.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityTraining;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.FacilityWorkerService;
import org.opensrp.facility.service.FacilityWorkerTrainingService;
import org.opensrp.facility.service.FacilityWorkerTypeService;
import org.opensrp.facility.util.FacilityHelperUtil;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;


@Controller
//@RequestMapping(value = "facility")
public class FacilityController {
	@Autowired
	private FacilityService facilityService;
	
	@Autowired
	private FacilityWorkerService facilityWorkerService;
	
	@Autowired
	private FacilityWorkerTrainingService facilityWorkerTrainingService;
	
	@Autowired
	private FacilityWorkerTypeService facilityWorkerTypeService;
	
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
	

	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY')")
	@RequestMapping(value = "/facility/add.html", method = RequestMethod.GET)
	public ModelAndView addFacility(HttpServletRequest request,ModelMap model, HttpSession session, Locale locale){
		paginationUtil.createPagination(request, session, Facility.class);
		model.addAttribute("locale", locale);
		//facilityHelperUtil.setSessionAttribute(session, facility, locationName);
		return new ModelAndView("facility/add", "command", facility);
		
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY')")
	@RequestMapping(value = "/facility/add.html", method = RequestMethod.POST)
	 public RedirectView saveFacility(
								 @RequestParam(value = "location", required = false) String locationId,
	                             //@RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("facility") @Valid Facility facility, BindingResult binding, ModelMap model,
	                             HttpSession session, Locale locale) throws Exception {
		facility = facilityHelperUtil.setLocationCodesToFacility(facility);
		facilityService.save(facility);
		model.addAttribute("locale", locale);
		return new RedirectView("/opensrp-dashboard/cbhc-dashboard?lang="+locale);
		
	}
	

	//@PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY')")
	@RequestMapping(value = "/cbhc-dashboard", method = RequestMethod.GET)
	public String showFacilityList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
        paginationUtil.createPagination(request, session, Facility.class);
        model.addAttribute("locale", locale);
		return "/facility/index";
	}

	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/addWorker.html", method = RequestMethod.GET)
	public String addWorker(ModelMap model, HttpSession session, Locale locale,@PathVariable("id") int id){
		
		List<FacilityWorkerType> workerTypeList = facilityWorkerTypeService.findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityWorkerTrainingService.findAll("FacilityTraining");
		facilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		facilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		Facility facility = facilityService.findById(id, "id", Facility.class);
		session.setAttribute("facilityName", facility.getName());
		List<FacilityWorker> facilityWorkerList = facilityHelperUtil.getFacilityWorkerList (facility);
		Map<Integer,Integer> distinctWorkerCountMap = facilityHelperUtil.getDistinctWorkerCount(facilityWorkerList);
		session.setAttribute("distinctWorkerCountMap", distinctWorkerCountMap);
		session.setAttribute("facilityId", id);
		model.addAttribute("locale", locale);
		return "facility/add-worker";
		
	}

	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/saveWorker.html", method = RequestMethod.POST)
	public RedirectView saveWorker(HttpServletRequest request,
			ModelMap model,
			@ModelAttribute("facilityWorker") @Valid FacilityWorker facilityWorker,
			@RequestParam(value = "facilityWorkerTypeId", required = false) int facilityWorkerTypeId,
		    @RequestParam(value = "trainings", required = false) String trainings,
			BindingResult binding,
			HttpSession session, Locale locale) throws Exception{
		
		if(!trainings.equals("")){
		String[] trainingList = trainings.split(",");
		
		Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
		for(int i=0; i< trainingList.length; i++){
			FacilityTraining facilityTraining = facilityWorkerTrainingService.findById(Integer.parseInt(trainingList[i]), "id", FacilityTraining.class);
			if(facilityTraining != null){
				facilityTrainings.add(facilityTraining);
			}
			facilityWorker.setFacilityTrainings(facilityTrainings);
		}
		
		}
		FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findById(facilityWorkerTypeId, "id", FacilityWorkerType.class);
		facilityWorker.setFacilityWorkerType(facilityWorkerType);
		facilityWorkerService.save(facilityWorker);
		
		//String facilityDetailsUrlString = "/facility/"+facilityWorker.getFacility().getId()+"/details.html";
		String addWorkerUrlString = "/opensrp-dashboard/facility/" + facilityWorker.getFacility().getId()
		        + "/addWorker.html?lang="+locale;
		model.addAttribute("locale", locale);
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
	

	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/getWorkerList.html", method = RequestMethod.GET)
	public String getWorkerList (ModelMap model, HttpSession session, Locale locale,
			@PathVariable("id") int id){
		
		Facility facility = facilityService.findById(id, "id", Facility.class);
		List<FacilityWorker> facilityWorkerList = facilityHelperUtil.getFacilityWorkerList(facility);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		model.addAttribute("locale", locale);
		return "facility/worker-list";
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{workerId}/editWorker.html", method = RequestMethod.GET)
	public String editWorker (ModelMap model, HttpSession session,Locale locale,
			@PathVariable("workerId") int workerId){
		List<FacilityWorkerType> workerTypeList = facilityWorkerTypeService.findAll("FacilityWorkerType");
		List<FacilityTraining> CHCPTrainingList = facilityWorkerTrainingService.findAll("FacilityTraining");
		facilityHelperUtil.setWorkerTypeListToSession(session, workerTypeList);
		facilityHelperUtil.setCHCPTrainingListToSession(session, CHCPTrainingList);
		
		FacilityWorker facilityWorker = facilityWorkerService.findById(workerId, "id", FacilityWorker.class);
		session.setAttribute("workerToEdit", facilityWorker);
		model.addAttribute("locale", locale);
		return "facility/edit-worker";
       
	}
	
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY')")
	@RequestMapping(value = "/facility/{id}/details.html", method = RequestMethod.GET)
	public String facilityDetails(ModelMap model, HttpSession session,Locale locale,@PathVariable("id") int id){	
		Facility facility = facilityService.findById(id, "id", Facility.class);
		FacilityWorker facilityWorkerObject = facilityWorker;
		facilityWorkerObject.setFacility(facility);
		model.addAttribute("facilityWorker", facilityWorkerObject);
		
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityWorkerService.findAllByKeys(facilityMap, FacilityWorker.class);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		model.addAttribute("locale", locale);
		model.addAttribute("facility", facility);
		
		return "facility/details";
		
	}
	

	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_FACILITY_CSV')")
	@RequestMapping(value = "/facility/upload_csv.html", method = RequestMethod.GET)
	public String csvUpload(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		return "/facility/upload_csv";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_FACILITY_CSV')")
	@RequestMapping(value = "/facility/upload_csv.html", method = RequestMethod.POST)
	public ModelAndView csvUpload(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model,  Locale locale)
	    throws Exception {
		if (file.isEmpty()) {
			model.put("msg", "failed to upload file because its empty");
			model.addAttribute("msg", "failed to upload file because its empty");
			return new ModelAndView("/facility/upload_csv");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "file type should be '.csv'");
			return new ModelAndView("/facility/upload_csv");
		}
		
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		File dir = new File(rootPath + File.separator + "uploadedfile");
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		File csvFile = new File(dir.getAbsolutePath() + File.separator + file.getOriginalFilename());
		
		try {
			try (InputStream is = file.getInputStream();
			        BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(csvFile))) {
				int i;
				
				while ((i = is.read()) != -1) {
					stream.write(i);
				}
				stream.flush();
			}
		}
		catch (IOException e) {
			model.put("msg", "failed to process file because : " + e.getMessage());
			return new ModelAndView("/facility/upload_csv");
		}
		String msg = facilityHelperUtil.uploadFacility(csvFile);
		
		//used for populating chcp table temporarily
		//String msg = facilityHelperUtil.uploadChcp(csvFile);
		model.addAttribute("locale", locale);
		if (!msg.isEmpty()) {
			model.put("msg", msg);
			return new ModelAndView("/facility/upload_csv");
		}
		return new ModelAndView("redirect:/cbhc-dashboard?lang="+locale);
	}
	
	@RequestMapping(value = "facility/searchWorkerName.html", method = RequestMethod.GET)
	public String providerSearch(Model model, HttpSession session,Locale locale, @RequestParam String name, @RequestParam String workerTypeId) throws JSONException {
		List<String> workers = facilityHelperUtil.getAllWorkersNameByKeysWithALlMatches(name,workerTypeId);
		session.setAttribute("searchedWorkers", workers);
		model.addAttribute("locale", locale);
		return "facility/search-worker-name";
	}

}
