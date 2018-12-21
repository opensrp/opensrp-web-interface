/**
 * @author proshanto
 * */

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

import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.core.entity.Location;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.LocationTagService;
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

@Controller
public class LocationController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private LocationTagService locationTagServiceImpl;
	
	@Autowired
	private Location location;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_LOCATION_LIST')")
	@RequestMapping(value = "location/location.html", method = RequestMethod.GET)
	public String locationList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		Class<Location> entityClassName = Location.class;
		model.addAttribute("locale", locale);
		paginationUtil.createPagination(request, session, entityClassName);
		return "location/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_HIERARCHY_LOCATION')")
	@RequestMapping(value = "location/hierarchy.html", method = RequestMethod.GET)
	public String locationHierarchy(ModelMap model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		String parentIndication = "#";
		String parentKey = "parent";
		JSONArray data = locationServiceImpl.getLocationDataAsJson(parentIndication, parentKey);
		session.setAttribute("locatationTreeData", data);
		return "location/hierarchy";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_LOCATION')")
	@RequestMapping(value = "location/add.html", method = RequestMethod.GET)
	public ModelAndView saveLocation(ModelMap model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		model.addAttribute("location", new Location());
		String parentLocationName = "";
		locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
		String parentIndication = "-1";
		String parentKey = "parentid";
		JSONArray data = locationServiceImpl.getLocationDataAsJson(parentIndication, parentKey);
		session.setAttribute("locatationTreeData", data);
		return new ModelAndView("location/add", "command", location);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_LOCATION')")
	@RequestMapping(value = "/location/add.html", method = RequestMethod.POST)
	public ModelAndView saveLocation(@RequestParam(value = "parentLocation", required = false) int parentLocationId,
	                                 @RequestParam(value = "locationTag") int tagId,
	                                 @RequestParam(value = "parentLocationName") String parentLocationName,
	                                 @ModelAttribute("location") @Valid Location location, BindingResult binding,
	                                 ModelMap model, HttpSession session, Locale locale) throws Exception {
		location.setName(location.getName().toUpperCase().trim());
		
		boolean chceckInOpenmrs = false;
		if (!locationServiceImpl.locationExistsForUpdate(location, chceckInOpenmrs)) {
			locationServiceImpl.save(locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location,
			    parentLocationId, tagId));
		} else {
			location = locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location, parentLocationId, tagId);
			locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
			locationServiceImpl.setModelAttribute(model, location);
			return new ModelAndView("/location/add");
		}
		
		return new ModelAndView("redirect:/location/location.html?lang=" + locale);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_LOCATION')")
	@RequestMapping(value = "location/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editLocation(ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		Location location = locationServiceImpl.findById(id, "id", Location.class);
		model.addAttribute("id", id);
		model.addAttribute("location", location);
		String parentLocationName = locationServiceImpl.makeParentLocationName(location);
		locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
		return new ModelAndView("location/edit", "command", location);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_LOCATION')")
	@RequestMapping(value = "/location/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editLocation(@RequestParam(value = "parentLocation") int parentLocationId,
	                                 @RequestParam(value = "locationTag") int tagId,
	                                 @RequestParam(value = "parentLocationName") String parentLocationName,
	                                 @ModelAttribute("location") @Valid Location location, BindingResult binding,
	                                 ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws Exception {
		location.setId(id);
		location.setName(location.getName().trim());
		boolean chceckInOpenmrs = true;
		if (!locationServiceImpl.locationExistsForUpdate(location, chceckInOpenmrs)) {
			locationServiceImpl.update(locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location,
			    parentLocationId, tagId));
		} else {
			location = locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location, parentLocationId, tagId);
			locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
			locationServiceImpl.setModelAttribute(model, location);
			return new ModelAndView("/location/edit");
		}
		
		return new ModelAndView("redirect:/location/location.html?lang=" + locale);
		
	}
	
	@RequestMapping(value = "location/search.html", method = RequestMethod.GET)
	public String locationSearch(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		List<Location> locations = locationServiceImpl.getAllByKeysWithALlMatches(name);
		session.setAttribute("searchedLocation", locations);
		return "location/search";
	}
	
	@RequestMapping(value = "/location", method = RequestMethod.GET)
	public String getChildLocationList(HttpServletRequest request, HttpSession session, Model model, @RequestParam int id) {
		List<Object[]> parentData = locationServiceImpl.getChildData(id);
		session.setAttribute("data", parentData);
		return "/location";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_LOCATION')")
	@RequestMapping(value = "location/upload_csv.html", method = RequestMethod.GET)
	public String csvUpload(ModelMap model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("location", new Location());
		model.addAttribute("locale", locale);
		return "/location/upload_csv";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_LOCATION')")
	@RequestMapping(value = "/location/upload_csv.html", method = RequestMethod.POST)
	public ModelAndView csvUpload(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model, Locale locale)
	    throws Exception {
		if (file.isEmpty()) {
			model.put("msg", "failed to upload file because its empty");
			model.addAttribute("msg", "failed to upload file because its empty");
			return new ModelAndView("/location/upload_csv");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "file type should be '.csv'");
			return new ModelAndView("/location/upload_csv");
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
			return new ModelAndView("/location/upload_csv");
		}
		String msg = locationServiceImpl.uploadLocation(csvFile);
		if (!msg.isEmpty()) {
			model.put("msg", msg);
			return new ModelAndView("/location/upload_csv");
		}
		return new ModelAndView("redirect:/location/location.html?lang=" + locale);
	}
}
