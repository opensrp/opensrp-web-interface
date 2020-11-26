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
import org.opensrp.common.dto.ClientListDTO;
import org.opensrp.common.dto.ServiceCommonDTO;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;

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
	public List<ClientListDTO> getHouseholdData(JSONObject jo) throws JSONException, JsonProcessingException {
		Session session = getSessionFactory();
		
		List<ClientListDTO> householdList = new ArrayList<ClientListDTO>();
		
		String hql = "select  id,vid,hh_id householdId,hh_name householdHead,member_count numberOfMember,reg_date registrationDate"
		        + " ,last_visit_date lastVisitDate,village,branch_name branchName,branch_code branchCode,"
		        + " contact contact,base_entity_id baseEntityId from report.get_household_list('" + jo + "')";
		
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("vid", StandardBasicTypes.LONG).addScalar("householdId", StandardBasicTypes.STRING)
		        .addScalar("householdHead", StandardBasicTypes.STRING)
		        .addScalar("numberOfMember", StandardBasicTypes.INTEGER)
		        .addScalar("registrationDate", StandardBasicTypes.STRING)
		        .addScalar("lastVisitDate", StandardBasicTypes.STRING).addScalar("village", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
		        .addScalar("contact", StandardBasicTypes.STRING).addScalar("baseEntityId", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(ClientListDTO.class));
		householdList = query.list();
		
		//JSONObject obj = new JSONObject(json);
		/*householdList.stream().forEach(household -> {
			
			for (int i = 0; i < household.length; i++) {
				System.err.println("JJ:" + household[i]);
			}
			System.err.println("----------------------jsonObject---");
		});*/
		
		return householdList;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<ClientListDTO> getMemberList(JSONObject jo, Integer startAge, Integer endAge) {
		Session session = getSessionFactory();
		
		List<ClientListDTO> householdList = new ArrayList<ClientListDTO>();
		
		String hql = "select  id,member_name memberName,member_id memberId,relation_with_hh relationWithHousehold,member_age age,age_month ageMonth,age_day ageDay,dob dob,gender gender"
		        + " ,status status,village,branch_name branchName,branch_code branchCode,"
		        + " contact contact,base_entity_id baseEntityId,relational_id  relationalId from report.member_list('"
		        + jo
		        + "',:startAge,:endAge)";
		
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("memberName", StandardBasicTypes.STRING).addScalar("memberId", StandardBasicTypes.STRING)
		        .addScalar("relationWithHousehold", StandardBasicTypes.STRING).addScalar("age", StandardBasicTypes.STRING)
		        .addScalar("ageMonth", StandardBasicTypes.INTEGER).addScalar("ageDay", StandardBasicTypes.INTEGER)
		        .addScalar("dob", StandardBasicTypes.STRING).addScalar("gender", StandardBasicTypes.STRING)
		        .addScalar("status", StandardBasicTypes.STRING).addScalar("village", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
		        .addScalar("contact", StandardBasicTypes.STRING).addScalar("baseEntityId", StandardBasicTypes.STRING)
		        .addScalar("relationalId", StandardBasicTypes.STRING).setInteger("startAge", startAge)
		        .setInteger("endAge", endAge).setResultTransformer(new AliasToBeanResultTransformer(ClientListDTO.class));
		householdList = query.list();
		return householdList;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<ClientListDTO> getHHServiceList(String baseEntityId) {
		Session session = getSessionFactory();
		
		List<ClientListDTO> householdList = new ArrayList<ClientListDTO>();
		
		String hql = "select  _id,_form_submission_id formSubmissionId,_event_date eventDate,_service_name serviceName,_table_name tableName "
		        + "  from report.household_activity_list(:baseEntityId)";
		
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("formSubmissionId", StandardBasicTypes.STRING).addScalar("eventDate", StandardBasicTypes.STRING)
		        .addScalar("serviceName", StandardBasicTypes.STRING).addScalar("tableName", StandardBasicTypes.STRING)
		        .setString("baseEntityId", baseEntityId)
		        .setResultTransformer(new AliasToBeanResultTransformer(ClientListDTO.class));
		householdList = query.list();
		return householdList;
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
	
	/*public JSONObject drawMemberDataTable(Integer draw, int total, List<ClientListDTO> dtos) throws JSONException {
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
	}*/
	
	@SuppressWarnings("unchecked")
	@Transactional
	public JSONObject getHouseholdInfor(String baseEntityId, Long id, String tableName) throws JSONException {
		String response = "{\"form_name\":\"HH_Registration\",\"data\":[{\"value\":2,\"key\":\"id\"},{\"value\":\"json roy\",\"key\":\"name\"},{\"value\":\"naNDID GR\",\"key\":\"village\"},{\"value\":\"23453453535\",\"key\":\"householdId\"},{\"value\":\"VO\",\"key\":\"khnanaType\"},{\"value\":\"Farmer\",\"key\":\"occupation\"},{\"value\":\"2345\",\"key\":\"montlyIncome\"},{\"value\":\"TV\",\"key\":\"asset\"}]}";
		JSONObject responseObj = new JSONObject(response);
		Session session = getSessionFactory();
		String hql = "select  *  from report.get_details_data(:id,:tableName)";
		
		Query query = session.createSQLQuery(hql).setLong("id", id).setString("tableName", tableName);
		String rs = (String) query.uniqueResult();
		
		JSONObject jsonObject = new JSONObject(rs);
		JSONArray data = new JSONArray();
		JSONObject object = new JSONObject();
		jsonObject.keys().forEachRemaining(key -> {
			JSONObject filedValue = new JSONObject();
			Object value = jsonObject.opt(key + "");
			try {
				filedValue.putOpt("value", value);
				filedValue.putOpt("key", key);
				data.put(filedValue);
			}
			catch (Exception e) {
				
			}
			
			System.err.println(key + ":" + value);
		});
		object.put("form_name", tableName);
		object.put("data", data);
		System.err.println(rs);
		return object;
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
