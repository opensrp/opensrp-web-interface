package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/target")
@RestController
public class TargetRestController {
	
	@Autowired
	private TargetService targetService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody TargetDTO dto) throws Exception {
		
		System.err.println("OKKK");
		JSONObject response = new JSONObject();
		
		try {
			Integer isSave = targetService.saveAll(dto);
			if (isSave != null) {
				response.put("status", "FAILED");
				response.put("msg", "you have created successfully.");
			} else {
				response.put("status", "SUCCESS");
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
	
	// test api 
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<String> userWithoutCatchmentArea(HttpServletRequest request) throws Exception {
		System.err.println(targetService.allActiveTarget(28));
		return new ResponseEntity<>("", OK);
	}
}
