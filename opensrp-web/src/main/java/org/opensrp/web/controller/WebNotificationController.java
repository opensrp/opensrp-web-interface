/**
 * 
 */
package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.dto.WebNotificationCommonDTO;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.common.util.WebNotificationType;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.entity.WebNotification;
import org.opensrp.core.entity.WebNotificationBranch;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.WebNotificationService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.BranchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.firebase.messaging.FirebaseMessagingException;

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
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	public BranchUtil branchUtil;
	
	@Value("#{opensrp['submenu.selected.color']}")
	private String submenuSelectedColor;
	
	@RequestMapping(value = "/list.html", method = RequestMethod.GET)
	public String targetByIndividual(HttpServletRequest request, HttpSession session, Model model, Locale locale)
	    throws FirebaseMessagingException {
		model.addAttribute("locale", locale);
		model.addAttribute("roles", webNotificationService.getWebNotificationRoles());
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		List<WebNotificationType> types = Arrays.asList(WebNotificationType.values());
		
		model.addAttribute("types", types);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		Set<Role> roles = loggedInUser.getRoles();
		String roleName = "";
		for (Role role : roles) {
			roleName = role.getName();
		}
		
		model.addAttribute("branches", branchUtil.getBranches());
		
		model.addAttribute("roleName", roleName);
		// The topic name can be optionally prefixed with "/topics/".
		String topic = "highScores";
		
		// See documentation on defining a message payload.
		//Message message = Message.builder().putData("score", "850").putData("time", "2:45").setTopic(topic).build();
		
		// Send a message to the devices subscribed to the provided topic.
		//String response = FirebaseMessaging.getInstance().send(message);
		// Response is a message ID string.
		//System.out.println("Successfully sent message: " + response);
		/*// This registration token comes from the client FCM SDKs.
		String registrationToken = "errr";
		
		// See documentation on defining a message payload.
		Message message = Message.builder().putData("score", "850").putData("time", "2:45").setToken(registrationToken)
		        .build();
		
		// Send a message to the device corresponding to the provided
		// registration token.
		String response = FirebaseMessaging.getInstance().send(message);
		// Response is a message ID string.
		System.out.println("Successfully sent message: " + response);*/
		model.addAttribute("notification", "block");
		model.addAttribute("selectnotificationMenu", submenuSelectedColor);
		return "webNotification/list";
	}
	
	@RequestMapping(value = "/add-new.html", method = RequestMethod.GET)
	public String addNew(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("roles", webNotificationService.getWebNotificationRoles());
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		model.addAttribute("branches", branchUtil.getBranches());
		model.addAttribute("selectnotificationMenu", submenuSelectedColor);
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
		String dateTime = webNotification.getSendDate() + " " + webNotification.getSendTimeHour() + ":"
		        + webNotification.getSendTimeMinute();
		List<Integer> branchIds = new ArrayList<Integer>();
		Set<WebNotificationBranch> branchlist = webNotification.getWebNotificationBranchs();
		
		branchlist.forEach(branch -> {
			branchIds.add(branch.getBranch());
		});
		model.addAttribute("branchlist", branchIds);
		
		model.addAttribute("branches", branchUtil.getBranches());
		model.addAttribute("dateTime", dateTime);
		model.addAttribute("webNotification", webNotification);
		model.addAttribute("divisions", webNotificationService.getLocationByTagId(divisionTagId));
		model.addAttribute("selectnotificationMenu", submenuSelectedColor);
		return "webNotification/edit";
		
	}
	
	@RequestMapping(value = "/details/{id}.html", method = RequestMethod.GET)
	public String viewDetails(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                          @PathVariable("id") long id) {
		model.addAttribute("locale", locale);
		List<WebNotificationCommonDTO> webNotification = webNotificationService.getWebNotificationDetailsById(id);
		
		model.addAttribute("notificationDetails", webNotification.get(0));
		model.addAttribute("selectnotificationMenu", submenuSelectedColor);
		return "webNotification/notificationDetails";
		
	}
	
}
