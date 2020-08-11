package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.entity.Target;
import org.opensrp.core.mapper.TargetMapper;
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
	
	@Autowired
	private TargetMapper targetMapper;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody TargetDTO dto) throws Exception {
		Target target = targetService.findById(dto.getId(), "id", Target.class);
		JSONObject response = new JSONObject();
		System.err.println(dto);
		try {
			if (target != null) {
				target = targetMapper.map(dto, target);
			} else {
				target = new Target();
				target = targetMapper.map(dto, target);
			}
			System.out.println(target.toString());
			if (target != null) {
				
				targetService.save(target);
			}
			response.put("status", "SUCCESS");
			response.put("msg", "you have created successfully.");
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
