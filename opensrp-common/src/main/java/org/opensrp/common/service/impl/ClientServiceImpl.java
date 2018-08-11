package org.opensrp.common.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.visualization.HighChart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientServiceImpl implements DatabaseService {
	
	private static final Logger logger = Logger.getLogger(ClientServiceImpl.class);
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
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
							+" ORDER BY last_event_date ASC";
		weightList = databaseServiceImpl.executeSelectQuery(weightQuery);
		
		//for line chart
		List<Object[]> weightForChart = new ArrayList<Object[]>();
		List<Object[]> growthForChart= new ArrayList<Object[]>();
		Object[] rowData = new Object[2];
		Iterator weightListIterator = weightList.iterator();
		int i=0;
		while (weightListIterator.hasNext()) {
			Object[] weightObject = (Object[]) weightListIterator.next();
			String weight = String.valueOf(weightObject[13]);
			String growth = String.valueOf(weightObject[17]);
			rowData[0] = i;
			rowData[1] = weight;
			weightForChart.add(rowData);
			
			rowData[0] = i;
			rowData[1] = growth;
			growthForChart.add(rowData);
		}
		JSONArray lineChartWeightData = HighChart.getLineChartData(weightForChart, "Weight");
		JSONArray lineChartGrowthData = HighChart.getLineChartData(growthForChart, "Growth");
		
		session.setAttribute("weightList", weightList);
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
	
	
}

