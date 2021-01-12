package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.RequisitionQueryDto;
import org.opensrp.common.util.UserColumn;
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
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<String> allPatient(HttpServletRequest request) throws JSONException {
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String name = request.getParameter("search[value]");
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		int branchId = Integer.valueOf(request.getParameter("branch"));
		int divisionId = Integer.valueOf(request.getParameter("division"));
		int districtId = Integer.valueOf(request.getParameter("district"));
		int upazilla = Integer.valueOf(request.getParameter("upazila"));
		int requisitor = Integer.valueOf(request.getParameter("requisitor"));
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		Long requisitionCount = requisitionService.getCountOfRequisiton(branchId, startDate, endDate, divisionId,
		    districtId, upazilla, requisitor);
		List<RequisitionQueryDto> requisitionList = requisitionService.getRequisitonList(branchId, startDate, endDate,
		    divisionId, districtId, upazilla, requisitor, start, length);
		JSONObject response = requisitionService.getRequisitionDataOfDataTable(draw, requisitionCount, requisitionList,
		    start);
		return new ResponseEntity<>(response.toString(), OK);
	}
}
