package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.util.Roles;
import org.opensrp.common.util.UserColumn;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/training")
@RestController
public class TrainingRestController {
	
	@Autowired
	private TrainingService trainingService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody TrainingDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		
		try {
			trainingService.save(dto);
			response.put("status", "SUCCESS");
			response.put("msg", "you have created successfully");
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		catch (Exception e) {
			
			response.put("status", "FAILED");
			response.put("msg", e.getMessage());
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		
	}
	
	@RequestMapping(value = "/training-list", method = RequestMethod.GET)
	public ResponseEntity<String> getTrainingList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		int locationId = Integer.parseInt(request.getParameter("locationId"));
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String trainingTitle = request.getParameter("trainingTitle");
		
		List<TrainingDTO> trainingList = trainingService.getTrainingList(locationId, branchId, roleId, trainingTitle,
		    startDate, endDate, length, start, orderColumn, orderDirection);
		
		int trainingListCount = trainingService.getTrainingListCount(locationId, branchId, roleId, startDate, endDate);
		
		JSONObject response = trainingService.geTrainingListSetOfDataTable(draw, trainingListCount, trainingList);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
	@RequestMapping(value = "/training-attendance-list", method = RequestMethod.GET)
	public ResponseEntity<String> getTrainingAttendanceList(HttpServletRequest request, HttpSession session)
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
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		
		List<InventoryDTO> trainingList = trainingService.getTrainingAttendanceList(branchId, roleId, Roles.SS.getId(),
		    Roles.ADMIN.getId(), start, length);
		
		int trainingAttendanceListCount = trainingService.getTrainingAttendanceListCount(branchId, roleId, Roles.SS.getId(),
		    Roles.ADMIN.getId());
		
		JSONObject response = trainingService.geTrainingAttendanceListSetOfDataTable(draw, trainingAttendanceListCount,
		    trainingList);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
}
