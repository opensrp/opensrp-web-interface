package org.opensrp.web.rest.controller;

import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.opensrp.acl.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("rest/api/v1/location")
@RestController
public class LocationRestController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String getLocationNameAndId(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		return locationServiceImpl.search(name).toString();
		
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String getLocationList(Model model, HttpSession session) throws JSONException {
		return locationServiceImpl.list().toString();
		
	}
}
