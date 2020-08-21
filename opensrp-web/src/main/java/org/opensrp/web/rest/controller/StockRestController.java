package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.util.UserColumn;
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
	
	@RequestMapping(value = "/in-list", method = RequestMethod.GET)
	public ResponseEntity<String> allPatientSchedule(HttpServletRequest request) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = UserColumn.valueOf("_" + orderColumn).getValue();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		String invoiceNumber = request.getParameter("invoiceNumber");
		String stockInId = request.getParameter("stockInId");
		int division = Integer.parseInt(request.getParameter("division"));
		int district = Integer.parseInt(request.getParameter("district"));
		int upazila = Integer.parseInt(request.getParameter("upazila"));
		int userId = Integer.parseInt(request.getParameter("userId"));
		
		List<InventoryDTO> stockInList = stockService.getStockInList(branchId, startDate, endDate, invoiceNumber, stockInId,
		    division, district, upazila, userId, length, start, orderColumn, orderDirection);
		
		int stockInListCount = stockService.getStockInListCount(branchId, startDate, endDate, invoiceNumber, stockInId,
		    division, district, upazila, userId);
		
		JSONObject response = stockService.getStockInListDataOfDataTable(draw, stockInListCount, stockInList);
		return new ResponseEntity<>(response.toString(), OK);
	}
}
