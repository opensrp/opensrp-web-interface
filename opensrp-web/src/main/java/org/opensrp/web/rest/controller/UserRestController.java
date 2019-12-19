package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.dto.ChangePasswordDTO;
import org.opensrp.common.dto.UserAssignedLocationDTO;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.core.dto.UserLocationDTO;
import org.opensrp.core.entity.*;
import org.opensrp.core.service.*;
import org.opensrp.core.service.mapper.FacilityWorkerMapper;
import org.opensrp.core.service.mapper.UserMapper;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@RequestMapping("rest/api/v1/user")
@RestController
public class UserRestController {
	
	@Autowired
	private UserService userServiceImpl;
	
	@Autowired
	private TeamMemberService teamMemberServiceImpl;
	
	@Autowired
	private TeamService teamService;

	@Autowired
	private FacilityService facilityService;
	
	@Autowired
	private RoleService roleService;

	@Autowired
	private FacilityWorkerTypeService facilityWorkerTypeService;
	
	@Autowired
	private LocationService locationService;
	
	@Autowired
	private EmailService emailService;

	@Autowired
	private FacilityWorkerMapper facilityWorkerMapper;

	@Autowired
	private UserMapper userMapper;

	@Autowired
	private UsersCatchmentAreaService usersCatchmentAreaService;

	private static final Logger logger = Logger.getLogger(UserRestController.class);
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveUser(@RequestBody UserDTO userDTO,
	                                       ModelMap model) throws Exception {
		
		//TeamMember teamMember = new TeamMember();
		String userNameUniqueError = "";
		//Team team = new Team();
		try {
			User user = userMapper.map(userDTO);
			User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
			user.setCreator(loggedInUser);
			boolean isExists = userServiceImpl.isUserExist(user.getUsername());
			if (!isExists) {
				int numberOfUserSaved = (int) userServiceImpl.save(user, false);
				//				String mailBody = "Dear " + user.getFullName()
				//						+ ",\n\nYour login credentials for HNPP are given below -\nusername : " + user.getUsername()
				//						+ "\npassword : " + userDTO.getPassword();
				//				if (numberOfUserSaved > 0) {
				//					logger.info("<><><><><> in user rest controller before sending mail to-" + user.getEmail());
				//					emailService.sendSimpleMessage(user.getEmail(), "Login credentials for CBHC", mailBody);
				//				}

			} else {
				userNameUniqueError = "User name already taken.";
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			userNameUniqueError = "Some problem occurred please contact with Admin";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}

	@RequestMapping(value = "/change-password", method = RequestMethod.POST)
	public ResponseEntity<String> changeUserPassword(HttpSession session, @RequestBody ChangePasswordDTO dto, ModelMap model) {
		try {
			userServiceImpl.changePassword(session, dto);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<>(new Gson().toJson(""), OK);
	}
	
	@RequestMapping(value = "/{id}/mhv", method = RequestMethod.POST)
	public ResponseEntity<String> saveUserMHV(@PathVariable("id") int facilityId, @RequestBody UserDTO userDTO,
	                                          ModelMap model) throws Exception {
		TeamMember teamMember = new TeamMember();
		String userNameUniqueError = "";
		Team team = new Team();
		Facility facility = new Facility();
		User user = new User();
		String firstName = "";
		String lastName = "";
		try {
			boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
			Role role = roleService.findByKey("Provider", "name", Role.class);
			userDTO.setRoles("" + role.getId());
			facility = (Facility) facilityService.findById(facilityId, "id", Facility.class);
			Location location = locationService.findByKey(facility.getWard(), "name", Location.class);
			team = teamService.findByKey(location.getUuid(), "locationUuid", Team.class);
			
			if (!isExists) {
				user = userServiceImpl.convert(userDTO);
				user.setChcp(facility.getId() + "");
				firstName = user.getFirstName();
				lastName = user.getLastName();
				int numberOfUserSaved = (int) userServiceImpl.save(user, false);
				String[] locations = userDTO.getLocationList().split(",");
				int[] locationList = new int[locations.length];
				for (int i = 0; i < locations.length; i++) {
					locationList[i] = Integer.parseInt(locations[i]);
				}
				user = userServiceImpl.findById(user.getId(), "id", User.class);
				teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember,
				    user.getId(), team, locationList);
				teamMember.setIdentifier(userDTO.getIdetifier());
				teamMemberServiceImpl.save(teamMember);

				FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findByKey("MULTIPURPOSE HEALTH VOLUNTEER",
				    "name", FacilityWorkerType.class);

				FacilityWorker facilityWorker = facilityWorkerMapper.map(user, facility, facilityWorkerType);

				facilityWorkerTypeService.save(facilityWorker);

				String mailBody = "Dear " + user.getFullName()
				        + ",\n\nYour login credentials for CBHC are given below -\nusername : " + user.getUsername()
				        + "\npassword : " + userDTO.getPassword();

				if (numberOfUserSaved > 0) {
					logger.info("<><><><><> in user rest controller before sending mail to-" + user.getEmail());
					emailService.sendSimpleMessage(user.getEmail(), "Login credentials for CBHC", mailBody);
				}
				
			} else {
				userNameUniqueError = "User name already taken.";
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			String errorMessage = "";
			if (user.getUuid() == null && user.getFirstName().equals("error")) {
				errorMessage = user.getLastName();
				userNameUniqueError = errorMessage;
				user.setFirstName(firstName);
				user.setLastName(lastName);
			} else {
				userNameUniqueError = "Some problem occurred please contact with Admin";
			}
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}
	
	@RequestMapping(value = "/password/edit", method = RequestMethod.POST)
	public ResponseEntity<String> editPassword(@RequestBody UserDTO userDTO) throws Exception {
		boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
		String userNameUniqueError = "";
		User user = new User();
		if (!isExists) {
			user = userServiceImpl.convert(userDTO);
			userServiceImpl.save(user, false);
		} else {
			userNameUniqueError = "User name alreday taken.";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}

	@RequestMapping(value = "/catchment-area/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveUsersCatchmentArea(HttpSession session, @RequestBody UserLocationDTO userLocationDTO) throws Exception {
		String errorMessage = "";
		System.out.println("ERROR 500");
		userServiceImpl.saveTeamMemberAndCatchmentAreas(session, userLocationDTO);
		return new ResponseEntity<>(new Gson().toJson(errorMessage), OK);
	}

	@RequestMapping(value = "/catchment-area/update", method = RequestMethod.POST)
	public ResponseEntity<String> updateUsersCatchmentArea(HttpSession session, @RequestBody UserLocationDTO userLocationDTO) throws Exception {
		String errorMessage = "";
		userServiceImpl.updateTeamMemberAndCatchmentAreas(session, userLocationDTO);
		return new ResponseEntity<>(new Gson().toJson(errorMessage), OK);
	}

	@RequestMapping(value = "/{id}/catchment-area", method = RequestMethod.GET)
	public ResponseEntity<String> catchmentArea(Model model, HttpSession session, @PathVariable("id") int id, Locale locale)
			throws JSONException {

		String role = "Admin";
		if (AuthenticationManagerUtil.isAM())
			role = "AM";

		String parentIndication = "#";
		String parentKey = "parent";
		List<UsersCatchmentArea> usersCatchmentAreas = usersCatchmentAreaService.findAllByForeignKey(id, "user_id",
				"UsersCatchmentArea");
		List<Object[]> catchmentAreas = userServiceImpl.getUsersCatchmentAreaTableAsJson(id);
		User user = userServiceImpl.findById(id, "id", User.class);
		List<Role> roles = new ArrayList<>(user.getRoles());

		Integer roleId = roles.get(0).getId();
		List<UserAssignedLocationDTO> userAssignedLocationDTOS = userServiceImpl.assignedLocationByRole(roleId);

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		JSONArray data = locationService.getLocationWithDisableFacility(session, parentIndication, parentKey,
				userAssignedLocationDTOS, user.getId(), role, loggedInUser.getId());

		session.setAttribute("locationTreeData", data);
		session.setAttribute("user", user);
		session.setAttribute("assignedLocation", userAssignedLocationDTOS);
		session.setAttribute("userId", id);
		session.setAttribute("usersCatchmentAreas", usersCatchmentAreas);
		session.setAttribute("catchmentAreaTable", catchmentAreas);

		return new ResponseEntity<>(new Gson().toJson("done"), OK);
	}
}
