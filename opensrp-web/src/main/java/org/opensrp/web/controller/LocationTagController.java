package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.entity.LocationTag;
import org.opensrp.acl.service.impl.LocationTagServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LocationTagController {
	
	@Autowired
	private LocationTagServiceImpl locationTagServiceImpl;
	
	@Autowired
	private LocationTag locationTag;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_LOCATION_TAG_LIST')")
	@RequestMapping(value = "location/tag/list.html", method = RequestMethod.GET)
	public String locationList(ModelMap model, Locale locale) {
		List<LocationTag> locations = locationTagServiceImpl.findAll("LocationTag");
		model.addAttribute("locationTags", locations);
		model.addAttribute("locale", locale);
		return "location-tag/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_LOCATION_TAG')")
	@RequestMapping(value = "location/tag/add.html", method = RequestMethod.GET)
	public ModelAndView saveLocation(ModelMap model, HttpSession session, Locale locale) {
		model.addAttribute("locationTag", new Location());
		model.addAttribute("locale", locale);
		return new ModelAndView("location-tag/add", "command", locationTag);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_LOCATION_TAG')")
	@RequestMapping(value = "/location/tag/add.html", method = RequestMethod.POST)
	public ModelAndView saveLocation(@ModelAttribute("locationTag") @Valid LocationTag locationTag, BindingResult binding,
	                                 ModelMap model, HttpSession session, Locale locale) throws Exception {
		locationTag.setName(locationTag.getName().trim());
		if (!locationTagServiceImpl.locationTagExists(locationTag)) {
			locationTagServiceImpl.save(locationTag);
		} else {
			locationTagServiceImpl.setModelAttribute(model, locationTag);
			return new ModelAndView("/location-tag/add");
		}
		
		return new ModelAndView("redirect:/location/tag/list.html?lang=" + locale);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_LOCATION_TAG')")
	@RequestMapping(value = "location/tag/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editRole(ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		LocationTag locationTag = locationTagServiceImpl.findById(id, "id", LocationTag.class);
		model.addAttribute("locationTag", locationTag);
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return new ModelAndView("location-tag/edit", "command", locationTag);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_LOCATION_TAG')")
	@RequestMapping(value = "/location/tag/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editRole(@ModelAttribute("locationTag") @Valid LocationTag locationTag, BindingResult binding,
	                             ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws JSONException {
		locationTag.setId(id);
		locationTag.setName(locationTag.getName().trim());
		
		if (!locationTagServiceImpl.locationTagExists(locationTag)) {
			locationTagServiceImpl.update(locationTag);
		} else {
			locationTagServiceImpl.setModelAttribute(model, locationTag);
			return new ModelAndView("/location-tag/edit");
		}
		
		return new ModelAndView("redirect:/location/tag/list.html?lang=" + locale);
		
	}
	
}
