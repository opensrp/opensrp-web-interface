package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.apache.log4j.Logger;
import org.opensrp.core.service.HealthIdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/health-id")
@RestController
public class HealthIdRestController {
	
	private static final Logger logger = Logger.getLogger(HealthIdRestController.class);
	
	@Autowired
	private HealthIdService healthIdService;
	
	@RequestMapping(value = "/reserved", method = RequestMethod.GET)
	public ResponseEntity<String> getResearvedHealthId() throws Exception {
		
		try {
			return new ResponseEntity<>(new Gson().toJson(healthIdService.getHealthIdAndUpdateRecrd()), OK);
		}
		catch (Exception e) {
			logger.error("health id error:" + e);
		}
		return new ResponseEntity<>(new Gson().toJson("No Data Found"), HttpStatus.NO_CONTENT);
	}
}
