package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONObject;
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
	
}
