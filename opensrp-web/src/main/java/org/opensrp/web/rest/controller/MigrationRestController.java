package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.connector.util.HttpUtil;
import org.opensrp.core.service.MigrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.google.gson.Gson;

@RequestMapping("rest/api/v1/migration")
@RestController
public class MigrationRestController {
	
	@Autowired
	private MigrationService migrationService;
	
	@Autowired
	private HttpUtil httpUtil;
	
	@Value("#{opensrp['opensrp.url']}")
	private String opensrpUrl;
	
	@Value("#{opensrp['opensrp.username']}")
	private String opensrpUsername;
	
	@Value("#{opensrp['opensrp.password']}")
	private String opensrpPassword;
	
	@RequestMapping(value = "/household-in/list", method = RequestMethod.GET)
	public ResponseEntity<String> householdList(HttpServletRequest request, HttpSession session) throws JSONException,
	    JsonProcessingException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String migrateType = request.getParameter("migrateType");
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
		    migrationService.getMigratedHouseholdCount(jo, request.getParameter("branchIdIn"), ""), households, migrateType);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/member/list", method = RequestMethod.GET)
	public ResponseEntity<String> memberList(HttpServletRequest request, HttpSession session) throws JSONException,
	    JsonProcessingException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String migrateType = request.getParameter("migrateType");
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
		
		JSONObject response = migrationService.drawMigratedInmemberDataTable(draw,
		    migrationService.getMigratedHouseholdCount(jo, request.getParameter("branchIdIn"), ""), households, migrateType);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@SuppressWarnings("static-access")
	@RequestMapping(value = "/accept-reject", method = RequestMethod.POST)
	public ResponseEntity<String> acceptReject(HttpServletRequest request, @RequestParam("id") Long id,
	                                           @RequestParam("type") String type, @RequestParam("status") String status,
	                                           @RequestParam("relationalId") String relationalId) throws JSONException {
		
		String payload = "id=" + id + "&type=" + type + "&relationalId=" + relationalId + "&status=" + status;
		HttpResponse body = httpUtil.post(opensrpUrl + "rest/event/accept-reject-migration", payload, "", opensrpUsername,
		    opensrpPassword);
		JSONObject response = new JSONObject();
		
		response.put("status", body.body());
		return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
	}
}
