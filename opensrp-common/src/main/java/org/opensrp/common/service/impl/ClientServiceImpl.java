package org.opensrp.common.service.impl;

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
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.EntityProperties;
import org.opensrp.common.visualization.HighChart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientServiceImpl extends EntityProperties implements DatabaseService {

	private static final Logger logger = Logger.getLogger(ClientServiceImpl.class);

	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;

	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;

	@Autowired
	private OpenSRPClientServiceImpl openSRPClientServiceImpl;

	public ClientServiceImpl() {

	}


	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}

	@Transactional
	@Override
	public <T> int delete(T t) {
		return 0;
	}

	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}

	@SuppressWarnings("unchecked")
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return (List<T>) databaseRepositoryImpl.findAll(tableClass);
	}

	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}

	@Transactional
	@Override
	public <T> long update(T t) throws Exception {
		return databaseRepositoryImpl.update(t);
	}

	@Transactional
	public void getChildWeightList(HttpSession session,String id) throws JSONException{
		System.out.println("Child id :" + id);
		session.setAttribute("childId", id);

		List<Object[]> weightList;

		String weightQuery = "SELECT * FROM core.child_growth "
				+" WHERE base_entity_id = '"
				+id
				+"' " 
				+" ORDER BY event_date ASC";
		weightList = databaseServiceImpl.executeSelectQuery(weightQuery);

		//for line chart
		List<Object[]> weightForChart = new ArrayList<Object[]>();
		List<Object[]> growthForChart= new ArrayList<Object[]>();

		Iterator weightListIterator = weightList.iterator();
		int i=0;
		while (weightListIterator.hasNext()) {
			Object[] weightObject = (Object[]) weightListIterator.next();
			Object[] rowWeightData = new Object[2];
			Object[] rowGrowthData = new Object[2];
			Double weight = Double.parseDouble(String.valueOf(weightObject[13]));
			Double growth = Double.parseDouble(String.valueOf(weightObject[17]));
			growth /= 1000.00;
			/*System.out.println(weight);
			System.out.println(growth);*/
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

	@Transactional
	public void getMotherDetails(HttpSession session,String id){

		System.out.println("Mother id :" + id);
		session.setAttribute("motherId", id);

		List<Object> data;
		data = databaseServiceImpl.getDataFromViewByBEId("viewJsonDataConversionOfEvent","mother",id);
		session.setAttribute("eventList", data);

		List<Object> NWMRList = new ArrayList<Object>();
		List<Object> counsellingList = new ArrayList<Object>();
		List<Object> followUpList = new ArrayList<Object>();
		Iterator dataListIterator = data.iterator();
		while (dataListIterator.hasNext()) {
			Object[] eventObject = (Object[]) dataListIterator.next();

			String eventType = String.valueOf(eventObject[8]);
			//System.out.println(eventType);

			if(eventType.equals("New Woman Member Registration")){
				//System.out.println(eventObject);
				NWMRList.add(eventObject);
				//System.out.println(NWMRList);
			}else if(eventType.equals("Pregnant Woman Counselling") || eventType.equals("Lactating Woman Counselling")){
				counsellingList.add(eventObject);
			}else if(eventType.equals("Woman Member Follow Up")){
				followUpList.add(eventObject);
			}
		}

		session.setAttribute("NWMRList", NWMRList);
		session.setAttribute("counsellingList", counsellingList);
		session.setAttribute("followUpList", followUpList);
	}

	public void updateClientData(ClientEntity clientEntity, String baseEntityId)
			throws JSONException {
		List<Object> clientData = databaseServiceImpl.executeSelectQuery("select id, cast(json as character varying) from core.client " 
				+ " where json->>'baseEntityId' = '" + baseEntityId + "'");

		JSONObject jsonObject = new JSONObject();

		if (clientData != null) {
			Iterator dataListIterator = clientData.iterator();

			while (dataListIterator.hasNext()) {
				Object[] clientObject = (Object[]) dataListIterator.next();
				String jsonData = String.valueOf(clientObject[1]);

				JSONObject jsonFromClient = new JSONObject(jsonData);

				if(clientEntity.getFirstName() != null && !clientEntity.getFirstName().isEmpty()) {
					jsonFromClient.put("firstName", clientEntity.getFirstName());
				}
				if (clientEntity.getLastName() != null && !clientEntity.getLastName().isEmpty()) {
					jsonFromClient.put("lastName", clientEntity.getLastName());
				}
				if (clientEntity.getPhoneNumber() != null && !clientEntity.getPhoneNumber().isEmpty()) {
					jsonFromClient.getJSONObject("attributes").put("phoneNumber", clientEntity.getPhoneNumber());
				}
				if(clientEntity.getNid() != null && !clientEntity.getNid().isEmpty()) {
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
		System.out.println("entity properties: " + PROJECT_ENTITY);
		return PROJECT_ENTITY;
	}

	public String getWomanEntityName() {
		System.out.println("woman properties: " + WOMAN_ENTITY);
		return WOMAN_ENTITY;
	}
}

