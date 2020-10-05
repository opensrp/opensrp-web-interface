/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ClientDTO;
import org.opensrp.common.dto.ClientDetailsDTO;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PeopleService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(PeopleService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public PeopleService() {
		
	}
	
	public ClientDetailsDTO getHouseholdData(String location, int branchId, int length, int start, String orderColumn,
	                                         String orderDirection) {
		List<ClientDTO> households = new ArrayList<ClientDTO>();
		for (int i = 0; i < length; i++) {
			
			ClientDTO clientDTO = new ClientDTO();
			clientDTO.setBranchCode("BR-1" + 1);
			clientDTO.setBranchName("BRANCH Name" + i);
			clientDTO.setContact("091234");
			clientDTO.setHouseholdHead("hh:" + i);
			clientDTO.setId(i);
			clientDTO.setLastVisitDate("2020-9-03");
			clientDTO.setNumberOfMember(111 + i);
			clientDTO.setRegistrationDate("2020-02-20");
			clientDTO.setVillage("villa:" + i);
			clientDTO.setHouseholdId("HH:" + i);
			households.add(clientDTO);
		}
		ClientDetailsDTO clientDetailsDTO = new ClientDetailsDTO();
		clientDetailsDTO.setClientDTO(households);
		clientDetailsDTO.setTotalCount(100);
		return clientDetailsDTO;
	}
	
	public JSONObject drawHouseholdDataTable(Integer draw, int total, ClientDetailsDTO dtos) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", dtos.getTotalCount());
		response.put("recordsFiltered", dtos.getTotalCount());
		JSONArray array = new JSONArray();
		for (ClientDTO dto : dtos.getClientDTO()) {
			JSONArray tableData = new JSONArray();
			tableData.put(dto.getHouseholdId());
			tableData.put(dto.getHouseholdHead());
			tableData.put(dto.getNumberOfMember());
			tableData.put(dto.getRegistrationDate());
			tableData.put(dto.getLastVisitDate());
			tableData.put(dto.getVillage());
			tableData.put(dto.getBranchAndCode());
			tableData.put(dto.getContact());
			String view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"household-details/"
			        + dto.getId() + ".html" + "\">Details</a> </div>";
			tableData.put(view);
			array.put(tableData);
		}
		response.put("data", array);
		return response;
	}
	
}
