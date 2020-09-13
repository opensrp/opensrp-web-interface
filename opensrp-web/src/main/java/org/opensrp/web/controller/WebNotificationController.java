/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.common.util.WebNotificationType;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.WebNotification;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.WebNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "web-notification")
public class WebNotificationController {
	
	@Autowired
	private WebNotificationService webNotificationService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@Autowired
	private LocationService locationService;
	
	@RequestMapping(value = "/list.html", method = RequestMethod.GET)
	public String targetByIndividual(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("roles", webNotificationService.getWebNotificationRoles());
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		return "webNotification/list";
	}
	
	@RequestMapping(value = "/target-by-position-list.html", method = RequestMethod.GET)
	public String targetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		return "targets/target-by-position-list";
	}
	
	@RequestMapping(value = "/add-new.html", method = RequestMethod.GET)
	public String addNew(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("roles", webNotificationService.getWebNotificationRoles());
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		return "webNotification/add";
	}
	
	@RequestMapping(value = "/edit/{id}.html", method = RequestMethod.GET)
	public String edit(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                   @PathVariable("id") long id) {
		model.addAttribute("locale", locale);
		WebNotification webNotification = webNotificationService.findById(id, "id", WebNotification.class);
		List<Location> districts = locationService.getChildLocation(webNotification.getDivision());
		List<Location> Upazilas = locationService.getChildLocation(webNotification.getDistrict());
		model.addAttribute("districts", districts);
		model.addAttribute("Upazilas", Upazilas);
		model.addAttribute("id", id);
		String dateTime = "";
		if (webNotification.getType().equalsIgnoreCase(WebNotificationType.SCHEDULE.name())) {
			dateTime = webNotification.getSendDate() + " " + webNotification.getSendTimeHour() + ":"
			        + webNotification.getSendTimeMinute();
		}
		System.err.println("dateTime:" + dateTime);
		model.addAttribute("dateTime", dateTime);
		model.addAttribute("webNotification", webNotification);
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		return "webNotification/edit";
	}
	
}
