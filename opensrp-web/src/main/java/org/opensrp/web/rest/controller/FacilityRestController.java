package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.opensrp.facility.dto.FacilityWorkerDTO;
import org.opensrp.facility.dto.WorkerIdDTO;
import org.opensrp.facility.entity.Facility;
import org.opensrp.facility.entity.FacilityWorker;
import org.opensrp.facility.util.FacilityHelperUtil;
import org.opensrp.facility.util.FacilityServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/facility")
@RestController
public class FacilityRestController {
	
	@Autowired
	private FacilityServiceFactory facilityServiceFactory;
	
	@Autowired
	private FacilityWorker facilityWorker;
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;
	
	@RequestMapping(value = "/saveWorker", method = RequestMethod.POST)
	public ResponseEntity<String> saveWorker(@RequestBody FacilityWorkerDTO facilityWorkerDTO) throws Exception {
	
		facilityWorker = facilityHelperUtil.convertFacilityWorkerDTO(facilityWorkerDTO);
		facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").save(facilityWorker);
		String message = "success";
		
		return new ResponseEntity<>(new Gson().toJson(message), OK);
	}
	
	@RequestMapping(value = "/editWorker", method = RequestMethod.POST)
	public ResponseEntity<String> editWorker(
			@RequestBody FacilityWorkerDTO facilityWorkerDTO) throws Exception {
		System.out.println(facilityWorkerDTO.toString());
		int workerId = Integer.parseInt(facilityWorkerDTO.getWorkerId());
		FacilityWorker facilityWorker = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findById(workerId, "id", FacilityWorker.class);
		FacilityWorker editedFacilityWorker = facilityHelperUtil.convertFacilityWorkerDTO(facilityWorkerDTO);
		facilityWorker.setName(editedFacilityWorker.getName());
		facilityWorker.setIdentifier(editedFacilityWorker.getIdentifier());
		facilityWorker.setOrganization(editedFacilityWorker.getOrganization());
		facilityWorker.setFacilityWorkerType(editedFacilityWorker.getFacilityWorkerType());
		facilityWorker.setFacilityTrainings(editedFacilityWorker.getFacilityTrainings());
		facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").save(facilityWorker);
		String message = "success";
		
		return new ResponseEntity<>(new Gson().toJson(message), OK);
	}
	
	@RequestMapping(value = "/{id}/getWorkerList.html", method = RequestMethod.GET)
	public ResponseEntity<String> getWorkerList (ModelMap model, HttpSession session,
			@PathVariable("id") int id){
		
		Facility facility = facilityServiceFactory.getFacility("FacilityServiceImpl").findById(id, "id", Facility.class);
		Map<String, Object> facilityMap = new HashMap<String, Object>();
		facilityMap.put("facility", facility);
		List<FacilityWorker> facilityWorkerList = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findAllByKeys(facilityMap, FacilityWorker.class);
		
		return new ResponseEntity<>(new Gson().toJson(facilityWorkerList), OK);
       
	}
	
	@RequestMapping(value = "/deleteWorker", method = RequestMethod.POST)
	public ResponseEntity<String> deleteWorker (@RequestBody WorkerIdDTO workerIdDTO){
		System.out.println(workerIdDTO.getWorkerId());
		FacilityWorker facilityWorker = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").findById(workerIdDTO.getWorkerId(), "id", FacilityWorker.class);
		System.out.println(facilityWorker);
		boolean isDeleted = facilityServiceFactory.getFacility("FacilityWorkerServiceImpl").delete(facilityWorker);
		return new ResponseEntity<>(new Gson().toJson(isDeleted), OK);
	}
	
}
