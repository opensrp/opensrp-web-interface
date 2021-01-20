package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.MapMovement;
import org.opensrp.common.dto.PerformanceMapDTO;
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.util.ProductType;
import org.opensrp.common.util.TaregtSettingsType;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.entity.Location;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

@RequestMapping("rest/api/v1/target")
@RestController
public class TargetRestController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	private LocationService locationService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody TargetDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		String typeName = TaregtSettingsType.valueOf(dto.getType()).name();
		
		try {
			Integer isSave = targetService.saveAll(dto);
			if (typeName.equalsIgnoreCase("LOCATION")) {
				
				response.put("status", "FAILED");
				response.put("msg", "No branch found.");
				return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
				
			}
			if (isSave != null && isSave != 0) {
				response.put("status", "SUCCESS");
				response.put("msg", "You have submitted successfully.");
			} else {
				response.put("status", "FAILED");
				response.put("msg", "Something went wrong, please contact with admin .");
				
			}
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		catch (Exception e) {
			e.printStackTrace();
			response.put("status", "FAILED");
			response.put("msg", e.getMessage());
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		
	}
	
	@RequestMapping(value = "/target-availability", method = RequestMethod.GET, consumes = MediaType.APPLICATION_JSON_VALUE)
	public String findTargetForIndividual(@RequestParam(value = "userId") Integer userId,
	                                      @RequestParam(value = "year") Integer year,
	                                      @RequestParam(value = "month") Integer month,
	                                      @RequestParam(value = "branchId") Integer branchId,
	                                      @RequestParam(value = "day", required = false, defaultValue = "0") Integer day) {
		
		JsonObject ob = new JsonObject();
		ob.addProperty("exist", targetService.getTargetForIndividual(userId, year, month, day, branchId));
		return ob.toString();
	}
	
	@RequestMapping(value = "/population-wise-save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> populationWiseSaveTarget(@RequestBody TargetDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		
		try {
			Integer isSave = targetService.savePopulationWiseTargetAll(dto);
			if (isSave != null) {
				response.put("status", "SUCCESS");
				response.put("msg", "You have submitted successfully.");
			} else {
				response.put("status", "FAILED");
				response.put("msg", "Something went wrong please contact with admin .");
				
			}
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		catch (Exception e) {
			e.printStackTrace();
			response.put("status", "FAILED");
			response.put("msg", e.getMessage());
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		
	}
	
	// test api 
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<String> userWithoutCatchmentArea(HttpServletRequest request) throws Exception {
		System.err.println(targetService.allActiveTarget(28, ProductType.TARGET.name()));
		return new ResponseEntity<>("", OK);
	}
	
	@RequestMapping(value = "/sk-pa-user-list-for-individual-target-setting", method = RequestMethod.GET)
	public ResponseEntity<String> sellToSSlist(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = "";
		//UserColumn.valueOf("_" + orderColumn).getValue();
		
		String key = request.getParameter("searchKey");
		if (!StringUtils.isBlank(key)) {
			key = "%" + key + "%";
		}
		System.err.println("Key:::" + key);
		String branchIds = request.getParameter("branchId");
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		JSONObject json = new JSONObject();
		json.put("key", key);
		json.put("roleName", roleName);
		
		json.put("offset", start);
		json.put("limit", length);
		
		List<TargetCommontDTO> userList = targetService.getUserListForTargetSet(json, branchIds);
		int totalRecords = Integer.parseInt(request.getParameter("totalRecords"));
		
		int total = 0;
		if (start == 0) {
			
			total = targetService.getUserListForTargetSetCount(json, branchIds);
		} else {
			
			total = totalRecords;
		}
		
		JSONObject response = targetService.getUserListForTargetSetOfDataTable(draw, total, userList, start);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/branch-list-for-positional-target", method = RequestMethod.GET)
	public ResponseEntity<String> positionalTargetBranchList(HttpServletRequest request, HttpSession session)
	    throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		//orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		String branchIds = request.getParameter("branchId");
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		
		List<TargetCommontDTO> totalList = targetService.getBranchListForPositionalTarget(locationId, branchIds, roleName,
		    length, start, orderColumn, orderDirection);
		
		int totalRecords = Integer.parseInt(request.getParameter("totalRecords"));
		
		int total = 0;
		if (start == 0) {
			total = targetService.getBranchListForPositionalTargetCount(locationId, branchIds, roleName);
		} else {
			
			total = totalRecords;
		}
		
		JSONObject response = targetService.getPositionalTargetDataOfDataTable(draw, total, totalList, start);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/movements", method = RequestMethod.GET, produces = { "application/json" })
	public List<MapMovement> getProvidersMovement(@RequestParam("username") String username,
	                                              @RequestParam("startDate") String startDate,
	                                              @RequestParam("endDate") String endDate) {
		return targetService.getMapMovement(username, startDate, endDate);
	}
	
	@RequestMapping(value = "/pk-user-list-for-population-target-setting", method = RequestMethod.GET)
	public ResponseEntity<String> pkUserListForPopulationBaseTarget(HttpServletRequest request, HttpSession session)
	    throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		//orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		String branchIds = request.getParameter("branchId");
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		
		List<TargetCommontDTO> userList = targetService.getUserListForTargetSet(null, "");
		
		int userCount = targetService.getUserListForTargetSetCount(null, branchIds);
		
		JSONObject response = targetService.getUnionWisePopulationSetOfDataTable(draw, userCount, userList);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/location-based-performance-map", method = RequestMethod.GET)
	public List<PerformanceMapDTO> getPerfomance(@RequestParam(value = "startDate", required = false) String startDate,
	                                             @RequestParam(value = "endDate", required = false) String endDate,
	                                             @RequestParam(value = "address_field", required = false, defaultValue = "division") String locationTag,
	                                             @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
	                                             @RequestParam(value = "locationValue", required = false, defaultValue = "") String locationValue) {
		
		Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
		String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
		String parentLocationName = parentLocation.getName().split(":")[0];
		
		return targetService.getLocationBasedPerformanceMap(startDate, endDate, parentLocationTag, searchedValueId,
		    parentLocationName, locationTag);
	}
	
	@RequestMapping(value = "/location-based-performance-chart", method = RequestMethod.GET)
	public List<PerformanceMapDTO> getPerfomanceChart(@RequestParam(value = "startDate", required = false) String startDate,
	                                                  @RequestParam(value = "endDate", required = false) String endDate,
	                                                  @RequestParam(value = "address_field", required = false, defaultValue = "division") String locationTag,
	                                                  @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
	                                                  @RequestParam(value = "locationValue", required = false, defaultValue = "") String locationValue) {
		
		Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
		String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
		String parentLocationName = parentLocation.getName().split(":")[0];
		
		return targetService.getLocationBasedPerformanceChart(startDate, endDate, parentLocationTag, searchedValueId,
		    parentLocationName, locationTag);
	}
	
}
