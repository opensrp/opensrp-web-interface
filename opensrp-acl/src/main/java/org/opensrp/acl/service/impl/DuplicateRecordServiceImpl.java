
package org.opensrp.acl.service.impl;

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
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DuplicateRecordServiceImpl implements AclService {
	
	private static final Logger logger = Logger.getLogger(LocationServiceImpl.class);
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	
	public DuplicateRecordServiceImpl() {
		
	}

	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	@Override
	public <T> int update(T t) throws JSONException {
		return 0;
	}
	
	@Transactional
	@Override
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
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
	
	//for saving criteria to startup
	public static Map<String,List<String>> mapViewNameMatchingCriteria = 
			new HashMap<String, List<String>>();
	
	public static Map<String,List<String>> getMapViewNameMatchingCriteria(){
		return mapViewNameMatchingCriteria;
	}
	
	@Transactional
	public  Map<String,List<String>>getMatchingCriteriaForAllViews(){
		if(mapViewNameMatchingCriteria.size()== 0){
			List<String> viewNameList = getDistinctViewName();
			for(int i=0; i<viewNameList.size();i++){
				String viewName = viewNameList.get(i);
				List<String> criteriaList = fetchMatchingCriteriaForView(viewName);
				mapViewNameMatchingCriteria.put(viewName, criteriaList);
			}
		}
		System.out.println("matching criteria for all view >>>>> " 
		+ mapViewNameMatchingCriteria.toString());
		
		return mapViewNameMatchingCriteria;
		
	}
	
	@Transactional
	public List<String> getDistinctViewName(){
		List<String> viewNameStringtList = new ArrayList<String>();
		String query = "SELECT DISTINCT(view_name) "
				+"FROM core.\"duplicate_matching_criteria_definition\"";
		viewNameStringtList = databaseServiceImpl.executeSelectQuery(query);
		System.out.println("Distinct viewName list >>>>> " + viewNameStringtList.toString());
		return viewNameStringtList;
	}
	
	//END: for saving criteria to startup
	
	@Transactional
	public List<String> fetchMatchingCriteriaForView(String viewName){
		Map<String, Object> findBy = new HashMap<String, Object>();
		findBy.put("viewName", viewName);
		findBy.put("status", true);
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = 
				databaseRepositoryImpl.findByKeys(findBy,
						DuplicateMatchingCriteriaDefinition.class);
		if(duplicateMatchingCriteriaDefinition != null){
		String matchingKeys = duplicateMatchingCriteriaDefinition.getMatchingKeys();
		List<String> criteriaList = new ArrayList<String>(Arrays.asList(matchingKeys.split(",")));
		return criteriaList;
		}else{
			return null;
		}
	}
	
	
	public String trimBrackets(String inputString){
		String stringAfterTrimBrackets = "";
		stringAfterTrimBrackets = inputString.replace("[","");
		stringAfterTrimBrackets = stringAfterTrimBrackets.replace("]","");
		return stringAfterTrimBrackets;
		
	}
	
	@Transactional
	public void saveDuplicateMatchCriteriaForView(String viewName, List<String> criteriaList){
		System.out.println("criteriaList >>>>> " + criteriaList.toString());
		
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = 
				new DuplicateMatchingCriteriaDefinition();
		duplicateMatchingCriteriaDefinition.setViewName(viewName);
		String stringAfterTrimBrackets = trimBrackets(criteriaList.toString());
		duplicateMatchingCriteriaDefinition.setMatchingKeys(stringAfterTrimBrackets);
		duplicateMatchingCriteriaDefinition.setStatus(true);
		long saveStatus = 0;
		try {
			saveStatus = save(duplicateMatchingCriteriaDefinition);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("saved in db??? >>>>> " + saveStatus);
	}
	
	public String getQueryForDuplicateRecord(String viewName, List<String> criteriaList){
		
		String selectString = "";
		for(int i=0; i<criteriaList.size(); i++){
			selectString += criteriaList.get(i);
			if (i != criteriaList.size() -1){
				selectString += " , ";
			}
		}
		System.out.println("selectString >>>>> " + selectString);
		
		String groupIdString = " DENSE_RANK() OVER (ORDER BY  ";
		for(int i=0; i<criteriaList.size(); i++){
			groupIdString += " A."+criteriaList.get(i);
			if (i != criteriaList.size() -1){
				groupIdString += " , ";
			}
		}
		groupIdString += ") AS groupId" ;
		System.out.println("groupIdString >>>>> " + groupIdString);
		
		String joinString = "";
		for(int i=0; i<criteriaList.size(); i++){
			joinString += " A."+criteriaList.get(i);
			joinString += " = ";
			joinString += " B."+criteriaList.get(i);
			if (i != criteriaList.size() -1){
				joinString += " AND ";
			}
		}
		System.out.println("joinString >>>>> " + joinString);
		
		String query = " SELECT A.* ,"
					+groupIdString
					+" FROM core.\""+viewName+"\" A "
					+" Join "
					+" (SELECT "
					+selectString
					+" , count(*) "
					+" FROM core.\""+viewName+"\" "
					+" group by "
					+selectString
					+" having count(*) > 1) B "
					+" ON "
					+joinString
					+" order by "
					+selectString ;
		return query;
		
	}
	
	
	@Transactional
	public void getDuplicateRecord(HttpSession session,String viewName) throws JSONException{
		System.out.println("viewName >>>>> " + viewName);
		List<Object[]> duplicateRecordList = null;
		
		Map<String,List<String>> mapViewNameMatchingCriteria = getMapViewNameMatchingCriteria();
		List<String> criteriaList = mapViewNameMatchingCriteria.get(viewName);
		System.out.println("criteriaList >>>>> " + criteriaList.toString());
		
		if(criteriaList != null){
			String query = getQueryForDuplicateRecord(viewName, criteriaList);
			duplicateRecordList = databaseServiceImpl.executeSelectQuery(query);
		}
		session.setAttribute("duplicateRecordList", duplicateRecordList);
	}
	
	
	
}
