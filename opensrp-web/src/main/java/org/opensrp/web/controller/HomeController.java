package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.UserService;
import org.opensrp.web.util.OpensrpProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController extends OpensrpProperties {
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		List<String> roleName = new ArrayList<String>();
		Set<Role> roles = (Set<Role>) user.getRoles();
		for (Role role : roles) {
			roleName.add(role.getName());
		}
		System.err.println("start home: "+user.getUsername()+":  "+System.currentTimeMillis() );

		String targetUrl = dashboardUrl;
		if (roleName.contains("admin")) {
			targetUrl = dashboardUrl;
		} else if (roleName.contains("AM")) {
			targetUrl = "/user/sk-list.html";
		}

		System.err.println("end home: "+user.getUsername()+":  "+System.currentTimeMillis() );
		model.addAttribute("locale", locale);
		return new ModelAndView("redirect:" + targetUrl);
		
	}
}
