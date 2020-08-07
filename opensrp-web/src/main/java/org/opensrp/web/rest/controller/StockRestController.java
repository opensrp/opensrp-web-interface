package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONObject;
import org.opensrp.core.dto.StockDTO;
import org.opensrp.core.entity.Stock;
import org.opensrp.core.mapper.StockMapper;
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
	
	@Autowired
	private StockMapper stockMapper;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody StockDTO dto) throws Exception {
		Stock stock = stockService.findById(dto.getId(), "id", Stock.class);
		JSONObject response = new JSONObject();
		System.err.println(dto);
		try {
			if (stock != null) {
				stock = stockMapper.map(dto, stock);
			} else {
				stock = new Stock();
				stock = stockMapper.map(dto, stock);
			}
			System.out.println(stock.toString());
			if (stock != null) {
				
				stockService.save(stock);
			}
			response.put("status", "SUCCESS");
			response.put("msg", "you have successfully added.");
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
