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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;

@Service
public class MigrationService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(MigrationService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public MigrationService() {
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<String> getMigratedHousehold(JSONObject jo, String branchIn, String BranchOut) throws JSONException,
	    JsonProcessingException {
		Session session = getSessionFactory();
		
		List<String> householdList = new ArrayList<String>();
		
		String hql = "select * from report.get_migration_household_list('" + jo + "','{" + branchIn + "}','{" + BranchOut
		        + "}')";
		
		Query query = session.createSQLQuery(hql);
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
	
	public JSONObject drawMigratedInHouseholdDataTable(Integer draw, int total, List<String> datas) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", total);
		response.put("recordsFiltered", total);
		JSONArray array = new JSONArray();
		
		for (String string : datas) {
			JSONArray tableData = new JSONArray();
			JSONObject row = new JSONObject(string);
			tableData.put(row.get("migration_date"));
			tableData.put(row.get("member_name"));
			tableData.put(row.get("member_id_in"));
			tableData.put(row.get("number_of_member_in"));
			tableData.put(row.get("ss_in"));
			tableData.put(row.get("village_in"));
			tableData.put(row.get("village_in"));
			tableData.put(row.get("bout_name") + "-" + row.get("bout_code"));
			tableData.put(row.get("district_out"));
			tableData.put(row.get("status"));
			
			String view = "<div class='btn btn-primary' onclick='loadContent()'>Details </div>";
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
	
}
