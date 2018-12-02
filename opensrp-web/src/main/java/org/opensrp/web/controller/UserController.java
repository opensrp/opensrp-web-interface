package org.opensrp.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Permission;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.RoleService;
import org.opensrp.core.service.TeamMemberService;
import org.opensrp.core.service.UserService;
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
import org.springframework.validation.DataBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * <p>
 * The UserController program implements an application that simply contains the user related
 * information such as(show user list, add user, edit user etc).
 * </p>
 * 
 * @author proshanto.
 * @version 0.1.0
 * @since 2018-03-30
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
	private UserService userServiceImpl;
	
	@Autowired
	private RoleService roleServiceImpl;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private TeamMemberService teamMemberServiceImpl;
	
	@Autowired
	private TeamMember teamMember;
	
	/**
	 * <p>
	 * showing user list, support pagination with search by user name
	 * </p>
	 * 
	 * @param request is an argument to the servlet's service
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @return user list view page
	 */
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_USER_LIST')")
	@RequestMapping(value = "/user.html", method = RequestMethod.GET)
	public String userList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		Class<User> entityClassName = User.class;
		paginationUtil.createPagination(request, session, entityClassName);
		return "user/index";
	}
	
	/**
	 * <p>
	 * This method render user html form for addition, where login user can fill up user information
	 * to save it in permanent storage.This is a get request method, there is a post request method
	 * at {@UserRestController} named @saveUser which actually save the user
	 * information in to permanent storage as ajax call.
	 * </p>
	 * 
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @return user html form.
	 * @throws JSONException
	 */
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_USER')")
	@RequestMapping(value = "/user/add.html", method = RequestMethod.GET)
	public ModelAndView saveUser(Model model, HttpSession session, Locale locale) throws JSONException {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		userServiceImpl.setRolesAttributes(selectedRoles, session);
		model.addAttribute("locale", locale);
		
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		String personName = "";
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		//end: adding location and team
		return new ModelAndView("user/add", "command", account);
	}
	
	/**
	 * <p>
	 * This method render user html form for user information to edit, where login user can update
	 * user information to save it in permanent storage.This is a get request method, there is a
	 * post request method at {@UserController} named @editUser which actually
	 * update the user information in to permanent storage.
	 * </p>
	 * 
	 * @param request is an argument to the servlet's service
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @param id is unique id of a user.
	 * @return user html form.
	 * @throws JSONException
	 */
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editUser(Model model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		model.addAttribute("id", id);
		/**
		 * Parent user section start . this section prepare parent user information and render to
		 * view for showing. parentUserName shows to the parent user text field named
		 * "parentUserName". parentUserId goes to the hidden field "parentUser"
		 */
		User parentUser = account.getParentUser();
		String parentUserName = "";
		int parentUserId = 0;
		if (parentUser != null) {
			parentUserName = parentUser.getUsername() + " (" + parentUser.getFullName() + ")";
			parentUserId = parentUser.getId();
		}
		session.setAttribute("parentUserName", parentUserName);
		session.setAttribute("parentUserId", parentUserId);
		/** end parent user section */
		userServiceImpl.setRolesAttributes(userServiceImpl.getSelectedRoles(account), session);
		
		//for teamMember
		Map<String, Object> fieldValues = new HashMap<String, Object>();
		fieldValues.put("person", account);
		TeamMember teamMember = teamMemberServiceImpl.findByKeys(fieldValues, TeamMember.class);
		if (teamMember != null) {
			
			//System.out.println(teamMember.toString());
			//model.addAttribute("id", id);
			teamMember.setPerson(account);
			model.addAttribute("teamMember", teamMember);
			int[] locations = teamMemberServiceImpl.getLocationIds(teamMember.getLocations());
			//User person = teamMember.getPerson();
			String personName = account.getUsername() + " (" + account.getFullName() + ")";
			teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
			
			//return new ModelAndView("team-member/edit", "command", teamMember);
		} else {
			//for adding location and team
			TeamMember newTeamMember = new TeamMember();
			newTeamMember.setPerson(account);
			model.addAttribute("teamMember", newTeamMember);
			String personName = "";
			session.setAttribute("locationList", locationServiceImpl.list().toString());
			int[] locations = new int[0];
			teamMemberServiceImpl.setSessionAttribute(session, newTeamMember, personName, locations);
			//end: adding location and team
		}
		//end: for teamMember
		
		//return new ModelAndView("user/edit", "command", teamMember);
		return new ModelAndView("user/edit", "command", account);
	}
	
	/**
	 * <p>
	 * This method is a post request of corresponding of get request method @editUser which actually
	 * update the user information in to permanent storage.
	 * </p>
	 * 
	 * @param request is an argument to the servlet's service
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @param id is unique id of a user.
	 * @param parentUserId unique id of parent user.
	 * @return user html form.
	 */
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editUser(@RequestParam(value = "parentUser", required = false) Integer parentUserId,
	                             @RequestParam(value = "roles", required = false) String[] roles,
	                             @RequestParam(value = "team", required = false) Integer teamId,
	                             @RequestParam(value = "locationList[]", required = false) int[] locations,
	                             @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                             HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		
		account.setRoles(userServiceImpl.setRoles(roles));
		account.setId(id);
		User parentUser = userServiceImpl.findById(parentUserId, "id", User.class);
		account.setParentUser(parentUser);
		userServiceImpl.update(account);
		
		Map<String, Object> fieldValues = new HashMap<String, Object>();
		fieldValues.put("person", account);
		TeamMember teamMember = teamMemberServiceImpl.findByKeys(fieldValues, TeamMember.class);
		if (teamMember != null && teamId != null) {
			teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember,
			    account.getId(), teamId, locations);
			teamMember.setIdentifier(account.getIdetifier());
			
			//teamMember.setId(id);
			if (!teamMemberServiceImpl.isPersonAndIdentifierExists(model, teamMember, locations)) {
				teamMemberServiceImpl.update(teamMember);
				
			} else {
				teamMemberServiceImpl.setSessionAttribute(session, teamMember, teamMember.getPerson().getFullName(),
				    locations);
				return new ModelAndView("/team-member/edit");
			}
		} else {
			if (teamId != null && teamId > 0) {
				TeamMember newTeamMember = new TeamMember();
				newTeamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(newTeamMember,
				    account.getId(), teamId, locations);
				newTeamMember.setIdentifier(account.getIdetifier());
				
				if (!teamMemberServiceImpl.isPersonAndIdentifierExists(model, newTeamMember, locations)) {
					teamMemberServiceImpl.save(newTeamMember);
				}
			}
		}
		
		System.out.println(account.toString());
		System.out.println(teamMember.getPerson().toString());
		System.out.println(teamMember.getLocations());
		System.out.println(teamMember.getTeam());
		
		return new ModelAndView("redirect:/user.html?lang=" + locale);
		
	}
	
	/**
	 * <p>
	 * This method render user html form for user password to edit, where login user can update user
	 * password to save it in permanent storage.This is a get request method, there is a post
	 * request method at {@link UserController#editPassword(model,session,id,locale)} which actually
	 * update the user password in to permanent storage.
	 * </p>
	 * 
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @param id is unique id of a user.
	 * @return user html password form.
	 */
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	@RequestMapping(value = "/user/{id}/password.html", method = RequestMethod.GET)
	public ModelAndView editPassword(Model model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		return new ModelAndView("user/password", "command", account);
	}
	
	/**
	 * <p>
	 * This method is a post request of corresponding of get request method #editPassword which
	 * actually update the user information in to permanent storage.
	 * </p>
	 * 
	 * @param request is an argument to the servlet's service
	 * @param session is an argument to the HttpSession's session
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @param id is unique id of a user.
	 * @param account is submitted user object.
	 * @param binding Serves as result holder for a {@link DataBinder}.
	 */
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	@RequestMapping(value = "/user/{id}/password.html", method = RequestMethod.POST)
	public ModelAndView editPassword(@Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                                 HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		User gettingAccount = userServiceImpl.findById(id, "id", User.class);
		if (userServiceImpl.isPasswordMatched(account)) {
			account.setId(id);
			account.setEnabled(true);
			account.setRoles(gettingAccount.getRoles());
			userServiceImpl.updatePassword(account);
		} else {
			
			return new ModelAndView("user/password", "command", gettingAccount);
		}
		return new ModelAndView("redirect:/user.html?lang=" + locale);
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginPage() {
		return "user/login";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_USER_HIERARCHY')")
	@RequestMapping(value = "user/hierarchy.html", method = RequestMethod.GET)
	public String userHierarchy(Model model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		String parentIndication = "#";
		String parentKey = "parent";
		JSONArray data = userServiceImpl.getUserDataAsJson(parentIndication, parentKey);
		session.setAttribute("userTreeData", data);
		
		return "user/hierarchy";
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutPage(HttpServletRequest request, HttpServletResponse response, Locale locale) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		return "redirect:/login?logout?lang=" + locale;//You can redirect wherever you want, but generally it's a good practice to show login screen again.
	}
	
	@RequestMapping(value = "user/provider.html", method = RequestMethod.GET)
	public String providerSearch(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		
		List<User> users = userServiceImpl.findAllByKeysWithALlMatches(name, true);
		session.setAttribute("searchedUsers", users);
		return "user/search";
	}
	
	@RequestMapping(value = "user/user.html", method = RequestMethod.GET)
	public String userSearch(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		List<User> users = userServiceImpl.findAllByKeysWithALlMatches(name, false);
		session.setAttribute("searchedUsers", users);
		return "user/search";
	}
	
}
