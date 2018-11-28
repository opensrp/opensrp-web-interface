package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import javax.validation.Valid;

import org.opensrp.common.dto.UserDTO;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.TeamMemberService;
import org.opensrp.core.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
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
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveUser(@RequestBody UserDTO userDTO, ModelMap model) throws Exception {
		System.out.println(userDTO.toString());
		TeamMember teamMember = new TeamMember();
		String userNameUniqueError = "";
		try {
			boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
			
			User user = new User();
			if (!isExists) {
				user = userServiceImpl.convert(userDTO);
				userServiceImpl.save(user, false);
				//this part of the code only works if the user is provider/chcp (isTeamMember = true)
				if (userDTO.isTeamMember()) {
					//assign user to team and location
					//added to get uuid in user
					user = userServiceImpl.findById(user.getId(), "id", User.class);
					teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember,
					    user.getId(), userDTO.getTeam(), userDTO.getLocationList());
					teamMember.setIdentifier(userDTO.getIdetifier());
					
					if (!teamMemberServiceImpl.isPersonAndIdentifierExists(model, teamMember, userDTO.getLocationList())) {
						teamMemberServiceImpl.save(teamMember);
					}
					//end: assign user to team and location
				}
			} else {
				userNameUniqueError = "User name alreday taken.";
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			userNameUniqueError = "some Problem ocuured please contact with Admin";
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
