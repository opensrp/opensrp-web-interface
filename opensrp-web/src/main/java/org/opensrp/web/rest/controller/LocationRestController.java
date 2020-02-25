package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.LocationDTO;
import org.opensrp.common.util.LocationColumn;
import org.opensrp.common.util.UserColumn;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.UserService;
import org.opensrp.core.service.mapper.LocationMapper;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping("rest/api/v1/location")
@RestController
public class LocationRestController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private UserService userServiceImpl;

	@Autowired
	private LocationMapper locationMapper;
	
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
			
			response.put("locations", stringBuilder);
			response.put("role", roleName);
			return new ResponseEntity<>(response.toString(), OK);
		}
		
		return new ResponseEntity<>(response.toString(), HttpStatus.NO_CONTENT);
		
	}

	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<String> saveLocation(HttpSession session, ModelMap model, @RequestBody LocationDTO locationDTO) throws Exception {
		Location location = locationMapper.map(locationDTO);
		try {
			if (!locationServiceImpl.locationExists(location)) {
				locationServiceImpl.saveToOpenSRP(location);
			} else {
				String errorMessage = "Specified location already exists, please specify another";
				return new ResponseEntity<> (new Gson().toJson(errorMessage), OK);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<> (new Gson().toJson(e.getMessage()), OK);
		}
		return new ResponseEntity<>(new Gson().toJson(""), OK);
	}

	@RequestMapping(value = "/edit", method = RequestMethod.PUT)
	public ResponseEntity<String> editLocation(@RequestBody LocationDTO locationDTO) throws JSONException {
		return null;
	}

	@RequestMapping(value = "/list-ajax", method = RequestMethod.GET)
	public ResponseEntity<String> getLocationPagination(HttpServletRequest request) throws JSONException {
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String name = request.getParameter("search[value]");
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = LocationColumn.valueOf("_"+orderColumn).getValue();
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		List<LocationDTO> locations = locationServiceImpl.getLocations(name, length, start, orderColumn, orderDirection);
		Integer totalLocation = locationServiceImpl.getLocationCount(name);
		JSONObject response = locationServiceImpl.getLocationDataOfDataTable(draw, totalLocation, locations);
		return new ResponseEntity<>(response.toString(), OK);
	}
}
