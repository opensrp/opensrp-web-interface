package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.opensrp.core.service.HealthIdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("rest/api/v1/health-id")
@RestController
public class HealthIdRestController {
	
	private static final Logger logger = Logger.getLogger(HealthIdRestController.class);
	
	@Autowired
	private HealthIdService healthIdService;
	
	@RequestMapping(value = "/reserved", method = RequestMethod.GET)
	public ResponseEntity<String> getResearvedHealthId() throws Exception {
		
		try {
			return new ResponseEntity<>(healthIdService.getHealthIdAndUpdateRecord().toString(), OK);
		}
		catch (Exception e) {
			logger.error("health id error:" + e);
		}
		return new ResponseEntity<>("No Data Found", HttpStatus.NO_CONTENT);
	}
	
	@RequestMapping(value = "/reserved/single", method = RequestMethod.GET)
	public ResponseEntity<String> getSingleResearvedHealthId() throws Exception {
		JSONObject noContent = new JSONObject();
		noContent.put("identifiers", "");
		try {
			return new ResponseEntity<>(healthIdService.getSingleHealthIdAndUpdateRecord().toString(), OK);
		}
		catch (Exception e) {
			logger.error("health id error:" + e);
		}
		return new ResponseEntity<>(noContent.toString(), HttpStatus.NO_CONTENT);
	}
	
	@RequestMapping(value = "/reserved/single/migration", method = RequestMethod.GET)
	public ResponseEntity<String> getSingleReservedHealthIdForMigration() throws Exception {
		JSONObject noContent = new JSONObject();
		noContent.put("identifiers", "");
		try {
			return new ResponseEntity<>(healthIdService.getSingleHealthIdAndUpdateRecord().toString(), OK);
		}
		catch (Exception e) {
			logger.error("health id error:" + e);
		}
		return new ResponseEntity<>(noContent.toString(), HttpStatus.NO_CONTENT);
	}
}
