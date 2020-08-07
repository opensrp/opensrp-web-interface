package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONObject;
import org.opensrp.core.dto.RequisitionDTO;
import org.opensrp.core.entity.Requisition;
import org.opensrp.core.mapper.RequisitionMapper;
import org.opensrp.core.service.RequisitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/requisition")
@RestController
public class RequisitionRestController {
	
	@Autowired
	private RequisitionService requisitionService;
	
	@Autowired
	private RequisitionMapper requisitionMapper;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody RequisitionDTO dto) throws Exception {
		Requisition requisition = requisitionService.findById(dto.getId(), "id", Requisition.class);
		JSONObject response = new JSONObject();
		try {
			if (requisition != null) {
				requisition = requisitionMapper.map(dto, requisition);
			} else {
				requisition = new Requisition();
				requisition = requisitionMapper.map(dto, requisition);
			}
			
			if (requisition != null) {
				
				requisitionService.save(requisition);
			}
			response.put("status", "SUCCESS");
			response.put("msg", "you have successfully added the requisition");
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
