package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.WebNotificationCommonDTO;
import org.opensrp.common.util.UserColumn;
import org.opensrp.core.dto.WebNotificationDTO;
import org.opensrp.core.service.WebNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/web-notfication")
@RestController
public class WebNotificationRestController {
	
	@Autowired
	private WebNotificationService webNotificationService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody WebNotificationDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		
		try {
			Integer isSave = webNotificationService.saveAll(dto);
			if (isSave == 1) {
				response.put("status", "SUCCESS");
				response.put("msg", "You have submitted successfully.");
			} else {
				response.put("status", "FAILED");
				response.put("msg", "Something went worng please contact with admin.");
				
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
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<String> sellToSSlist(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		System.err.println(request.getParameter("roleId"));
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String type = request.getParameter("type");
		
		List<WebNotificationCommonDTO> list = webNotificationService.getWebNotificationList(locationId, branchId, roleId,
		    startDate, endDate, type, length, start, orderColumn, orderDirection);
		
		int total = webNotificationService.getWebNotificationListCount(locationId, branchId, roleId, startDate, endDate,
		    type);
		
		JSONObject response = webNotificationService.drawDataTableOfWebNotification(draw, total, list);
		return new ResponseEntity<>(response.toString(), OK);
	}
}
