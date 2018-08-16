package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.opensrp.acl.entity.Permission;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.service.impl.RoleServiceImpl;
import org.opensrp.acl.service.impl.UserServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author proshanto
 */

@Controller
public class UserController {
	
	private static final Logger logger = Logger.getLogger(UserController.class);
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private User account;
	
	@Autowired
	private Permission permission;
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_USER')")
	@RequestMapping(value = "/user.html", method = RequestMethod.GET)
	public String userList(HttpServletRequest request, HttpSession session, Model model) {
		
		Class<User> entityClassName = User.class;
		paginationUtil.createPagination(request, session, entityClassName);
		return "user/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_USER')")
	@RequestMapping(value = "/user/add.html", method = RequestMethod.GET)
	public ModelAndView saveUser(Model model, HttpSession session) {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		userServiceImpl.setRolesAttributes(selectedRoles, session);
		return new ModelAndView("user/add", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editUser(Model model, HttpSession session, @PathVariable("id") int id) {
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		model.addAttribute("id", id);
		userServiceImpl.setRolesAttributes(userServiceImpl.getSelectedRoles(account), session);
		return new ModelAndView("user/edit", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editUser(@RequestParam(value = "roles", required = false) String[] roles,
	                             @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                             HttpSession session, @PathVariable("id") int id) throws Exception {
		account.setRoles(userServiceImpl.setRoles(roles));
		account.setId(id);
		account.setEnabled(true);
		
		userServiceImpl.update(account);
		
		return new ModelAndView("redirect:/user.html");
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	@RequestMapping(value = "/user/{id}/password.html", method = RequestMethod.GET)
	public ModelAndView editPassword(Model model, HttpSession session, @PathVariable("id") int id) {
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		return new ModelAndView("user/password", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	@RequestMapping(value = "/user/{id}/password.html", method = RequestMethod.POST)
	public ModelAndView editPassword(@Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                                 HttpSession session, @PathVariable("id") int id) throws Exception {
		User gettingAccount = userServiceImpl.findById(id, "id", User.class);
		if (userServiceImpl.isPasswordMatched(account)) {
			account.setId(id);
			account.setEnabled(true);
			account.setRoles(gettingAccount.getRoles());
			userServiceImpl.updatePassword(account);
		} else {
			
			return new ModelAndView("user/password", "command", gettingAccount);
		}
		return new ModelAndView("redirect:/user.html");
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginPage() {
		return "user/login";
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		return "redirect:/login?logout";//You can redirect wherever you want, but generally it's a good practice to show login screen again.
	}
	
	@RequestMapping(value = "user/search.html", method = RequestMethod.GET)
	public String providerSearch(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		
		List<User> users = userServiceImpl.getAllProviderByKeysWithALlMatches(name);
		session.setAttribute("searchedUsers", users);
		return "user/search";
	}
}
