package org.opensrp.acl.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.json.JSONException;
import org.opensrp.acl.entity.DuplicateMatchingCriteriaDefinition;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DuplicateRecordServiceImpl {
	
	private static final Logger logger = Logger.getLogger(LocationService.class);
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	public static Map<String, List<String>> mapViewNameMatchingCriteria = new HashMap<String, List<String>>();
	
	public static Map<String, List<String>> mapViewNameColumnList = new HashMap<String, List<String>>();
	
	public DuplicateRecordServiceImpl() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	public <T> int update(T t) throws JSONException {
		return 0;
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	public static Map<String, List<String>> getMapViewNameMatchingCriteria() {
		return mapViewNameMatchingCriteria;
	}
	
	public static Map<String, List<String>> getMapViewNameColumnNameList() {
		return mapViewNameColumnList;
	}
	
	//newly created
	private void setMapViewNameColumnNameList(String viewName) {
		List<String> criteriaList = fetchMatchingCriteriaForView(viewName);
		mapViewNameMatchingCriteria.put(viewName, criteriaList);
	}
	
	@Transactional
	public Map<String, List<String>> getMatchingCriteriaForAllViews() {
		if (mapViewNameMatchingCriteria.size() == 0) {
			List<String> viewNameList = getDistinctViewName();
			for (int i = 0; i < viewNameList.size(); i++) {
				String viewName = viewNameList.get(i);
				setMapViewNameColumnNameList(viewName);
				//two lines removed and created a new method
			}
		}
		System.out.println("matching criteria for all view >>>>> " + mapViewNameMatchingCriteria.toString());
		
		return mapViewNameMatchingCriteria;
		
	}
	
	// working here
	
	@Transactional
	public Map<String, List<String>> getCloumnNameListForAllViewsWithDuplicateRecord() {
		if (mapViewNameColumnList.size() == 0) {
			List<String> viewNameList = getDistinctViewName();
			for (int i = 0; i < viewNameList.size(); i++) {
				String viewName = viewNameList.get(i);
				List<String> columnNameList = getColumnNameListOfView("core", viewName);
				mapViewNameColumnList.put(viewName, columnNameList);
			}
		}
		System.out.println("cloumn name list for all view >>>>> " + mapViewNameColumnList.toString());
		
		return mapViewNameColumnList;
		
	}
	
	@Transactional
	public List<String> getDistinctViewName() {
		List<String> viewNameStringtList = new ArrayList<String>();
		String query = "SELECT DISTINCT(view_name) " + "FROM core.\"duplicate_matching_criteria_definition\"";
		viewNameStringtList = databaseServiceImpl.executeSelectQuery(query);
		System.out.println("Distinct viewName list >>>>> " + viewNameStringtList.toString());
		return viewNameStringtList;
	}
	
	@Transactional
	public List<String> getColumnNameListOfView(String schemaName, String viewName) {
		List<String> columnNameList = new ArrayList<String>();
		String query = " SELECT a.attname " + " FROM pg_attribute a " + " JOIN pg_class t on a.attrelid = t.oid "
		        + " JOIN pg_namespace s on t.relnamespace = s.oid " + " WHERE a.attnum > 0 " + " AND NOT a.attisdropped "
		        + " AND t.relname = '" + viewName + "' " + " AND s.nspname = '" + schemaName + "' " + " ORDER BY a.attnum";
		columnNameList = databaseServiceImpl.executeSelectQuery(query);
		System.out.println("columnNameList list >>>>> " + columnNameList.toString());
		return columnNameList;
	}
	
	@Transactional
	public List<String> fetchMatchingCriteriaForView(String viewName) {
		Map<String, Object> findBy = new HashMap<String, Object>();
		findBy.put("viewName", viewName);
		findBy.put("status", true);
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = databaseRepositoryImpl.findByKeys(findBy,
		    DuplicateMatchingCriteriaDefinition.class);
		if (duplicateMatchingCriteriaDefinition != null) {
			String matchingKeys = duplicateMatchingCriteriaDefinition.getMatchingKeys();
			List<String> criteriaList = new ArrayList<String>(Arrays.asList(matchingKeys.split(",")));
			return criteriaList;
		} else {
			return null;
		}
	}
	
	@Transactional
	public DuplicateMatchingCriteriaDefinition getDuplicateMatchingCriteriaDefinitionForView(String viewName) {
		Map<String, Object> findBy = new HashMap<String, Object>();
		findBy.put("viewName", viewName);
		findBy.put("status", true);
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = databaseRepositoryImpl.findByKeys(findBy,
		    DuplicateMatchingCriteriaDefinition.class);
		
		return duplicateMatchingCriteriaDefinition;
	}
	
	public String trimBrackets(String inputString) {
		String stringAfterTrimBrackets = "";
		stringAfterTrimBrackets = inputString.replace("[", "");
		stringAfterTrimBrackets = stringAfterTrimBrackets.replace("]", "");
		return stringAfterTrimBrackets;
		
	}
	
	@Transactional
	public void updateDuplicateMatchCriteriaForView(String id, String viewName, String criteriaString) {
		
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = getDuplicateMatchingCriteriaDefinitionForView(viewName);
		
		duplicateMatchingCriteriaDefinition.setMatchingKeys(criteriaString);
		
		long saveStatus = 0;
		try {
			saveStatus = save(duplicateMatchingCriteriaDefinition);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Updated in db??? >>>>> " + saveStatus);
		//fetch matching criteria from db and set to static map
		setMapViewNameColumnNameList(viewName);
		
	}
	
	@Transactional
	public void saveDuplicateMatchCriteriaForView(String viewName, List<String> criteriaList) {
		System.out.println("criteriaList >>>>> " + criteriaList.toString());
		
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = new DuplicateMatchingCriteriaDefinition();
		duplicateMatchingCriteriaDefinition.setViewName(viewName);
		String stringAfterTrimBrackets = trimBrackets(criteriaList.toString());
		duplicateMatchingCriteriaDefinition.setMatchingKeys(stringAfterTrimBrackets);
		duplicateMatchingCriteriaDefinition.setStatus(true);
		long saveStatus = 0;
		try {
			saveStatus = save(duplicateMatchingCriteriaDefinition);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("saved in db??? >>>>> " + saveStatus);
	}
	
	public String getQueryForDuplicateRecord(String viewName, List<String> criteriaList) {
		
		String selectString = "";
		for (int i = 0; i < criteriaList.size(); i++) {
			selectString += criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				selectString += " , ";
			}
		}
		System.out.println("selectString >>>>> " + selectString);
		
		String groupIdString = " DENSE_RANK() OVER (ORDER BY  ";
		for (int i = 0; i < criteriaList.size(); i++) {
			groupIdString += " A." + criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				groupIdString += " , ";
			}
		}
		groupIdString += ") AS groupId";
		System.out.println("groupIdString >>>>> " + groupIdString);
		
		String joinString = "";
		for (int i = 0; i < criteriaList.size(); i++) {
			joinString += " A." + criteriaList.get(i);
			joinString += " = ";
			joinString += " B." + criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				joinString += " AND ";
			}
		}
		System.out.println("joinString >>>>> " + joinString);
		
		String query = " SELECT A.* ," + groupIdString + " FROM core.\"" + viewName + "\" A " + " Join " + " (SELECT "
		        + selectString + " , count(*) " + " FROM core.\"" + viewName + "\" " + " group by " + selectString
		        + " having count(*) > 1) B " + " ON " + joinString + " order by " + selectString;
		return query;
		
	}
	
	@Transactional
	public void getDuplicateRecord(HttpSession session, String viewName) {
		System.out.println("viewName >>>>> " + viewName);
		List<Object[]> duplicateRecordList = null;
		
		Map<String, List<String>> mapViewNameMatchingCriteria = getMapViewNameMatchingCriteria();
		List<String> criteriaList = mapViewNameMatchingCriteria.get(viewName);
		
		if (criteriaList != null) {
			System.out.println("criteriaList >>>>> " + criteriaList.toString());
			String query = getQueryForDuplicateRecord(viewName, criteriaList);
			duplicateRecordList = databaseServiceImpl.executeSelectQuery(query);
		}
		session.setAttribute("duplicateRecordList", duplicateRecordList);
	}
	
	@Transactional
	public void getColumnNameList(HttpSession session, String viewName) {
		System.out.println("viewName >>>>> " + viewName);
		
		Map<String, List<String>> mapViewNameColumnNameList = getMapViewNameColumnNameList();
		List<String> columnNameList = mapViewNameColumnNameList.get(viewName);
		
		if (columnNameList != null) {
			System.out.println("columnNameList >>>>> " + columnNameList.toString());
		}
		session.setAttribute("columnNameList", columnNameList);
		
	}
	
}
