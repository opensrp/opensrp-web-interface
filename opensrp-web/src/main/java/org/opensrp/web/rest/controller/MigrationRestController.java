package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.service.MigrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;

@RequestMapping("rest/api/v1/migration")
@RestController
public class MigrationRestController {
	
	@Autowired
	private MigrationService migrationService;
	
	@RequestMapping(value = "/household-in/list", method = RequestMethod.GET)
	public ResponseEntity<String> householdList(HttpServletRequest request, HttpSession session) throws JSONException,
	    JsonProcessingException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		
		JSONObject jo = new JSONObject();
		jo.put("end_date", request.getParameter("endDate"));
		jo.put("start_date", request.getParameter("startDate"));
		jo.put("searchKeyIn", request.getParameter("searchKeyIn"));
		jo.put("searchKeyOut", request.getParameter("searchKeyOut"));
		jo.put("member_type", "HH");
		jo.put("offset", start);
		jo.put("limit", length);
		List<String> households = new ArrayList<>();
		try {
			households = migrationService.getMigratedHousehold(jo, request.getParameter("branchIdIn"),
			    request.getParameter("branchIdOut"));
		}
		catch (Exception e) {
			
		}
		
		JSONObject response = migrationService.drawMigratedInHouseholdDataTable(draw,
		    migrationService.getMigratedHouseholdCount(jo, request.getParameter("branchIdIn"), ""), households);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/member/list", method = RequestMethod.GET)
	public ResponseEntity<String> memberList(HttpServletRequest request, HttpSession session) throws JSONException,
	    JsonProcessingException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		
		JSONObject jo = new JSONObject();
		jo.put("end_date", request.getParameter("endDate"));
		jo.put("start_date", request.getParameter("startDate"));
		jo.put("searchKeyIn", request.getParameter("searchKeyIn"));
		jo.put("searchKeyOut", request.getParameter("searchKeyOut"));
		jo.put("member_type", "Member");
		jo.put("offset", start);
		jo.put("limit", length);
		List<String> households = new ArrayList<>();
		try {
			households = migrationService.getMigratedHousehold(jo, request.getParameter("branchIdIn"),
			    request.getParameter("branchIdOut"));
		}
		catch (Exception e) {
			
		}
		
		JSONObject response = migrationService.drawMigratedInHouseholdDataTable(draw,
		    migrationService.getMigratedHouseholdCount(jo, request.getParameter("branchIdIn"), ""), households);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	/*@RequestMapping(value = "/member/list", method = RequestMethod.GET)
	public ResponseEntity<String> memberList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = MemberColumn.valueOf("_" + orderColumn).getValue();
		
		String searchKey = request.getParameter("search");
		String baseEntityId = request.getParameter("baseEntityId");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		
		String location = request.getParameter("locationId");
		
		List<ClientListDTO> data = peopleService.getMemberData(baseEntityId);
		
		JSONObject response = peopleService.drawMemberDataTable(draw, 0, data);
		return new ResponseEntity<>(response.toString(), OK);
	}
	*/
}
