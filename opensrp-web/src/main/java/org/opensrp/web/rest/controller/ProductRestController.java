package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import org.json.JSONObject;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Product;
import org.opensrp.core.mapper.ProductMapper;
import org.opensrp.core.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RequestMapping("rest/api/v1/product")
@RestController
public class ProductRestController {
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private ProductMapper productMapper;
	
	@RequestMapping(value = "/save-update", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> newPatient(@RequestBody ProductDTO dto) throws Exception {
		Product product = productService.findById(dto.getId(), "id", Product.class);
		JSONObject response = new JSONObject();
		try {
			if (product != null) {
				product = productMapper.map(dto, product);
			} else {
				product = new Product();
				product = productMapper.map(dto, product);
			}
			
			if (product != null) {
				
				productService.save(product);
			}
			response.put("status", "SUCCESS");
			response.put("msg", "you have successfully added the product");
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
