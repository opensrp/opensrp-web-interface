package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("rest/api/v1/location")
@RestController
public class LocationRestController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private UserService userServiceImpl;
	
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String getLocationNameAndId(Model model, HttpSession session, @RequestParam String name) throws JSONException {
		return locationServiceImpl.search(name).toString();
		
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String getLocationList(Model model, HttpSession session) throws JSONException {
		return locationServiceImpl.list().toString();
		
	}
	
	@RequestMapping(value = "/location-name", method = RequestMethod.GET)
	public ResponseEntity<String> getLocationNameByUserName(Model model, HttpSession session, @RequestParam String name)
	    throws JSONException {
		User user = userServiceImpl.findByKey(name, "username", User.class);
		JSONObject response = new JSONObject();
		if (user != null) {
			String roleName = "";
			Set<Role> roles = user.getRoles();
			if (roles.size() != 0) {
				for (Role role : roles) {
					roleName = role.getName();
				}
			}
			String sqlQuery = "select team_member.id,core.location.name as name from core.team_member left join "
			        + "core.team_member_location on team_member.id = team_member_location.team_member_id left join "
			        + "core.location on  team_member_location.location_id = location.id where team_member.person_id =:userId";
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("userId", user.getId());
			List<Object[]> locations = locationServiceImpl.executeSelectQuery(sqlQuery, params);
			StringBuilder stringBuilder = new StringBuilder();
			int i = 0;
			for (Object[] location : locations) {
				if (i == 0) {
					stringBuilder.append(location[1]);
				} else {
					stringBuilder.append(",").append(location[1]);
				}
				i++;
			}
			List<String> address = new ArrayList<String>();
			address = new ArrayList<String>(Arrays.asList(stringBuilder.toString().split(",")));
			System.err.println("address:" + address);
			response.put("locations", stringBuilder.toString().replaceAll(", $", ""));
			response.put("role", roleName);
			return new ResponseEntity<>(response.toString(), OK);
		}
		
		return new ResponseEntity<>(response.toString(), HttpStatus.NO_CONTENT);
		
	}
}
