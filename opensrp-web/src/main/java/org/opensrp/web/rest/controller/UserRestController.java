package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import jdk.nashorn.api.scripting.JSObject;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.Team;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.RoleService;
import org.opensrp.core.service.TeamMemberService;
import org.opensrp.core.service.TeamService;
import org.opensrp.core.service.UserService;
import org.opensrp.core.service.EmailService;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.FacilityWorkerType;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.FacilityWorkerTypeService;
import org.opensrp.core.service.mapper.FacilityWorkerMapper;
import org.opensrp.core.service.mapper.UserMapper;
import org.opensrp.web.controller.UserController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import sun.misc.BASE64Decoder;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

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
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	private UserMapper userMapper;
	
	private static final Logger logger = Logger.getLogger(UserRestController.class);

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ResponseEntity<String> loginUser(HttpServletRequest httpRequest) throws IOException, JSONException {
		JSONObject object = new JSONObject();
		object.put("is_authenticated", false);
		final String authorization = httpRequest.getHeader("Authorization");
		if (authorization != null && authorization.toLowerCase().startsWith("basic")) {
			// Authorization: Basic base64credentials
			String base64Credentials = authorization.substring("Basic".length()).trim();
			byte[] credDecoded = new BASE64Decoder().decodeBuffer(base64Credentials);
			String credentials = new String(credDecoded, StandardCharsets.UTF_8);
			// credentials = username:password
			final String[] values = credentials.split(":", 2);
			User user = userServiceImpl.findByKey(values[0], "username", User.class);
			boolean match = bCryptPasswordEncoder.matches(values[1], user.getPassword());
			object.put("is_authenticated", match);
			return new ResponseEntity<>(object.toString(), OK);
		}
		return new ResponseEntity<>(object.toString(), OK);
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveUser(@RequestBody UserDTO userDTO, ModelMap model) throws Exception {
		
		TeamMember teamMember = new TeamMember();
		String userNameUniqueError = "";
		Team team = new Team();
		Facility facility = new Facility();
		try {
			boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
			if (userDTO.isTeamMember()) {
				team = teamService.findById(userDTO.getTeam(), "id", Team.class);
				facility = facilityService.findByKey(team.getLocation().getName(), "ward", Facility.class);
			}

			if (!isExists) {
				User user = userMapper.map(userDTO);
				user.setChcp(facility.getId() + "");
				int numberOfUserSaved = (int) userServiceImpl.save(user, false);
				
				if (userDTO.isTeamMember()) {
					int[] locations = new int[5];
					locations[0] = team.getLocation().getId();
					user = userServiceImpl.findById(user.getId(), "id", User.class);
					teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember,
					    user.getId(), team, locations);
					teamMember.setIdentifier(userDTO.getIdetifier());
					logger.info(" \nTeamMember : "+ teamMember.toString() + "\n");
					teamMemberServiceImpl.save(teamMember);

					FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findByKey("CHCP", "name",
							FacilityWorkerType.class);
					
					FacilityWorker facilityWorker = facilityWorkerMapper.map(user, facility, facilityWorkerType);

					logger.info(" \nFacilityWorkerType : "+ facilityWorkerType.toString() + "\n");
					facilityWorkerTypeService.save(facilityWorker);
					String mailBody = "Dear " + user.getFullName()
					        + ",\n\nYour login credentials for CBHC are given below -\nusername : " + user.getUsername()
					        + "\npassword : " + userDTO.getPassword();
					if (numberOfUserSaved > 0) {
						logger.info("<><><><><> in user rest controller before sending mail to-" + user.getEmail());
						emailService.sendSimpleMessage(user.getEmail(), "Login credentials for CBHC", mailBody);
					}
				}
			} else {
				userNameUniqueError = "User name already taken.";
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			userNameUniqueError = "some Problem occurred please contact with Admin";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}
	
	@RequestMapping(value = "/{id}/mhv", method = RequestMethod.POST)
	public ResponseEntity<String> saveUserMHV(@PathVariable("id") int facilityId,
                                              @RequestBody UserDTO userDTO,
	                                          ModelMap model) throws Exception {
		TeamMember teamMember = new TeamMember();
		String userNameUniqueError = "";
		Team team = new Team();
		Facility facility = new Facility();
		User loggedInUser = userServiceImpl.getLoggedInUser();
		TeamMember loggedInMember = teamMemberServiceImpl.findByForeignKey(loggedInUser.getId(),"person_id", "TeamMember");
		User user = new User();
		String firstName = "";
		String lastName = "";
		try {
			boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
			Role role = roleService.findByKey("Provider", "name", Role.class);
			userDTO.setRoles("" + role.getId());
			facility = (Facility) facilityService.findById(facilityId, "id", Facility.class);
			team = loggedInMember.getTeam();
			
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
				userNameUniqueError = "some Problem ocuured please contact with Admin";
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
	
}
