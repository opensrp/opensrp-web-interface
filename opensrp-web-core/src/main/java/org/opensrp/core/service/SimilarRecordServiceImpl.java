package org.opensrp.core.service;

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
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.SimilarityMatchingCriteriaDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SimilarRecordServiceImpl implements DatabaseService {
	
	private static final Logger logger = Logger.getLogger(ClientService.class);
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	public static Map<String, List<String>> mapViewNameMatchingCriteria = new HashMap<String, List<String>>();
	
	public static Map<String, List<String>> mapViewNameColumnList = new HashMap<String, List<String>>();
	
	public SimilarRecordServiceImpl() {
		
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	@Override
	public <T> long update(T t) throws JSONException {
		return 0;
	}
	
	@Transactional
	@Override
	public <T> int delete(T t) {
		// return databaseRepositoryImpl.delete(t);
		return 0;
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	public static Map<String, List<String>> getMapViewNameMatchingCriteria() {
		return mapViewNameMatchingCriteria;
	}
	
	public static Map<String, List<String>> getMapViewNameColumnNameList() {
		return mapViewNameColumnList;
	}
	
	// newly created
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
				// two lines removed and created a new method
			}
		}
		
		return mapViewNameMatchingCriteria;
		
	}
	
	@Transactional
	public Map<String, List<String>> getCloumnNameListForAllViewsWithSimilarRecord() {
		if (mapViewNameColumnList.size() == 0) {
			List<String> viewNameList = getDistinctViewName();
			for (int i = 0; i < viewNameList.size(); i++) {
				String viewName = viewNameList.get(i);
				List<String> columnNameList = getColumnNameListOfView("core", viewName);
				mapViewNameColumnList.put(viewName, columnNameList);
			}
		}
		
		return mapViewNameColumnList;
		
	}
	
	@Transactional
	public List<String> getDistinctViewName() {
		List<String> viewNameStringtList = new ArrayList<String>();
		String query = "SELECT DISTINCT(view_name) " + "FROM core.\"duplicate_matching_criteria_definition\"";
		viewNameStringtList = databaseServiceImpl.executeSelectQuery(query);
		
		return viewNameStringtList;
	}
	
	@Transactional
	public List<String> getColumnNameListOfView(String schemaName, String viewName) {
		List<String> columnNameList = new ArrayList<String>();
		String query = " SELECT a.attname " + " FROM pg_attribute a " + " JOIN pg_class t on a.attrelid = t.oid "
		        + " JOIN pg_namespace s on t.relnamespace = s.oid " + " WHERE a.attnum > 0 " + " AND NOT a.attisdropped "
		        + " AND t.relname = '" + viewName + "' " + " AND s.nspname = '" + schemaName + "' " + " ORDER BY a.attnum";
		columnNameList = databaseServiceImpl.executeSelectQuery(query);
		
		return columnNameList;
	}
	
	@Transactional
	public List<String> fetchMatchingCriteriaForView(String viewName) {
		Map<String, Object> findBy = new HashMap<String, Object>();
		findBy.put("viewName", viewName);
		findBy.put("status", true);
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = databaseRepositoryImpl.findByKeys(
		    findBy, SimilarityMatchingCriteriaDefinition.class);
		if (similarityMatchingCriteriaDefinition != null) {
			String matchingKeys = similarityMatchingCriteriaDefinition.getMatchingKeys();
			List<String> criteriaList = new ArrayList<String>(Arrays.asList(matchingKeys.split(",")));
			return criteriaList;
		} else {
			return null;
		}
	}
	
	@Transactional
	public SimilarityMatchingCriteriaDefinition getSimilarityMatchingCriteriaDefinitionForView(String viewName) {
		Map<String, Object> findBy = new HashMap<String, Object>();
		findBy.put("viewName", viewName);
		findBy.put("status", true);
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = databaseRepositoryImpl.findByKeys(
		    findBy, SimilarityMatchingCriteriaDefinition.class);
		// added to resolve null pointer exception
		if (similarityMatchingCriteriaDefinition == null) {
			similarityMatchingCriteriaDefinition = new SimilarityMatchingCriteriaDefinition();
		}
		
		return similarityMatchingCriteriaDefinition;
	}
	
	public String trimBrackets(String inputString) {
		String stringAfterTrimBrackets = "";
		stringAfterTrimBrackets = inputString.replace("[", "");
		stringAfterTrimBrackets = stringAfterTrimBrackets.replace("]", "");
		return stringAfterTrimBrackets;
		
	}
	
	@Transactional
	public void updateSimilarityMatchCriteriaForView(String id, String viewName, String criteriaString) {
		
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = getSimilarityMatchingCriteriaDefinitionForView(viewName);
		
		similarityMatchingCriteriaDefinition.setMatchingKeys(criteriaString);
		
		long saveStatus = 0;
		try {
			saveStatus = save(similarityMatchingCriteriaDefinition);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// fetch matching criteria from db and set to static map
		setMapViewNameColumnNameList(viewName);
		
	}
	
	@Transactional
	public void saveSimilarityMatchCriteriaForView(String viewName, List<String> criteriaList) {
		
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = new SimilarityMatchingCriteriaDefinition();
		similarityMatchingCriteriaDefinition.setViewName(viewName);
		String stringAfterTrimBrackets = trimBrackets(criteriaList.toString());
		similarityMatchingCriteriaDefinition.setMatchingKeys(stringAfterTrimBrackets);
		similarityMatchingCriteriaDefinition.setStatus(true);
		long saveStatus = 0;
		try {
			saveStatus = save(similarityMatchingCriteriaDefinition);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String getQueryForSimilarRecord(String viewName, List<String> criteriaList) {
		
		String selectString = "";
		for (int i = 0; i < criteriaList.size(); i++) {
			selectString += criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				selectString += " , ";
			}
		}
		
		String groupIdString = " DENSE_RANK() OVER (ORDER BY  ";
		for (int i = 0; i < criteriaList.size(); i++) {
			groupIdString += " A." + criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				groupIdString += " , ";
			}
		}
		groupIdString += ") AS groupId";
		
		String joinString = "";
		for (int i = 0; i < criteriaList.size(); i++) {
			joinString += " A." + criteriaList.get(i);
			joinString += " = ";
			joinString += " B." + criteriaList.get(i);
			if (i != criteriaList.size() - 1) {
				joinString += " AND ";
			}
		}
		
		String query = " SELECT A.* ," + groupIdString + " FROM core.\"" + viewName + "\" A " + " Join " + " (SELECT "
		        + selectString + " , count(*) " + " FROM core.\"" + viewName + "\" " + " group by " + selectString
		        + " having count(*) > 1) B " + " ON " + joinString + " order by " + selectString;
		
		return query;
		
	}
	
	@Transactional
	public void getSimilarRecord(HttpSession session, String viewName) {
		
		List<Object[]> similarRecordList = null;
		
		Map<String, List<String>> mapViewNameMatchingCriteria = getMapViewNameMatchingCriteria();
		List<String> criteriaList = mapViewNameMatchingCriteria.get(viewName);
		
		if (criteriaList != null) {
			String query = getQueryForSimilarRecord(viewName, criteriaList);
			similarRecordList = databaseServiceImpl.executeSelectQuery(query);
		}
		session.setAttribute("similarRecordList", similarRecordList);
	}
	
	@Transactional
	public void getColumnNameList(HttpSession session, String viewName) {
		Map<String, List<String>> mapViewNameColumnNameList = getMapViewNameColumnNameList();
		List<String> columnNameList = mapViewNameColumnNameList.get(viewName);
		
		session.setAttribute("columnNameList", columnNameList);
		
	}
	
}
