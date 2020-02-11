package org.opensrp.web.controller;

import java.security.Principal;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AccessDeniedController {
	
	@RequestMapping(value = "/403", method = RequestMethod.GET)
	public String accessDenied(Principal user,ModelMap model, Locale locale) {
		if (!user.equals("anonymousUser")) {
			return "redirect:/";
		}
		model.addAttribute("locale", locale);
		return "403";
	}
}
