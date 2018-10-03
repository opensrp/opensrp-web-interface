package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONException;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.service.impl.UserServiceImpl;
import org.opensrp.common.dto.UserDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/user")
@RestController
public class UserRestController {
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	@Autowired
	private User user;
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveUser(@RequestBody UserDTO userDTO) throws Exception {
		boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
		String userNameUniqueError = "";
		if (!isExists) {
			user = userServiceImpl.convert(userDTO);
			userServiceImpl.save(user);
		} else {
			userNameUniqueError = "User name alreday taken.";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}
	
	@RequestMapping(value = "/password/edit", method = RequestMethod.POST)
	public ResponseEntity<String> editPassword(@RequestBody UserDTO userDTO) throws Exception {
		boolean isExists = userServiceImpl.isUserExist(userDTO.getUsername());
		String userNameUniqueError = "";
		if (!isExists) {
			user = userServiceImpl.convert(userDTO);
			userServiceImpl.save(user);
		} else {
			userNameUniqueError = "User name alreday taken.";
		}
		return new ResponseEntity<>(new Gson().toJson(userNameUniqueError), OK);
	}
	
}
