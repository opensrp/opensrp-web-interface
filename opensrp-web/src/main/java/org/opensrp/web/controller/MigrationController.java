/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.MigrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonProcessingException;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "migration")
public class MigrationController {
	
	@Autowired
	private MigrationService migrationService;
	
	@Autowired
	private BranchService branchService;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@RequestMapping(value = "/households-in.html", method = RequestMethod.GET)
	public String householdList(HttpServletRequest request, HttpSession session, Model model, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		
		model.addAttribute("isHousehold", true);
		return "migration/households-in";
	}
	
	@RequestMapping(value = "/details-data/{id}", method = RequestMethod.GET)
	public String activityDetails(HttpServletRequest request, @PathVariable("id") long id, HttpSession session, Model model,
	                              Locale locale) throws JSONException, JsonProcessingException {
		model.addAttribute("locale", locale);
		
		JSONObject data = migrationService.getMigratedData(id);
		
		model.addAttribute("data", data);
		
		return "migration/details";
	}
}
