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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "web-notification")
public class WebNotificationController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@RequestMapping(value = "/list.html", method = RequestMethod.GET)
	public String targetByIndividual(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "webNotification/list";
	}
	
	@RequestMapping(value = "/target-by-position-list.html", method = RequestMethod.GET)
	public String targetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "targets/target-by-position-list";
	}
	
}
