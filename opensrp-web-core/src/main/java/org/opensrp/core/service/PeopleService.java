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
import org.opensrp.common.dto.ClientCommonDTO;
import org.opensrp.common.dto.ClientListDTO;
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
	
	public ClientCommonDTO getHouseholdData(String search, String location, int branchId, int length, int start,
	                                        String orderColumn, String orderDirection) {
		List<ClientListDTO> households = new ArrayList<ClientListDTO>();
		for (int i = 0; i < length; i++) {
			
			ClientListDTO clientDTO = new ClientListDTO();
			clientDTO.setBranchCode("BR-1" + 1);
			clientDTO.setBranchName("BRANCH Name" + i);
			clientDTO.setContact("091234");
			clientDTO.setHouseholdHead("hh:" + i);
			clientDTO.setId(i);
			clientDTO.setBaseEntityId("baseEntityId" + i);
			clientDTO.setLastVisitDate("2020-9-03");
			clientDTO.setNumberOfMember(111 + i);
			clientDTO.setRegistrationDate("2020-02-20");
			clientDTO.setVillage("villa:" + i);
			clientDTO.setHouseholdId("HH:" + i);
			households.add(clientDTO);
		}
		ClientCommonDTO clientDetailsDTO = new ClientCommonDTO();
		clientDetailsDTO.setClientDTO(households);
		clientDetailsDTO.setTotalCount(100);
		return clientDetailsDTO;
	}
	
	public ClientCommonDTO getMemberData(String baseEntityId, String search, String location, int branchId, int length,
	                                     int start, String orderColumn, String orderDirection) {
		List<ClientListDTO> members = new ArrayList<ClientListDTO>();
		for (int i = 0; i < length; i++) {
			
			ClientListDTO clientDTO = new ClientListDTO();
			clientDTO.setBranchCode("BR-1" + 1);
			clientDTO.setBranchName("BRANCH Name" + i);
			clientDTO.setContact("091234");
			clientDTO.setMemberId("memberId" + i);
			clientDTO.setMemberName("memberName" + i);
			clientDTO.setId(i);
			clientDTO.setBaseEntityId("baseEntityId" + i);
			clientDTO.setGender("gender" + i);
			clientDTO.setRelationWithHousehold("realtion" + i);
			clientDTO.setAge("age" + i);
			clientDTO.setMemberType("memberType" + i);
			clientDTO.setVillage("villa:" + i);
			clientDTO.setHouseholdId("HH:" + i);
			members.add(clientDTO);
		}
		ClientCommonDTO clientDetailsDTO = new ClientCommonDTO();
		clientDetailsDTO.setClientDTO(members);
		clientDetailsDTO.setTotalCount(100);
		return clientDetailsDTO;
	}
	
	public JSONObject drawHouseholdDataTable(Integer draw, int total, ClientCommonDTO dtos) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", dtos.getTotalCount());
		response.put("recordsFiltered", dtos.getTotalCount());
		JSONArray array = new JSONArray();
		for (ClientListDTO dto : dtos.getClientDTO()) {
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
			        + dto.getBaseEntityId() + "/" + dto.getId() + ".html" + "\">Details</a> </div>";
			tableData.put(view);
			array.put(tableData);
		}
		response.put("data", array);
		return response;
	}
	
	public JSONObject drawMemberDataTable(Integer draw, int total, ClientCommonDTO dtos) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", dtos.getTotalCount());
		response.put("recordsFiltered", dtos.getTotalCount());
		JSONArray array = new JSONArray();
		for (ClientListDTO dto : dtos.getClientDTO()) {
			JSONArray tableData = new JSONArray();
			tableData.put(dto.getMemberName());
			tableData.put(dto.getMemberId());
			tableData.put(dto.getHouseholdId());
			tableData.put(dto.getRelationWithHousehold());
			tableData.put(dto.getAge());
			tableData.put(dto.getGender());
			tableData.put(dto.getMemberType());
			tableData.put(dto.getVillage());
			tableData.put(dto.getBranchAndCode());
			String view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"member-details/"
			        + dto.getBaseEntityId() + "/" + dto.getId() + ".html" + "\">Details</a> </div>";
			tableData.put(view);
			array.put(tableData);
		}
		response.put("data", array);
		return response;
	}
	
}
