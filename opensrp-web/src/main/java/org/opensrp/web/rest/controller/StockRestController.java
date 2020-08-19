package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONObject;
import org.opensrp.core.dto.StockDTO;
import org.opensrp.core.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/stock")
@RestController
public class StockRestController {
	
	@Autowired
	private StockService stockService;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody StockDTO dto) throws Exception {
		
		JSONObject response = new JSONObject();
		System.err.println("DDD;" + dto);
		try {
			
			Integer isSave = stockService.saveAll(dto);
			if (isSave != null) {
				response.put("status", "SUCCESS");
				response.put("msg", "you have created successfully");
			} else {
				response.put("status", "FAILED");
				response.put("msg", "Something went worng please contact with admin.");
			}
			
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			response.put("msg", e.getMessage());
			return new ResponseEntity<>(new Gson().toJson(response.toString()), OK);
		}
		
	}
}
