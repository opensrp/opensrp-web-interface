package org.opensrp.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.web.util.OpensrpProperties;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController extends OpensrpProperties {
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest request, HttpSession session, Model model) {
		/*Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		List<String> roleName = new ArrayList<String>();
		Set<Role> roles = (Set<Role>) user.getRoles();
		for (Role role : roles) {
			roleName.add(role.getName());
		}
		
		String targetUrl = "/dashboard";
		if (roleName.contains("admin")) {
			targetUrl = "/dashboard";
		} else if (roleName.contains("test")) {
			targetUrl = "/analytics/analytics.html";
		}*/
		
		return new ModelAndView("redirect:" + dashboardUrl);
		
	}
}
