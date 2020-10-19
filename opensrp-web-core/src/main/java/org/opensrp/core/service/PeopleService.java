/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ClientCommonDTO;
import org.opensrp.common.dto.ClientListDTO;
import org.opensrp.common.dto.ServiceCommonDTO;
import org.opensrp.common.dto.WebNotificationCommonDTO;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PeopleService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(PeopleService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public PeopleService() {
		
	}
	
	static final List<String> householdColumnList;
	static {
		householdColumnList = new ArrayList<String>();
		householdColumnList.add("householdId");
		householdColumnList.add("householdHead");
		householdColumnList.add("numberOfMember");
		householdColumnList.add("registrationDate");
		householdColumnList.add("lastVisitDate");
		householdColumnList.add("village");
		householdColumnList.add("branchAndCode");
		householdColumnList.add("contact");
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public JSONObject getHouseholdData(String search, String location, int branchId, int length, int start,
	                                   String orderColumn, String orderDirection) throws JSONException,
	    JsonProcessingException {
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
		
		Session session = getSessionFactory();
		List<WebNotificationCommonDTO> dtos = new ArrayList<>();
		JSONObject jo = new JSONObject();
		jo.put("branch_id", 2);
		jo.put("division", "DHAKA");
		jo.put("offset", 0);
		jo.put("limit", 10);
		
		List<ClientListDTO> householdList = new ArrayList<ClientListDTO>();
		
		String hql = "select  id,hh_id householdId,hh_name householdHead,member_count numberOfMember,reg_date registrationDate"
		        + " ,last_visit_date lastVisitDate,village,branch_name branchName,branch_code branchCode,"
		        + " contact contact,base_entity_id baseEntityId from report.get_household_list('" + jo + "')";
		
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("householdId", StandardBasicTypes.STRING).addScalar("householdHead", StandardBasicTypes.STRING)
		        .addScalar("numberOfMember", StandardBasicTypes.INTEGER)
		        .addScalar("registrationDate", StandardBasicTypes.STRING)
		        .addScalar("lastVisitDate", StandardBasicTypes.STRING).addScalar("village", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
		        .addScalar("contact", StandardBasicTypes.STRING).addScalar("baseEntityId", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(ClientListDTO.class));
		householdList = query.list();
		ClientCommonDTO householdDetailsDTO = new ClientCommonDTO();
		householdDetailsDTO.setClientDTO(householdList);
		householdDetailsDTO.setTotalCount(100);
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		String json = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(householdDetailsDTO);
		//System.out.println(json);
		
		JSONObject jsonObject = new JSONObject(json + "");
		//System.err.println("" + jsonObject);
		
		//JSONObject obj = new JSONObject(json);
		/*householdList.stream().forEach(household -> {
			
			for (int i = 0; i < household.length; i++) {
				System.err.println("JJ:" + household[i]);
			}
			System.err.println("---------------------------");
		});*/
		
		return jsonObject;
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
	
	public JSONObject drawHouseholdDataTable(Integer draw, int total, JSONObject datas) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", datas.getInt("totalCount"));
		response.put("recordsFiltered", datas.getInt("totalCount"));
		JSONArray array = new JSONArray();
		JSONArray dataList = datas.getJSONArray("clientDTO");
		
		for (int i = 0; i < dataList.length(); i++) {
			JSONObject row = dataList.getJSONObject(i);
			
			String baseEntityId = row.getString("baseEntityId");
			String id = row.getString("id") + "";
			JSONArray tableData = new JSONArray();
			
			for (String key : householdColumnList) {
				tableData.put(row.get(key));
			}
			
			String view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"household-details/"
			        + baseEntityId + "/" + id + ".html" + "\">Details</a> </div>";
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
	
	public JSONObject getHouseholdInfor(String baseEntityId) throws JSONException {
		String response = "{\"form_name\":\"HH_Registration\",\"data\":[{\"value\":2,\"key\":\"id\"},{\"value\":\"json roy\",\"key\":\"name\"},{\"value\":\"naNDID GR\",\"key\":\"village\"},{\"value\":\"23453453535\",\"key\":\"householdId\"},{\"value\":\"VO\",\"key\":\"khnanaType\"},{\"value\":\"Farmer\",\"key\":\"occupation\"},{\"value\":\"2345\",\"key\":\"montlyIncome\"},{\"value\":\"TV\",\"key\":\"asset\"}]}";
		JSONObject responseObj = new JSONObject(response);
		return responseObj;
	}
	
	public List<ServiceCommonDTO> getServiceList(String baseEntityId) {
		List<ServiceCommonDTO> dtos = new ArrayList<ServiceCommonDTO>();
		for (int i = 0; i < 50; i++) {
			
			ServiceCommonDTO dto = new ServiceCommonDTO();
			dto.setDate("2020-03-20");
			dto.setId(i);
			dto.setFormName("HH_Visit" + 1);
			dtos.add(dto);
		}
		
		return dtos;
	}
	
	public JSONObject getServiceDetails(String formName, long id) throws JSONException {
		String response = "{\"form_name\":\"HH_Registration\",\"data\":[{\"value\":2,\"key\":\"id\"},{\"value\":\"json roy\",\"key\":\"name\"},{\"value\":\"naNDID GR\",\"key\":\"village\"},{\"value\":\"23453453535\",\"key\":\"householdId\"},{\"value\":\"VO\",\"key\":\"khnanaType\"},{\"value\":\"Farmer\",\"key\":\"occupation\"},{\"value\":\"2345\",\"key\":\"montlyIncome\"},{\"value\":\"TV\",\"key\":\"asset\"}]}";
		JSONObject responseObj = new JSONObject(response);
		return responseObj;
	}
}
