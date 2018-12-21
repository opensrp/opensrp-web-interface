package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.entity.ClientEntity;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.service.impl.OpenSRPClientServiceImpl;
import org.opensrp.common.util.EntityProperties;
import org.opensrp.common.visualization.HighChart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientService extends EntityProperties {
	
	private static final Logger logger = Logger.getLogger(ClientService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private OpenSRPClientServiceImpl openSRPClientServiceImpl;
	
	public ClientService() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	public <T> int delete(T t) {
		return 0;
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return (List<T>) repository.findAll(tableClass);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> long update(T t) throws Exception {
		return repository.update(t);
	}
	
	/**
	 * Get child's weight and growth related data and set them to session. The data will be used to
	 * show growth related graphs and charts for any individual child.
	 * <p>
	 * <ol>
	 * <li>Set childId to session</li>
	 * <li>Get weightList by childId</li>
	 * <li>Separate weight and growth related data in two different lists</li>
	 * <li>Format growth-list and weight-list according to highChart's requirement and save them in
	 * json arrays</li>
	 * <li>Set weightList and json arrays for growth and weight to session</li>
	 * </ol>
	 * </p>
	 * 
	 * @param session HttpSession
	 * @param childId base-entity-id of child
	 * @return
	 */
	@Transactional
	public void getChildWeightList(HttpSession session, String childId) throws JSONException {
		session.setAttribute("childId", childId);
		
		List<Object[]> weightList;
		
		String weightQuery = "SELECT * FROM core.child_growth " + " WHERE base_entity_id = '" + childId + "' "
		        + " ORDER BY event_date ASC";
		weightList = repository.executeSelectQuery(weightQuery);
		
		// for line chart
		List<Object[]> weightForChart = new ArrayList<Object[]>();
		List<Object[]> growthForChart = new ArrayList<Object[]>();
		
		Iterator weightListIterator = weightList.iterator();
		int i = 0;
		while (weightListIterator.hasNext()) {
			Object[] weightObject = (Object[]) weightListIterator.next();
			Object[] rowWeightData = new Object[2];
			Object[] rowGrowthData = new Object[2];
			Double weight = Double.parseDouble(String.valueOf(weightObject[13]));
			Double growth = Double.parseDouble(String.valueOf(weightObject[17]));
			growth /= 1000.00;
			rowWeightData[0] = i;
			rowWeightData[1] = weight;
			weightForChart.add(rowWeightData);
			
			rowGrowthData[0] = i;
			rowGrowthData[1] = growth;
			growthForChart.add(rowGrowthData);
		}
		JSONArray lineChartWeightData = HighChart.getLineChartData(weightForChart, "Weight");
		JSONArray lineChartGrowthData = HighChart.getLineChartData(growthForChart, "Growth");
		
		session.setAttribute("weightList", weightList);
		session.setAttribute("lineChartWeightData", lineChartWeightData);
		session.setAttribute("lineChartGrowthData", lineChartGrowthData);
	}
	
	/**
	 * Get all events of a mother, separate the events in different lists and set the event-lists to
	 * session. These lists will be used to show pregnancy , follow-up and counselling related info
	 * of individual mother.
	 * <p>
	 * <ol>
	 * <li>Get all events of a mother by id</li>
	 * <li>Set the event-list to session</li>
	 * <li>Create three different list of events from that event-list</li>
	 * <li>Set those lists to session</li>
	 * </ol>
	 * </p>
	 * 
	 * @param session HttpSession
	 * @param motherId base-entity-id of mother
	 * @return
	 */
	@Transactional
	public void getMotherDetails(HttpSession session, String motherId) {
		session.setAttribute("motherId", motherId);
		
		List<Object> data;
		data = repository.getDataFromViewByBEId("viewJsonDataConversionOfEvent", "mother", motherId);
		session.setAttribute("eventList", data);
		
		List<Object> NWMRList = new ArrayList<Object>();
		List<Object> counsellingList = new ArrayList<Object>();
		List<Object> followUpList = new ArrayList<Object>();
		Iterator dataListIterator = data.iterator();
		while (dataListIterator.hasNext()) {
			Object[] eventObject = (Object[]) dataListIterator.next();
			
			String eventType = String.valueOf(eventObject[8]);
			
			if (eventType.equals("New Woman Member Registration")) {
				NWMRList.add(eventObject);
			} else if (eventType.equals("Pregnant Woman Counselling") || eventType.equals("Lactating Woman Counselling")) {
				counsellingList.add(eventObject);
			} else if (eventType.equals("Woman Member Follow Up")) {
				followUpList.add(eventObject);
			}
		}
		
		session.setAttribute("NWMRList", NWMRList);
		session.setAttribute("counsellingList", counsellingList);
		session.setAttribute("followUpList", followUpList);
	}
	
	@Transactional
	public void getMemberDetails(HttpSession session, String memberId) throws JSONException {
		session.setAttribute("memberId", memberId);
		List<Object> data;
		data = repository.getDataFromViewByBEId("viewJsonDataConversionOfEvent", "ec_member", memberId);
		session.setAttribute("eventList", data);
	}
	
	public void updateClientData(ClientEntity clientEntity, String baseEntityId) throws JSONException {
		List<Object> clientData = repository
		        .executeSelectQuery("select id, cast(json as character varying) from core.client "
		                + " where json->>'baseEntityId' = '" + baseEntityId + "'");
		
		JSONObject jsonObject = new JSONObject();
		
		if (clientData != null) {
			Iterator dataListIterator = clientData.iterator();
			
			while (dataListIterator.hasNext()) {
				Object[] clientObject = (Object[]) dataListIterator.next();
				String jsonData = String.valueOf(clientObject[1]);
				
				JSONObject jsonFromClient = new JSONObject(jsonData);
				
				if (clientEntity.getFirstName() != null && !clientEntity.getFirstName().isEmpty()) {
					jsonFromClient.put("firstName", clientEntity.getFirstName());
				}
				if (clientEntity.getLastName() != null && !clientEntity.getLastName().isEmpty()) {
					jsonFromClient.put("lastName", clientEntity.getLastName());
				}
				if (clientEntity.getPhoneNumber() != null && !clientEntity.getPhoneNumber().isEmpty()) {
					jsonFromClient.getJSONObject("attributes").put("phoneNumber", clientEntity.getPhoneNumber());
				}
				if (clientEntity.getNid() != null && !clientEntity.getNid().isEmpty()) {
					jsonFromClient.getJSONObject("attributes").put("nationalId", clientEntity.getNid());
				}
				if (clientEntity.getSpouseName() != null && !clientEntity.getSpouseName().isEmpty()) {
					jsonFromClient.getJSONObject("attributes").put("spouseName", clientEntity.getSpouseName());
				}
				
				JSONArray jsonArrayForClient = new JSONArray();
				jsonArrayForClient.put(jsonFromClient);
				jsonObject.put("clients", jsonArrayForClient);
			}
		}
		
		openSRPClientServiceImpl.update(jsonObject);
	}
	
	public String getHouseholdEntityNamePrefix() {
		return PROJECT_ENTITY;
	}
	
	public String getWomanEntityName() {
		return WOMAN_ENTITY;
	}
}
