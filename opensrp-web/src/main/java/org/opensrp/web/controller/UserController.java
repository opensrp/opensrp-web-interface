package org.opensrp.web.controller;

import static org.springframework.http.HttpStatus.OK;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.dto.LocationTreeDTO;
import org.opensrp.common.dto.UserAssignedLocationDTO;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.common.exception.BadFormatException;
import org.opensrp.common.exception.BranchNotFoundException;
import org.opensrp.common.exception.LocationNotFoundException;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Permission;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.entity.UsersCatchmentArea;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.EmailService;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.FacilityWorkerService;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.RoleService;
import org.opensrp.core.service.TeamMemberService;
import org.opensrp.core.service.UserService;
import org.opensrp.core.service.UsersCatchmentAreaService;
import org.opensrp.core.util.FacilityHelperUtil;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.PaginationUtil;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
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
import org.springframework.web.multipart.MultipartFile;
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
	
	private static final int childRoleId = 29;
	
	private static final int villageTagId = 33;
	
	@Value("#{opensrp['bahmni.url']}")
	private String BAHMNI_VISIT_URL;
	
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
	private FacilityService facilityService;
	
	@Autowired
	FacilityWorkerService facilityWorkerService;
	
	@Autowired
	private TeamMember teamMember;
	
	@Autowired
	private EmailService emailService;
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private UsersCatchmentAreaService usersCatchmentAreaService;
	
	@Autowired
	private SearchUtil searchUtil;
	
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
	public String userList(HttpServletRequest request, HttpSession session, Model model,
	                       @RequestParam(value = "role", required = false) Integer roleId,
	                       @RequestParam(value = "branch", required = false) Integer branchId,
	                       @RequestParam(value = "name", required = false) String name, Locale locale) {
		model.addAttribute("locale", locale);
		
		roleId = (roleId == null ? 0 : roleId);
		branchId = (branchId == null ? 0 : branchId);
		searchUtil.setDivisionAttribute(session);
		int locationId = locationServiceImpl.getLocationId(request);
		List<Object[]> users = userServiceImpl.getUserListByFilterString(locationId, villageTagId, roleId, branchId, name);
		List<Object[]> usersWithoutCatchmentArea = userServiceImpl.getUserListWithoutCatchmentArea(roleId, branchId, name);
		List<Branch> branches = branchService.findAll("Branch");
		List<Role> roles = roleServiceImpl.findAll("Role");
		session.setAttribute("usersWithoutCatchmentArea", usersWithoutCatchmentArea);
		session.setAttribute("users", users);
		session.setAttribute("branches", branches);
		session.setAttribute("roles", roles);
		session.setAttribute("selectedRole", roleId);
		session.setAttribute("selectedBranch", branchId);
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
	public ModelAndView addUser(Model model, HttpSession session, Locale locale) throws JSONException {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		List<Role> roles = userServiceImpl.setRolesAttributes(selectedRoles, session);
		List<Branch> branches = branchService.findAll("Branch");
		Role ss = roleServiceImpl.findByKey("SS", "name", Role.class);
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		model.addAttribute("branches", branches);
		String personName = "";
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		session.setAttribute("ss", ss);
		//end: adding location and team
		return new ModelAndView("user/add", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'CREATE_MULTIPURPOSE_VOLUNTEER')")
	@RequestMapping(value = "/facility/mhv/{id}/add.html", method = RequestMethod.GET)
	public ModelAndView saveUserAsCC(Model model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws JSONException {
		Facility facility = facilityService.findById(id, "id", Facility.class);
		Location location = locationServiceImpl.findByKey(facility.getUnion(), "name", Location.class);
		List<Object[]> wards = locationServiceImpl.getChildData(location.getId());
		session.setAttribute("wards", wards);
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		userServiceImpl.setRolesAttributes(selectedRoles, session);
		model.addAttribute("locale", locale);
		session.setAttribute("facilityId", id);
		model.addAttribute("facilityId", id);
		session.setAttribute("bahmniVisitURL", BAHMNI_VISIT_URL);
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		String personName = "";
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		//end: adding location and team
		return new ModelAndView("user/add-provider", "command", account);
	}
	
	/**
	 * @param model
	 * @param session
	 * @param id
	 * @param locale
	 * @return
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
		
		session.setAttribute("ssPrefix", account.getSsNo());
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
		List<Branch> branches = branchService.findAll("Branch");
		
		model.addAttribute("branches", branches);
		session.setAttribute("parentUserName", parentUserName);
		session.setAttribute("parentUserId", parentUserId);
		/** end parent user section */
		userServiceImpl.setRolesAttributes(userServiceImpl.getSelectedRoles(account), session);
		
		List<Role> roles = new ArrayList<>(account.getRoles());
		session.setAttribute("selectedRoles", roles);
		session.setAttribute("selectedBranches", account.getBranches());
		
		//for teamMember
		/*Map<String, Object> fieldValues = new HashMap<String, Object>();
		fieldValues.put("person", account);
		TeamMember teamMember = teamMemberServiceImpl.findByKeys(fieldValues, TeamMember.class);
		
		if (teamMember != null) {
			
			
			teamMember.setPerson(account);
			model.addAttribute("teamMember", teamMember);
			int[] locations = teamMemberServiceImpl.getLocationIds(teamMember.getLocations());
			
			String personName = account.getUsername() + " (" + account.getFullName() + ")";
			teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
			
			
		} else {
			
			TeamMember newTeamMember = new TeamMember();
			newTeamMember.setPerson(account);
			model.addAttribute("teamMember", newTeamMember);
			String personName = "";
			session.setAttribute("locationList", locationServiceImpl.list().toString());
			int[] locations = new int[0];
			teamMemberServiceImpl.setSessionAttribute(session, newTeamMember, personName, locations);
			
		}*/
		//end: for teamMember
		
		//return new ModelAndView("user/edit", "command", teamMember);
		return new ModelAndView("user/edit", "command", account);
	}
	
	// for edit MHV
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{facilityWorkerId}/editMHV.html", method = RequestMethod.GET)
	public ModelAndView editMHV(Model model, HttpSession session, @PathVariable("facilityWorkerId") int facilityWorkerId,
	                            Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		logger.info("\n\nUserId : " + facilityWorkerId + "\n");
		FacilityWorker facilityWorker = facilityWorkerService.findById(facilityWorkerId, "id", FacilityWorker.class);
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		keyValueMap.put("chcp", facilityWorker.getFacility().getId() + "");
		keyValueMap.put("provider", true);
		String fullName = facilityWorker.getName();
		String firstName = fullName.split("\\s+")[0];
		String lastName = fullName.split("\\s+")[1];
		keyValueMap.put("firstName", firstName);
		logger.info("\n\nFirstName : " + firstName + ";\n");
		keyValueMap.put("lastName", lastName);
		logger.info("\n\nLastName : " + lastName + ";\n");
		User account = userServiceImpl.findOneByKeys(keyValueMap, User.class);
		logger.info("\n\nUser : " + account.toString() + "\n");
		model.addAttribute("account", account);
		model.addAttribute("id", account.getId());
		model.addAttribute("facilityWorkerId", facilityWorkerId);
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
		return new ModelAndView("user/editMHV", "command", account);
	}
	
	//end : edit MHV
	
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
	                             @RequestParam(value = "ssNo", required = false) String ssNo,
	                             @RequestParam(value = "branches", required = false) String[] branches,
	                             @RequestParam(value = "locationList[]", required = false) int[] locations,
	                             @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                             HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		
		account.setRoles(userServiceImpl.setRoles(roles));
		account.setBranches(userServiceImpl.setBranches(branches));
		String ssPrefix = "";
		
		/*if (!StringUtils.isBlank(ssNo)) {
			ssPrefix = ssNo.substring(1);
		}*/
		
		account.setId(id);
		account.setSsNo(ssNo);
		
		userServiceImpl.update(account);
		
		return new ModelAndView("redirect:/user.html?lang=" + locale);
		
	}
	
	//for edit mhv post - april 27, 2019
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/{facilityWorkerId}/editMHV.html", method = RequestMethod.POST)
	public ModelAndView editUserMHV(@RequestParam(value = "parentUser", required = false) Integer parentUserId,
	                                @RequestParam(value = "roles", required = false) String[] roles,
	                                @RequestParam(value = "team", required = false) Integer teamId,
	                                @RequestParam(value = "locationList[]", required = false) int[] locations,
	                                @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                                HttpSession session, @PathVariable("id") int id,
	                                @PathVariable("facilityWorkerId") int facilityWorkerId, Locale locale) throws Exception {
		
		account.setRoles(userServiceImpl.setRoles(roles));
		account.setId(id);
		User parentUser = userServiceImpl.findById(parentUserId, "id", User.class);
		account.setParentUser(parentUser);
		logger.info("\n\nUSER : " + account.toString() + "\n");
		userServiceImpl.update(account);
		
		//set edited name in facilityWorker
		logger.info("\n\nFacilityWorkerId : " + facilityWorkerId + "\n");
		FacilityWorker facilityWorker = facilityWorkerService.findById(facilityWorkerId, "id", FacilityWorker.class);
		String fullName = account.getFirstName() + " " + account.getLastName();
		facilityWorker.setName(fullName);
		facilityWorkerService.save(facilityWorker);
		//end: set edited name in facilityWorker
		
		//get facilityId to redirect to update_porfile view
		Facility facility = facilityWorker.getFacility();
		String facilityId = facility.getId() + "";
		String redirectUrl = "redirect:/facility/" + facilityId + "/updateProfile.html";
		//end: get facilityId to redirect to update_porfile view
		
		Map<String, Object> fieldValues = new HashMap<String, Object>();
		fieldValues.put("person", account);
		TeamMember teamMember = teamMemberServiceImpl.findByKeys(fieldValues, TeamMember.class);
		if (teamMember != null) {
			if (teamId != null) {
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
				teamMemberServiceImpl.delete(teamMember);
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
		
		//send mail to emailAddress
		String mailBody = "Dear " + facilityWorker.getName()
		        + ",\n\nYour login credentials for CBHC are given below -\nusername : " + account.getUsername();
		//+ "\npassword : " + userDTO.getPassword();
		emailService.sendSimpleMessage(account.getEmail(), "Login credentials for CBHC", mailBody);
		//end: send mail to emailAddress
		
		//return new ModelAndView("redirect:/user.html?lang=" + locale);
		return new ModelAndView(redirectUrl + "?lang=" + locale);
		
	}
	
	//end : edit mhv post
	
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
	@RequestMapping(value = "/user/{id}/change-password.html", method = RequestMethod.GET)
	public ModelAndView editPassword(Model model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		session.setAttribute("username", account.getUsername());
		return new ModelAndView("user/change-password");
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
	//	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	//	@RequestMapping(value = "/user/{id}/password.html", method = RequestMethod.POST)
	//	public ModelAndView editPassword(@Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	//	                                 HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
	//		User gettingAccount = userServiceImpl.findById(id, "id", User.class);
	//		if (userServiceImpl.isPasswordMatched(account)) {
	//			account.setId(id);
	//			account.setEnabled(true);
	//			account.setRoles(gettingAccount.getRoles());
	//			userServiceImpl.updatePassword(account);
	//		} else {
	//
	//			return new ModelAndView("user/password", "command", gettingAccount);
	//		}
	//		return new ModelAndView("redirect:/user.html?lang=" + locale);
	//	}
	
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
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_USER_UPLOAD')")
	@RequestMapping(value = "user/upload.html", method = RequestMethod.GET)
	public String userUpload(Model model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		String parentIndication = "#";
		String parentKey = "parent";
		JSONArray data = userServiceImpl.getUserDataAsJson(parentIndication, parentKey);
		session.setAttribute("userTreeData", data);
		
		return "user/upload";
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
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_USER')")
	@RequestMapping(value = "/user/{id}/catchment-area.html", method = RequestMethod.GET)
	public String catchmentArea(Model model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		String parentIndication = "#";
		String parentKey = "parent";
		List<UsersCatchmentArea> usersCatchmentAreas = usersCatchmentAreaService.findAllByForeignKey(id, "user_id",
		    "UsersCatchmentArea");
		TeamMember member = teamMemberServiceImpl.findByForeignKey(id, "person_id", "TeamMember");
		boolean isTeamMember = member != null ? true : false;
		List<Object[]> catchmentAreas = userServiceImpl.getUsersCatchmentAreaTableAsJson(id);
		User user = userServiceImpl.findById(id, "id", User.class);
		
		List<Role> roles = new ArrayList<>(user.getRoles());
		Integer roleId = roles.get(0).getId();
		List<UserAssignedLocationDTO> userAssignedLocationDTOS = userServiceImpl.assignedLocationByRole(roleId);
		String role = "Admin";
		if (AuthenticationManagerUtil.isAM())
			role = "AM";
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		JSONArray data = locationServiceImpl.getLocationWithDisableFacility(parentIndication, parentKey,
		    userAssignedLocationDTOS, user.getId(), role, loggedInUser.getId());
		
		session.setAttribute("usersCatchmentAreas", usersCatchmentAreas);
		session.setAttribute("catchmentAreaTable", catchmentAreas);
		session.setAttribute("locationTreeData", data);
		session.setAttribute("isTeamMember", isTeamMember);
		session.setAttribute("userId", id);
		session.setAttribute("user", user);
		session.setAttribute("assignedLocation", userAssignedLocationDTOS);
		System.out.println("EVERYTHING IS OKAY");
		return "user/catchment-area";
	}
	
	@RequestMapping(value = "/provider/location-tree", method = RequestMethod.GET)
	public ResponseEntity<String> getLocationTree(@RequestParam("username") String username) throws JSONException {
		
		User user = userServiceImpl.findByKey(username, "username", User.class);
		TeamMember teamMember = teamMemberServiceImpl.findByForeignKey(user.getId(), "person_id", "TeamMember");
		List<LocationTreeDTO> treeDTOS = userServiceImpl.getProviderLocationTreeByChildRole(teamMember.getId(), childRoleId);
		
		JSONArray array = new JSONArray();
		try {
			array = locationServiceImpl.convertLocationTreeToJSON(treeDTOS, user.getEnableSimPrint());
			System.out.println(array);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<>(array.toString(), OK);
	}
	
	@RequestMapping(value = "/upload/user-catchment.html", method = RequestMethod.POST)
	public ModelAndView uploadUser(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model,
	                               Locale locale) throws Exception {
		
		if (file.isEmpty()) {
			model.put("msg", "failed to upload user data because its empty");
			model.addAttribute("msg", "failed to upload file because its empty");
			return new ModelAndView("/user/upload");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())
		        && !"application/vnd.ms-excel".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "file type should be '.csv'");
			return new ModelAndView("/user/upload");
		}
		
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		
		System.out.println("Root Path:-> " + rootPath);
		File dir = new File(rootPath + File.separator + "uploadedfile");
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		File csvFile = new File(dir.getAbsolutePath() + File.separator + file.getOriginalFilename());
		
		try {
			try (InputStream is = file.getInputStream();
			        BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(csvFile))) {
				int i;
				
				while ((i = is.read()) != -1) {
					stream.write(i);
				}
				stream.flush();
			}
		}
		catch (IOException e) {
			model.put("msg", "failed to process file because : " + e.getMessage());
			return new ModelAndView("/user/upload");
		}
		
		String msg = "";
		try {
			msg = userServiceImpl.uploadUser(csvFile);
		}
		catch (LocationNotFoundException lnf) {
			msg = lnf.getErrorMessage();
		}
		catch (BranchNotFoundException bnf) {
			msg = bnf.getErrorMessage();
		}
		catch (BadFormatException bf) {
			msg = bf.getErrorMessage();
		}
		if (!msg.isEmpty()) {
			model.put("msg", msg);
			return new ModelAndView("/user/upload");
		}
		return new ModelAndView("redirect:/user.html?lang=" + locale);
	}
	
	@RequestMapping(value = "/user/sk-list.html", method = RequestMethod.GET)
	public String getSKByPM(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<UserDTO> users = userServiceImpl.getChildUserFromParent(loggedInUser.getId(), "SK");
		session.setAttribute("allSK", users);
		session.setAttribute("fromRole", "SK");
		return "user/sk-list";
	}
	
	@RequestMapping(value = "/user/{skId}/{skUsername}/my-ss.html", method = RequestMethod.GET)
	public String getSSBySK(@PathVariable("skId") Integer skId, @PathVariable("skUsername") String skUsername,
	                        HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<UserDTO> users = userServiceImpl.getChildUserFromParent(skId, "SS");
		List<UserDTO> ssWithoutCatchment = userServiceImpl.getSSWithoutCatchmentArea(skId);
		model.addAttribute("skUsername", skUsername);
		model.addAttribute("skId", skId);
		session.setAttribute("allSS", users);
		session.setAttribute("fromRole", "SS");
		session.setAttribute("idFinal", skId);
		session.setAttribute("ssWithoutCatchment", ssWithoutCatchment);
		return "user/ss-list";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_ADD_SS')")
	@RequestMapping(value = "/user/add-SS.html", method = RequestMethod.GET)
	public ModelAndView addSS(Model model, HttpSession session, @RequestParam("skId") Integer skId,
	                          @RequestParam("skUsername") String skUsername, Locale locale) throws JSONException {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		List<Role> roles = userServiceImpl.setRolesAttributes(selectedRoles, session);
		List<Branch> branches = branchService.findAll("Branch");
		Role ss = roleServiceImpl.findByKey("SS", "name", Role.class);
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		model.addAttribute("branches", branches);
		String personName = "";
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		session.setAttribute("ss", ss);
		session.setAttribute("skId", skId);
		System.err.println("skId:::::" + skId);
		String redirectUrl = "redirect:/user/sk-list.html";
		if (StringUtils.isBlank(skUsername)) {
			return new ModelAndView(redirectUrl + "?lang=" + locale);
		}
		model.addAttribute("skUsername", skUsername);
		//end: adding location and team
		return new ModelAndView("user/add-ss", "command", account);
	}
}
