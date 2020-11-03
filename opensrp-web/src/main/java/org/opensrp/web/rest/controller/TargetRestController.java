package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.api.client.json.Json;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.util.UserColumn;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/target")
@RestController
public class TargetRestController {
	
	@Autowired
	private TargetService targetService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody TargetDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		
		try {
			Integer isSave = targetService.saveAll(dto);
			if (isSave != null) {
				response.put("status", "SUCCESS");
				response.put("msg", "You have submitted successfully.");
			} else {
				response.put("status", "FAILED");
				response.put("msg", "Something went worng please contact with admin .");
				
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
	public String findTargetForIndividual(
			@RequestParam(value = "locationOrBranchOrUserId") Integer locationOrBranchOrUserId,
			@RequestParam(value = "roleId") Integer roleId,
			@RequestParam(value = "year") Integer year,
			@RequestParam(value = "month") Integer month,
			@RequestParam(value = "locationTag", required= false, defaultValue = "NA") String locationTag,
			@RequestParam(value = "typeName") String typeName,
			@RequestParam(value = "day", required = false, defaultValue = "0") Integer day) {

		JsonObject ob = new JsonObject();
		ob.addProperty("exist", targetService.getTargetForGivenTimePeriod(roleId, locationOrBranchOrUserId, typeName, locationTag, month, year, day));
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
				response.put("msg", "Something went worng please contact with admin .");
				
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
		System.err.println(targetService.allActiveTarget(28));
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
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		
		List<TargetCommontDTO> userList = targetService.getUserListForTargetSet(locationId, branchId, roleName, length,
		    start, orderColumn, orderDirection);
		
		int userCount = targetService.getUserListForTargetSetCount(locationId, branchId, roleName);
		
		JSONObject response = targetService.getUserListForTargetSetOfDataTable(draw, userCount, userList);
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
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		
		List<TargetCommontDTO> totalList = targetService.getBranchListForPositionalTarget(locationId, branchId, roleName,
		    length, start, orderColumn, orderDirection);
		
		int total = targetService.getBranchListForPositionalTargetCount(locationId, branchId, roleName);
		
		JSONObject response = targetService.getPositionalTargetDataOfDataTable(draw, total, totalList);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/pk-user-list-for-population-target-setting", method = RequestMethod.GET)
	public ResponseEntity<String> pkUserListForPopulationBaseTarget(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		String roleName = request.getParameter("roleName");
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		
		List<TargetCommontDTO> userList = targetService.getUserListForTargetSet(locationId, branchId, roleName, length,
		    start, orderColumn, orderDirection);
		
		int userCount = targetService.getUserListForTargetSetCount(locationId, branchId, roleName);
		
		JSONObject response = targetService.getUnionWisePopulationSetOfDataTable(draw, userCount, userList);
		return new ResponseEntity<>(response.toString(), OK);
	}
}
