package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.OK;

import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.entity.Location;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/team")
@RestController
public class TeamRestController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private TeamService teamService;
	
	@RequestMapping(value = "/team-by-location", method = RequestMethod.GET)
	public ResponseEntity<String> getteamByLocation(Model model, HttpSession session, @RequestParam String name)
	    throws JSONException {
		
		try {
			
			Location location = locationServiceImpl.findByKey(name.toUpperCase().trim(), "name", Location.class);
			//Team team = teamService.findByKey(location.getUuid(), "locationUuid", Team.class);
			JSONObject teamObject = new JSONObject();
			//teamObject.put("teamUuid", team.getUuid());
			teamObject.put("locationUuid", location.getUuid());
			//teamObject.put("team", team.getName());
			return new ResponseEntity<>(new Gson().toJson(teamObject), OK);
		}
		catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(new Gson().toJson(e.getMessage()), BAD_REQUEST);
		}
		
	}
}
