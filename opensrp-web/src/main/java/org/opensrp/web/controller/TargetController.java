/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "target")
public class TargetController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	private int divisionTagId = 35;
	
	@RequestMapping(value = "/sk-pa-list-for-individual-target.html", method = RequestMethod.GET)
	public String listTeam(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		System.err.println("dd;" + targetService.getLocationByTagId(divisionTagId));
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "target/sk-pa-list-for-individual-target";
	}
	
}
