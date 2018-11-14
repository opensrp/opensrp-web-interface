package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.opensrp.core.dto.FormUploadIdDTO;
import org.opensrp.core.entity.FormUpload;
import org.opensrp.core.service.FormService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/form")
@RestController
public class FormRestController {
	
	@Autowired
	FormUpload formUpload;
	
	@Autowired
	FormService formService;
	
	@RequestMapping(value = "/deleteForm", method = RequestMethod.POST)
	public ResponseEntity<String> deleteWorker(@RequestBody FormUploadIdDTO formUploadIdDTO) {
		FormUpload formToDelete = formService.findById(formUploadIdDTO.getFormId(), "id", FormUpload.class);
		int isDeleted = formService.delete(formToDelete);
		return new ResponseEntity<>(new Gson().toJson(isDeleted), OK);
	}
	
}
