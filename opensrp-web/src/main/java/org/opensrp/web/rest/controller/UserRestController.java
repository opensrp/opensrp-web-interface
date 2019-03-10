package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.apache.log4j.Logger;
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
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.entity.FacilityWorkerType;
import org.opensrp.facility.service.FacilityService;
import org.opensrp.facility.service.FacilityWorkerTypeService;
import org.opensrp.web.controller.UserController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

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
	
	private static final Logger logger = Logger.getLogger(UserRestController.class);
	
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
				facility = (Facility) facilityService.findByKey(team.getLocation().getName(), "ward", Facility.class);
			}
			
			User user = new User();
			if (!isExists) {
				user = userServiceImpl.convert(userDTO);
				user.setChcp(facility.getId() + "");
				int numberOfUserSaved = (int) userServiceImpl.save(user, false);
				
				if (userDTO.isTeamMember()) {
					int[] locations = new int[5];
					locations[0] = team.getLocation().getId();
					user = userServiceImpl.findById(user.getId(), "id", User.class);
					teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember,
					    user.getId(), team, locations);
					teamMember.setIdentifier(userDTO.getIdetifier());
					
					teamMemberServiceImpl.save(teamMember);
					
					FacilityWorker facilityWorker = new FacilityWorker();
					facilityWorker.setName(user.getFullName());
					facilityWorker.setIdentifier(user.getMobile());
					facilityWorker.setOrganization("Community Clinic");
					FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findByKey("CHCP", "name",
					    FacilityWorkerType.class);
					facilityWorker.setFacility(facility);
					facilityWorker.setFacilityWorkerType(facilityWorkerType);
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
			userNameUniqueError = "some Problem ocuured please contact with Admin";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
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
				//System.out.println("in controller :"+user.toString());
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
				
				FacilityWorker facilityWorker = new FacilityWorker();
				facilityWorker.setName(user.getFullName());
				facilityWorker.setIdentifier(user.getMobile());
				facilityWorker.setOrganization("Community Clinic");
				FacilityWorkerType facilityWorkerType = facilityWorkerTypeService.findByKey("MULTIPURPOSE HEALTH VOLUNTEER",
				    "name", FacilityWorkerType.class);
				facilityWorker.setFacility(facility);
				facilityWorker.setFacilityWorkerType(facilityWorkerType);
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
