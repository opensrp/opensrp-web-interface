/**
 * @author proshanto
 * */

package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.acl.service.impl.LocationTagServiceImpl;
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
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LocationController {
	
	@Autowired
	private LocationServiceImpl locationServiceImpl;
	
	@Autowired
	private LocationTagServiceImpl locationTagServiceImpl;
	
	@Autowired
	private Location location;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_LOCATION')")
	@RequestMapping(value = "location.html", method = RequestMethod.GET)
	public String locationList(HttpServletRequest request, HttpSession session, Model model) {
		
		Class<Location> entityClassName = Location.class;
		paginationUtil.createPagination(request, session, entityClassName);
		return "location/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_HIERARCHY_LOCATION')")
	@RequestMapping(value = "location/hierarchy.html", method = RequestMethod.GET)
	public String locationHierarchy(Model model, HttpSession session) throws JSONException {
		String parentIndication = "#";
		String parentKey = "parent";
		JSONArray data = locationServiceImpl.getLocationDataAsJson(parentIndication, parentKey);
		session.setAttribute("locatationTreeData", data);
		return "location/hierarchy";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_LOCATION')")
	@RequestMapping(value = "location/add.html", method = RequestMethod.GET)
	public ModelAndView saveLocation(ModelMap model, HttpSession session) throws JSONException {
		
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
	                                 ModelMap model, HttpSession session) throws Exception {
		location.setName(location.getName().trim());
		if (!locationServiceImpl.locationExists(location)) {
			locationServiceImpl.save(locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location,
			    parentLocationId, tagId));
		} else {
			location = locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location, parentLocationId, tagId);
			locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
			locationServiceImpl.setModelAttribute(model, location);
			return new ModelAndView("/location/add");
		}
		
		return new ModelAndView("redirect:/location.html");
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_LOCATION')")
	@RequestMapping(value = "location/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editLocation(ModelMap model, HttpSession session, @PathVariable("id") int id) {
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
	                                 ModelMap model, HttpSession session, @PathVariable("id") int id) throws Exception {
		location.setId(id);
		location.setName(location.getName().trim());
		
		if (!locationServiceImpl.locationExists(location)) {
			locationServiceImpl.update(locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location,
			    parentLocationId, tagId));
		} else {
			location = locationServiceImpl.setCreatorParentLocationTagAttributeInLocation(location, parentLocationId, tagId);
			locationServiceImpl.setSessionAttribute(session, location, parentLocationName);
			locationServiceImpl.setModelAttribute(model, location);
			return new ModelAndView("/location/edit");
		}
		
		return new ModelAndView("redirect:/location.html");
		
	}
	
	
	@RequestMapping(value = "location/search.html", method = RequestMethod.GET)
	public String locationSearch(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		List<Location> locations = locationServiceImpl.getAllByKeysWithALlMatches(name);
		session.setAttribute("searchedLocation", locations);
		return "location/search";
	}
}
