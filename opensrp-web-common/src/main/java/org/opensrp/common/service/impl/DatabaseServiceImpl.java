package org.opensrp.common.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.dom4j.Branch;
import org.hibernate.Criteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.entity.ExportEntity;
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.common.util.SearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DatabaseServiceImpl implements DatabaseService {
	
	private static final Logger logger = Logger.getLogger(DatabaseServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	public DatabaseServiceImpl() {
		
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

	@Override
	public <T> List<T> getHouseholdListByMHV(String username, HttpSession session) {
		return databaseRepositoryImpl.getDataByMHV(username);
	}

	@Override
	public <T> List<T> getMemberListByHousehold(String householdBaseId, String mhvId) {
		return databaseRepositoryImpl.getMemberListByHousehold(householdBaseId, mhvId);
	}

	@Override
	public <T> T getMemberByHealthId(String healthId) {
		return databaseRepositoryImpl.getMemberByHealthId(healthId);
	}

	@Override
	public <T> T getMemberByBaseEntityId(String baseEntityId) {
		return databaseRepositoryImpl.getMemberByBaseEntityId(baseEntityId);
	}

	@Override
	public <T> List<T> getMemberListByCC(String ccName) {
		return databaseRepositoryImpl.getMemberListByCC(ccName);
	}

	@Override
	public <T> List<T> getUpazilaList() {
		return databaseRepositoryImpl.getUpazilaList();
	}

	@Override
	public <T> List<T> getCCListByUpazila(SearchBuilder searchBuilder) {
		return databaseRepositoryImpl.getCCListByUpazila(searchBuilder);
	}

	@Override
	public List<ReportDTO> getMHVListFilterWise(SearchBuilder searchBuilder) {
		String filterString = SearchCriteria.getFilterString(searchBuilder);
		return databaseRepositoryImpl.getMHVListFilterWise(filterString);
	}

	@Override
	public List<Object[]> getAllSks(List<Object[]> branches) {
		return databaseRepositoryImpl.getAllSK(branches);
	}

	@Override
	public List<Object[]> getSKByBranch(String branchIds) {
		return databaseRepositoryImpl.getSKByBranch(branchIds);
	}

	@Override
	public List<Object[]> getClientInformation() {
		return databaseRepositoryImpl.getClientInformation();
	}

	@Override
	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs, Integer pageNumber) {
		return databaseRepositoryImpl.getClientInfoFilter(startTime, endTime, formName, sk, allSKs, pageNumber);
	}


	@Override
	public Integer getClientInfoFilterCount(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs) {
		return databaseRepositoryImpl.getClientInfoFilterCount(startTime, endTime, formName, sk, allSKs);
	}

	@Override
	public List<Object[]> getByCreator(String username, String formName) {
		return databaseRepositoryImpl.getExportByCreator(username, formName);
	}


	@Override
	public List<Object[]> getHouseHoldReports(String startDate, String endDate, String address_value,String searched_value,List<Object[]> allSKs, Integer searchedValueId) {
		// TODO Auto-generated method stub
		return databaseRepositoryImpl.getHouseHoldReports(startDate, endDate, address_value, searched_value,allSKs, searchedValueId);
	}

	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		return (T) databaseRepositoryImpl.findAllByKeys(fielaValues, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findAllByKey(String value, String fieldName, Class<?> className) {
		return (T) databaseRepositoryImpl.findAllByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAllFormNames(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	@Transactional
	public List<Object[]> getQueryData(String provider, String caseId, String scheduleName, String userType, String sqlQuery) {
		return null;
	}
	
	@Transactional
	public <T> List<T> getDataFromSQLFunction(String procedureName, String params) {
		return null;
	}
	
	@Transactional
	@Override
	public <T> long update(T t) throws Exception {
		
		return databaseRepositoryImpl.update(t);
	}

	public <T> long update(List<T> t) throws Exception {

		return 0;
	}

	@Transactional
	public <T> List<T> search(SearchBuilder searchBuilder, Integer offset, Integer maxResults, Class<?> entityClassName) {
		return databaseRepositoryImpl.search(searchBuilder, offset, maxResults, entityClassName);
	}
	
	@Transactional
	public int countBySearch(SearchBuilder searchBuilder, Class<?> entityClassName) {
		return databaseRepositoryImpl.countBySearch(searchBuilder, entityClassName);
	}
	
	public static Criteria createCriteriaCondition(SearchBuilder searchBuilder, Criteria criteria) {
		if (searchBuilder.getDivision() != null && !searchBuilder.getDivision().isEmpty()) {
			
			criteria.add(Restrictions.eq("division", searchBuilder.getDivision().toUpperCase()));
		}
		if (searchBuilder.getDistrict() != null && !searchBuilder.getDistrict().isEmpty()) {
			
			criteria.add(Restrictions.eq("district", searchBuilder.getDistrict().toUpperCase()));
		}
		if (searchBuilder.getUpazila() != null && !searchBuilder.getUpazila().isEmpty()) {
			
			criteria.add(Restrictions.eq("upazila", searchBuilder.getUpazila()));
		}
		if (searchBuilder.getUnion() != null && !searchBuilder.getUnion().isEmpty()) {
			criteria.add(Restrictions.eq("union", searchBuilder.getUnion()));
		}
		if (searchBuilder.getWard() != null && !searchBuilder.getWard().isEmpty()) {
			criteria.add(Restrictions.eq("ward", searchBuilder.getWard()));
		}
		if (searchBuilder.getMauzapara() != null && !searchBuilder.getMauzapara().isEmpty()) {
			criteria.add(Restrictions.eq("mauzaPara", searchBuilder.getMauzapara()));
		}
		if (searchBuilder.getSubunit() != null && !searchBuilder.getSubunit().isEmpty()) {
			criteria.add(Restrictions.eq("subunit", searchBuilder.getSubunit()));
		}
		if (searchBuilder.getProvider() != null && !searchBuilder.getProvider().isEmpty()) {
			criteria.add(Restrictions.eq("provider", searchBuilder.getProvider()));
		}
		if (searchBuilder.getName() != null && !searchBuilder.getName().isEmpty()) {
			criteria.add(Restrictions.ilike("name", searchBuilder.getName(), MatchMode.ANYWHERE));
		}
		if (searchBuilder.getUserName() != null && !searchBuilder.getUserName().isEmpty()) {
			criteria.add(Restrictions.ilike("username", searchBuilder.getUserName(), MatchMode.ANYWHERE));
		}
		
		return criteria;
	}
	
	@Transactional
	public <T> List<T> getDataFromViewByBEId(String viewName, String entityType, String baseEntityId) {
		return databaseRepositoryImpl.getDataFromViewByBEId(viewName, entityType, baseEntityId);
	}
	
	/**
	 * <p>
	 * returns data list.
	 * <p>
	 * 
	 * @param searchBuilder is search option list.
	 * @param offset is number of offset.
	 * @param maxResults is returned maximum number of data.
	 * @param viewName is name of target view.
	 * @param entityType is name of entity type.
	 * @return List<T>.
	 */
	@Transactional
	public <T> List<T> getDataFromView(SearchBuilder searchBuilder, Integer offset, Integer maxResults, String viewName,
	                                   String entityType) {
		String orderBy = "id";
		return databaseRepositoryImpl.getDataFromView(searchBuilder, offset, maxResults, viewName, entityType, orderBy);
	}
	
	/**
	 * <p>
	 * get data count with or without search parameter's.
	 * </p>
	 * 
	 * @param searchBuilder is search option list.
	 * @param viewName is name of target view.
	 * @param entityType is name of entity type.
	 * @return dataCount.
	 */
	@Transactional
	public int getViewDataSize(SearchBuilder searchBuilder, String viewName, String entityType) {
		return databaseRepositoryImpl.getViewDataSize(searchBuilder, viewName, entityType);
	}
	
	@Transactional
	public <T> List<T> executeSelectQuery(String sqlQuery) {
		return databaseRepositoryImpl.executeSelectQuery(sqlQuery);
	}
	
	@Transactional
	public List<Object[]> refreshView(SearchBuilder searchBuilder) {
		String funcQuery = "SELECT * FROM core.refresh_all_materialized_views()";
		return databaseRepositoryImpl.executeSelectQuery(funcQuery);
	}

	@Transactional
	public List<Object[]> actionParser(SearchBuilder searchBuilder) {
		String funcQuery = "SELECT * FROM report.action_parser()";
		return databaseRepositoryImpl.executeSelectQuery(funcQuery);
	}

	@Transactional
	public <T> List<T> getReportData(SearchBuilder searchBuilder) {
		return databaseRepositoryImpl.getReportData(searchBuilder, "test2_report");
	}

}
