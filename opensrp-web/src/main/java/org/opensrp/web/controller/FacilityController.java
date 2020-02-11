package org.opensrp.web.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.json.JSONException;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.FacilityWorkerService;
import org.opensrp.core.service.FacilityWorkerTrainingService;
import org.opensrp.core.service.FacilityWorkerTypeService;
import org.opensrp.core.util.FacilityHelperUtil;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
// @RequestMapping(value = "facility")
public class FacilityController {
	
	@Autowired
	private FacilityService facilityService;
	
	@Autowired
	private FacilityWorkerService facilityWorkerService;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
	private Facility facility;
	
	@Autowired
	private FacilityWorker facilityWorker;
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;

	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Value("#{opensrp['bahmni.url']}")
	private String BAHMNI_VISIT_URL;
	
	
	private static final Logger logger = Logger.getLogger(FacilityController.class);
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY')")
	@RequestMapping(value = "/facility/add.html", method = RequestMethod.GET)
	public ModelAndView addFacility(HttpServletRequest request, ModelMap model, HttpSession session, Locale locale) {
		paginationUtil.createPagination(request, session, Facility.class);
		model.addAttribute("locale", locale);
		return new ModelAndView("facility/add", "command", facility);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY')")
	@RequestMapping(value = "/facility/add.html", method = RequestMethod.POST)
	public RedirectView saveFacility(@RequestParam(value = "location", required = false) String locationId,
	                                 // @RequestParam(value = "locationName") String locationName,
	                                 @ModelAttribute("facility") @Valid Facility facility, BindingResult binding,
	                                 ModelMap model, HttpSession session, Locale locale) throws Exception {
		facilityService.saveFacility(facility);
		model.addAttribute("locale", locale);
		return new RedirectView("/opensrp-dashboard/cbhc-dashboard?lang=" + locale);
	}
	
	// @PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY')")
	@RequestMapping(value = "/cbhc-dashboard", method = RequestMethod.GET)
	public String showFacilityList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, Facility.class);
		model.addAttribute("locale", locale);
		return "/facility/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/addWorker.html", method = RequestMethod.GET)
	public String addWorker(ModelMap model, HttpSession session, Locale locale, @PathVariable("id") int facilityId) {
		facilityWorkerService.setWorkerToAddToSession(session, facilityId);
		Facility facility = facilityService.findById(facilityId, "id", Facility.class);
		model.addAttribute("facility", facility);
		model.addAttribute("locale", locale);
		session.setAttribute("bahmniVisitURL", BAHMNI_VISIT_URL);
		return "facility/add-new-worker";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/addCgCsg.html", method = RequestMethod.GET)
	public String addCgCsg(ModelMap model, HttpSession session, Locale locale, @PathVariable("id") int facilityId) {
		facilityWorkerService.setWorkerToAddToSession(session, facilityId);
		Facility facility = facilityService.findById(facilityId, "id", Facility.class);
		model.addAttribute("facility", facility);
		model.addAttribute("locale", locale);
		session.setAttribute("bahmniVisitURL", BAHMNI_VISIT_URL);
		return "facility/add-community-group";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/updateProfile.html", method = RequestMethod.GET)
	public String updateWorker(ModelMap model, HttpSession session, Locale locale, @PathVariable("id") int facilityId) {
		facilityWorkerService.setWorkerToAddToSession(session, facilityId);
		Facility facility = facilityService.findById(facilityId, "id", Facility.class);
		model.addAttribute("facility", facility);
		model.addAttribute("locale", locale);
		session.setAttribute("bahmniVisitURL", BAHMNI_VISIT_URL);
		return "facility/add-worker";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/saveWorker.html", method = RequestMethod.POST)
	public RedirectView saveWorker(HttpServletRequest request, ModelMap model,
	                               @ModelAttribute("facilityWorker") @Valid FacilityWorker facilityWorker,
	                               @RequestParam(value = "facilityWorkerTypeId", required = false) int facilityWorkerTypeId,
	                               @RequestParam(value = "trainings", required = false) String trainings,
	                               BindingResult binding, HttpSession session, Locale locale) throws Exception {
		facilityWorkerService.saveFacilityWorker(facilityWorker, facilityWorkerTypeId, trainings);
		String addWorkerUrlString = "/opensrp-dashboard/facility/" + facilityWorker.getFacility().getId()
		        + "/addWorker.html?lang=" + locale;
		model.addAttribute("locale", locale);
		return new RedirectView(addWorkerUrlString);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{id}/getWorkerList.html", method = RequestMethod.GET)
	public String getWorkerList(ModelMap model, HttpSession session, Locale locale, @PathVariable("id") int facilityId) {
		List<FacilityWorker> facilityWorkerList = facilityService.getFacilityWorkerList(facilityId);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		model.addAttribute("locale", locale);
		return "facility/worker-list";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_FACILITY_WORKER')")
	@RequestMapping(value = "/facility/{workerId}/editWorker.html", method = RequestMethod.GET)
	public String editWorker(ModelMap model, HttpSession session, Locale locale, @PathVariable("workerId") int workerId) {
	    facilityWorkerService.setWorkerToEditToSession(session, workerId);
		model.addAttribute("locale", locale);
		return "facility/edit-worker";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_FACILITY')")
	@RequestMapping(value = "/facility/{id}/details.html", method = RequestMethod.GET)
	public String facilityDetails(ModelMap model, HttpSession session, Locale locale, @PathVariable("id") int facilityId) {

		logger.info("\nRequest incoming started!! "+System.currentTimeMillis());

		Facility facility = facilityService.findById(facilityId, "id", Facility.class);
		model.addAttribute("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityService.getFacilityWorkerList(facilityId);
		facilityHelperUtil.setFacilityWorkerListToSession(session, facilityWorkerList);
		session.setAttribute("bahmniVisitURL", BAHMNI_VISIT_URL);
		model.addAttribute("locale", locale);

		logger.info("\nRequest incoming end!! "+System.currentTimeMillis()+"\n");

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
	public ModelAndView csvUpload(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model, Locale locale)
	    throws Exception {
		if (file.isEmpty()) {
			model.put("msg", "Failed to upload the file because it is empty");
			model.addAttribute("msg", "Failed to upload the file because it is empty");
			return new ModelAndView("/facility/upload_csv");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "File type should be '.csv'");
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
		
		// used for populating chcp table temporarily
		// String msg = facilityHelperUtil.uploadChcp(csvFile);
		model.addAttribute("locale", locale);
		if (!msg.isEmpty()) {
			model.put("msg", msg);
			return new ModelAndView("/facility/upload_csv");
		}
		return new ModelAndView("redirect:/cbhc-dashboard?lang=" + locale);
	}
	
	@RequestMapping(value = "facility/searchWorkerName.html", method = RequestMethod.GET)
	public String providerSearch(Model model, HttpSession session, Locale locale, @RequestParam String name,
	                             @RequestParam String workerTypeId) throws JSONException {
		List<String> workers = facilityHelperUtil.getAllWorkersNameByKeysWithALlMatches(name, workerTypeId);
		session.setAttribute("searchedWorkers", workers);
		model.addAttribute("locale", locale);
		return "facility/search-worker-name";
	}

	@RequestMapping(value = "facility/uhfpo-dashboard.html", method = RequestMethod.GET)
	public String getUHFPOData(Model model, HttpSession session, Locale locale) {

		List<Object []> upazilaList = databaseServiceImpl.getUpazilaList();

		session.setAttribute("upazilaList", upazilaList);

		model.addAttribute("locale", locale);
		return "facility/uhfpo-dashboard";
	}
}
