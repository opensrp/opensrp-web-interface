package org.opensrp.web.controller;

import static org.springframework.http.HttpStatus.OK;

import java.io.*;
import java.security.Principal;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
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
import org.opensrp.common.util.PermissionName;
import org.opensrp.common.util.Roles;
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
import org.opensrp.core.service.mapper.UserMapper;
import org.opensrp.core.util.FacilityHelperUtil;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.PaginationUtil;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

	@Autowired
	private UserMapper userMapper;
	
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
		List<Branch> branches = branchService.findAll("Branch");
		List<Role> roles = roleServiceImpl.findAll("Role");
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
//		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
//		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		session.setAttribute("ss", ss);
		//end: adding location and team
		return new ModelAndView("user/add", "command", account);
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_USER')")
	@RequestMapping(value = "/user/add-ajax.html", method = RequestMethod.GET)
	public ModelAndView addAjaxUser(Model model, HttpSession session, Locale locale) throws JSONException {
		int[] selectedRoles = null;
		List<Role> roles = userServiceImpl.setRolesAttributes(selectedRoles, session);
		List<Branch> branches = branchService.findAll("Branch");
		Role ss = roleServiceImpl.findByKey("SS", "name", Role.class);
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		model.addAttribute("branches", branches);
		session.setAttribute("ss", ss);
		return new ModelAndView("user/add-ajax", "command", account);
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
		String errorMessage = "";
		session.setAttribute("errorMessageForSK", errorMessage);
//		if (roles[0].equals(Roles.AM.getId().toString())){
//			User updateAbleUser = userServiceImpl.findById(id, "id", User.class);
//			List<Branch> existingBranch = new ArrayList<>(updateAbleUser.getBranches());
//			for (Branch b: existingBranch) {
//				Integer branchId = b.getId();
//				boolean flag = false;
//				for (int i = 0; i < branches.length; i++) {
//					System.out.println(branchId + " : " +branches[i]);
//					if (branchId.equals(Integer.valueOf(branches[i]))) {
//						flag = true;
//						break;
//					}
//				}
//				if (flag == false) {
//					List<Object[]> branchesCheck = databaseServiceImpl.getSKByBranch(branchId.toString());
//					if (branchesCheck.size() > 0) {
//						errorMessage = "You have to remove SK from "+ b.getName() + " Branch to continue";
//						session.setAttribute("errorMessageForSK", errorMessage);
//						System.out.println("ID: "+ id);
//						return new ModelAndView("redirect:/user/"+id+"/edit.html?lang=" + locale);
//					}
//				} else {
//					errorMessage = "";
//					session.setAttribute("errorMessageForSK", errorMessage);
//				}
//			}
//		}
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
	 * request method at {@link UserController} which actually
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

	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_PASSWORD')")
	@RequestMapping(value = "/user/{id}/change-password-ajax.html", method = RequestMethod.GET)
	public ModelAndView editPasswordAM(Model model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		session.setAttribute("username", account.getUsername());
		return new ModelAndView("user/change-password-ajax");
	}
	
	/**
	 * <p>
	 * This method is a post request of corresponding of get request method #editPassword which
	 * actually update the user information in to permanent storage.
	 * </p>
	 *
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

	@RequestMapping(value = "/session-expired", method = RequestMethod.GET)
	public ModelAndView sessionExpired(ModelAndView modelAndView) {

		modelAndView.setViewName("user/login");
		modelAndView.addObject("sessionExpiredMsg", "Your session has expired, please login again to continue");
		return modelAndView;
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
//		String parentIndication = "#";
//		String parentKey = "parent";
//		JSONArray data = userServiceImpl.getUserDataAsJson(parentIndication, parentKey);
//		session.setAttribute("userTreeData", data);
		
		return "user/upload";
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_IMEI')")
	@RequestMapping(value = "user/upload-imei.html", method = RequestMethod.GET)
	public String imeiUpload(Model model, HttpSession session, Locale locale) {
		model.addAttribute("locale", locale);
		return "user/upload-imei";
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
		System.err.println("user home start:"+System.currentTimeMillis());
		List<User> users = userServiceImpl.findAllByKeysWithALlMatches(name, false);
		session.setAttribute("searchedUsers", users);
		System.err.println("user home end:"+System.currentTimeMillis());
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
		User user = userServiceImpl.findById(id, "id", User.class);

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Role> roles = new ArrayList<>(user.getRoles());
		Integer roleId = roles.get(0).getId();
		List<UserAssignedLocationDTO> userAssignedLocationDTOS = userServiceImpl.assignedLocationByRole(roleId);
		String role = "Admin";
		if (AuthenticationManagerUtil.isAM())
			role = "AM";

		Integer parentUserId;
		if (roleId == Roles.SK.getId() || roleId == Roles.SS.getId()) {
			if (user.getParentUser() == null) {
				if (roleId == Roles.SK.getId()) {
					List<Branch> branches = new ArrayList<>(user.getBranches());
					Integer branchId = 0;
					if (branches != null && branches.size() > 0) branchId = branches.get(0).getId();
					UserDTO parentUser = userServiceImpl.findAMByBranchId(branchId);
					if (parentUser != null) parentUserId = parentUser.getId();
					else  parentUserId = 0;
				}
				else  parentUserId = 0;
			}
			else parentUserId = user.getParentUser().getId();
		} else parentUserId = loggedInUser.getId();
		JSONArray data = locationServiceImpl.getLocationWithDisableFacility(session, parentIndication, parentKey,
		    userAssignedLocationDTOS, user.getId(), role, parentUserId, roleId);

		TeamMember member = teamMemberServiceImpl.findByForeignKey(id, "person_id", "TeamMember");
		boolean isTeamMember = member != null ? true : false;
		session.setAttribute("usersCatchmentAreas", usersCatchmentAreas);
		session.setAttribute("locationTreeData", data);
		session.setAttribute("isTeamMember", isTeamMember);
		session.setAttribute("userId", id);
		session.setAttribute("user", user);
		session.setAttribute("assignedLocation", userAssignedLocationDTOS);
		session.setAttribute("roleId", roleId);
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
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<>(array.toString(), OK);
	}
	
	@RequestMapping(value = "/upload/user-catchment.html", method = RequestMethod.POST)
	public ModelAndView uploadUser(HttpSession session, @RequestParam MultipartFile file, HttpServletRequest request, ModelMap model,
	                               Locale locale) throws Exception {
		
		if (file.isEmpty()) {
			model.put("msg", "Failed to upload the file because it is empty");
			model.addAttribute("msg", "Failed to upload the file because it is empty");
			return new ModelAndView("/user/upload");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())
		        && !"application/vnd.ms-excel".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "File type should be '.csv'");
			return new ModelAndView("/user/upload");
		}
		
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		
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
			msg = userServiceImpl.uploadUser(session, csvFile);
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

	@RequestMapping(value = "/upload/imei.html", method = RequestMethod.POST)
	public ModelAndView uploadImei(HttpSession session, @RequestParam MultipartFile file, HttpServletRequest request, ModelMap model,
	                               Locale locale) throws Exception {

		if (file.isEmpty()) {
			model.put("msg", "Failed to upload the file because it is empty");
			model.addAttribute("msg", "Failed to upload the file because it is empty");
			return new ModelAndView("/user/upload-imei");
		}
		if (!"text/csv".equalsIgnoreCase(file.getContentType())
				&& !"application/vnd.ms-excel".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "File type should be '.csv'");
			return new ModelAndView("/user/upload-imei");
		}

		String rootPath = request.getSession().getServletContext().getRealPath("/");
		File dir = new File(rootPath + File.separator + "uploadedfile");
		if (!dir.exists()) dir.mkdirs();

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
		} catch (IOException e) {
			model.put("msg", "failed to process file because : " + e.getMessage());
			return new ModelAndView("/user/upload-imei");
		}

		String msg = "";
		try {
			msg = userServiceImpl.uploadImei(session, csvFile);
		} catch (BadFormatException bf) {
			msg = bf.getErrorMessage();
		} catch (Exception e) {
			msg = e.getMessage();
		}

		if (!msg.isEmpty()) {
			model.put("msg", msg);
		}
		return new ModelAndView("/user/upload-imei");
	}
	
	@RequestMapping(value = "/user/sk-list.html", method = RequestMethod.GET)
	public String getSKByPM(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		System.err.println("sk start: "+loggedInUser.getUsername()+":  "+System.currentTimeMillis() );
		List<UserDTO> users = userServiceImpl.getChildUserFromParent(loggedInUser.getId(), "SK");
		session.setAttribute("allSK", users);
		session.setAttribute("fromRole", "SK");
		System.err.println("sk end: "+loggedInUser.getUsername()+":  "+System.currentTimeMillis() );
		return "user/sk-list";
	}
	
	@RequestMapping(value = "/user/{skId}/{skUsername}/my-ss.html", method = RequestMethod.GET)
	public String getSSBySK(@PathVariable("skId") Integer skId, @PathVariable("skUsername") String skUsername,
	                        HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		List<UserDTO> users = userServiceImpl.getChildUserFromParent(skId, "SS");
		List<UserDTO> ssWithoutCatchment = userServiceImpl.getSSWithoutCatchmentArea(skId);
		User skOfSS = userServiceImpl.findById(skId, "id", User.class);

		model.addAttribute("skUsername", skUsername);
		model.addAttribute("skFullName", skOfSS.getFullName());
		model.addAttribute("branches", branches);
		model.addAttribute("skId", skId);
		session.setAttribute("allSS", users);
		session.setAttribute("fromRole", "SS");
		session.setAttribute("idFinal", skId);
		session.setAttribute("usernameFinal", skUsername);
		session.setAttribute("ssWithoutCatchment", ssWithoutCatchment);
		session.setAttribute("skName", skOfSS.getFullName());
		return "user/ss-list";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_ADD_SS')")
	@RequestMapping(value = "/user/add-SS.html", method = RequestMethod.GET)
	public ModelAndView addSS(Model model, HttpSession session, @RequestParam("skId") Integer skId,
	                          @RequestParam("skUsername") String skUsername, Locale locale) throws JSONException {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		List<Role> roles = userServiceImpl.setRolesAttributes(selectedRoles, session);
		//List<Branch> branches = branchService.findAll("Branch");
		User skUser = userServiceImpl.findById(skId, "id", User.class);
		String skFullName = skUser.getFullName();
		List<Branch> branches = branchService.getBranchByUser(skUser.getId());
		Role ss = roleServiceImpl.findByKey("SS", "name", Role.class);
		
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		model.addAttribute("branches", branches);
		model.addAttribute("skId", skId);
		
		String personName = "";
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		//session.setAttribute("locationList", locationServiceImpl.list().toString());
		//int[] locations = new int[0];
		//teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		session.setAttribute("ss", ss);
		session.setAttribute("skId", skId);
		model.addAttribute("skId", skId);
		
		String redirectUrl = "redirect:/user/sk-list.html";
		if (StringUtils.isBlank(skUsername)) {
			return new ModelAndView(redirectUrl + "?lang=" + locale);
		}
		model.addAttribute("skUsername", skUsername);
		model.addAttribute("skFullName", skFullName);
		//end: adding location and team
		return new ModelAndView("user/add-ss-ajax", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{skUsername}/{skId}/{id}/edit-SS.html", method = RequestMethod.GET)
	public ModelAndView editSS(@PathVariable("skUsername") String skUsername, @PathVariable("skId") Integer skId,
	                           HttpSession session, @PathVariable("id") int id, Locale locale, Model model)
	    throws JSONException {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		model.addAttribute("id", id);
		model.addAttribute("skId", skId);
		model.addAttribute("skUsername", skUsername);
		session.setAttribute("ssPrefix", account.getSsNo());
		
		String parentUserName = "";
		int parentUserId = 0;
		
		//List<Branch> branches = branchService.findAll("Branch");
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		session.setAttribute("parentUserName", parentUserName);
		session.setAttribute("parentUserId", parentUserId);
		
		session.setAttribute("selectedBranches", account.getBranches());
		
		return new ModelAndView("user/edit-ss-ajax", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit-SS.html", method = RequestMethod.POST)
	public ModelAndView editSSPost(@RequestParam(value = "skUsername", required = false) String skUsername,
	                               @RequestParam(value = "skId", required = false) String skId,
	                               @RequestParam(value = "branches", required = false) String[] branches,
	                               @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                               
	                               HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		
		Role ss = roleServiceImpl.findByKey("SS", "name", Role.class);
		account.setId(id);
		User user = userServiceImpl.findById(id, "id", User.class);
		if (user.getParentUser() != null) account.setParentUser(user.getParentUser());
		if (user.getCreator() != null) account.setCreator(user.getCreator());
		if (user.getBranches() != null) account.setBranches(user.getBranches());
		if (user.getRoles() != null) account.setRoles(user.getRoles());
		//account.setPassword("");
		String redirectUrl = "redirect:/user/" + skId + "/" + skUsername + "/my-ss.html";
		userServiceImpl.update(account);
		return new ModelAndView(redirectUrl + "?lang=" + locale);
		//return new ModelAndView("redirect:/user.html?lang=" + locale);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_ADD_SK')")
	@RequestMapping(value = "/user/add-SK.html", method = RequestMethod.GET)
	public ModelAndView addSK(Model model, HttpSession session, Locale locale,
	                          @RequestParam(value = "amId", required = false) Integer amId) throws JSONException {
		int[] selectedRoles = null;
		model.addAttribute("account", new User());
		List<Role> roles = userServiceImpl.setRolesAttributes(selectedRoles, session);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		if (AuthenticationManagerUtil.isAM()) {
			session.setAttribute("amId", loggedInUser.getId());
		} else {
			session.setAttribute("amId", amId);
		}
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		Role sk = roleServiceImpl.findByKey("SK", "name", Role.class);
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		
		//for adding location and team
		model.addAttribute("teamMember", new TeamMember());
		model.addAttribute("branches", branches);
		String personName = "";
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		session.setAttribute("sk", sk);
		//session.setAttribute("skId", skId);
		//System.err.println("skId:::::" + skId);
		String redirectUrl = "redirect:/user/sk-list.html";
		/*if (StringUtils.isBlank(skUsername)) {
			return new ModelAndView(redirectUrl + "?lang=" + locale);
		}*/
		//model.addAttribute("skUsername", skUsername);
		//end: adding location and team
		return new ModelAndView("user/add-SK", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_ADD_SK')")
	@RequestMapping(value = "/user/{id}/edit-SK.html", method = RequestMethod.GET)
	public ModelAndView editSK(HttpSession session, @PathVariable("id") int id, Locale locale, Model model)
	    throws JSONException {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		model.addAttribute("id", id);
		//model.addAttribute("skId", skId);
		//model.addAttribute("skUsername", skUsername);
		//session.setAttribute("ssPrefix", account.getSsNo());
		
		String parentUserName = "";
		int parentUserId = 0;
		
		//List<Branch> branches = branchService.findAll("Branch");
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		session.setAttribute("parentUserName", parentUserName);
		session.setAttribute("parentUserId", parentUserId);
		
		session.setAttribute("selectedBranches", account.getBranches());
		
		return new ModelAndView("user/edit-SK", "command", account);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_USER')")
	@RequestMapping(value = "/user/{id}/edit-SK.html", method = RequestMethod.POST)
	public ModelAndView editSKPost(@RequestParam(value = "branches", required = false) String[] branches,
	                               @Valid @ModelAttribute("account") User account, BindingResult binding, ModelMap model,
	                               HttpSession session, @PathVariable("id") int id, Locale locale,
	                               RedirectAttributes redirectAttributes) throws Exception {
		Role ss = roleServiceImpl.findByKey("SK", "name", Role.class);
		Set<Role> roles = new HashSet<Role>();
		roles.add(ss);
		account.setRoles(roles);
		redirectAttributes.addAttribute("message", "Success");
		account.setBranches(userServiceImpl.setBranches(branches));
		account.setId(id);
		User user = userServiceImpl.findById(id, "id", User.class);
		if (user.getParentUser() != null) account.setParentUser(user.getParentUser());
		if (user.getCreator() != null) account.setCreator(user.getCreator());
		String redirectUrl = "redirect:/user/sk-list.html";
		
		userServiceImpl.update(account);
		return new ModelAndView(redirectUrl + "?lang=" + locale);
		
	}

	@RequestMapping(value = "/user/check-imei", method = RequestMethod.GET)
	public ResponseEntity<String> getHouseholdIds(@RequestParam("imei") String imei) {
		String isVerified = userServiceImpl.checkImei(imei)?"true":"false";
		return new ResponseEntity<>(isVerified, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/sk/{id}/edit-SK-ajax.html", method = RequestMethod.GET)
	public ModelAndView getSKAjax(HttpSession session, @PathVariable("id") int id, Locale locale, Model model)
	    throws JSONException {
		model.addAttribute("locale", locale);
		User account = userServiceImpl.findById(id, "id", User.class);
		model.addAttribute("account", account);
		model.addAttribute("id", id);	
		
		String parentUserName = "";
		int parentUserId = 0;
		
		
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		int amId = loggedInUser.getId();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		session.setAttribute("parentUserName", parentUserName);
		session.setAttribute("parentUserId", parentUserId);
		model.addAttribute("amId",amId);
		session.setAttribute("selectedBranches", account.getBranches());
		
		return new ModelAndView("user/edit-SK-ajax", "command", account);
	}
	
	@RequestMapping(value = "/user/add-SK-ajax.html", method = RequestMethod.GET)
	public ModelAndView addSKAjax(Model model, HttpSession session, Locale locale) throws JSONException {
		
		model.addAttribute("account", new User());		
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		/*if (AuthenticationManagerUtil.isAM()) {
			session.setAttribute("amId", loggedInUser.getId());
		} else {
			session.setAttribute("amId", amId);
		}*/
		
		session.setAttribute("amId", loggedInUser.getId());
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		Role sk = roleServiceImpl.findByKey("SK", "name", Role.class);
		model.addAttribute("locale", locale);		
		model.addAttribute("branches", branches);		
		session.setAttribute("sk", sk);		
		
		return new ModelAndView("user/add-SK-ajax", "command", account);
	}

	@RequestMapping(value = "/user/sk-list", method = RequestMethod.GET)
	public String generateSKListByBranch(HttpSession session, @RequestParam("branchId") Integer branchId) {
		List<UserDTO> skList = userServiceImpl.findSKByBranch(branchId);
		session.setAttribute("skList", skList);
		return "user/make-options";
	}

	@RequestMapping(value = "/{id}/catchment-area-table.html", method = RequestMethod.GET)
	public String catchmentAreaByUser(Model model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		List<Object[]> catchmentAreaTable = userServiceImpl.getCatchmentAreaTableForUser(id);
		session.setAttribute("catchmentAreaTable", catchmentAreaTable);
		session.setAttribute("userIdFromCatchment", id);
		return "location/assigned-location-table";
	}
}
