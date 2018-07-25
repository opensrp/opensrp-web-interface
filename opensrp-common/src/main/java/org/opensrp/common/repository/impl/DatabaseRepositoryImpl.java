package org.opensrp.common.repository.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DatabaseRepositoryImpl implements DatabaseRepository {
	
	private static final Logger logger = Logger.getLogger(DatabaseRepositoryImpl.class);
	
	@Autowired
	private SessionFactory sessionFactory;
	
	public DatabaseRepositoryImpl() {
		
	}
	
	@Override
	public <T> long save(T t) throws Exception {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		long returnValue = -1;
		try {
			tx = session.beginTransaction();
			session.saveOrUpdate(t);
			
			logger.info("saved successfully: " + t.getClass().getName());
			returnValue = 1;
			if (!tx.wasCommitted())
				tx.commit();
		}
		catch (HibernateException e) {
			returnValue = -1;
			tx.rollback();
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
			
		}
		return returnValue;
	}
	
	@Override
	public <T> int update(T t) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		int returnValue = -1;
		try {
			tx = session.beginTransaction();
			session.saveOrUpdate(t);
			logger.info("updated successfully");
			if (!tx.wasCommitted())
				tx.commit();
			returnValue = 1;
		}
		catch (HibernateException e) {
			returnValue = -1;
			tx.rollback();
			e.printStackTrace();
		}
		finally {
			session.close();
		}
		return returnValue;
	}
	
	@Override
	public <T> boolean delete(T t) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		boolean returnValue = false;
		try {
			tx = session.beginTransaction();
			logger.info("deleting: " + t.getClass().getName());
			session.delete(t);
			if (!tx.wasCommitted())
				tx.commit();
			returnValue = true;
		}
		catch (HibernateException e) {
			returnValue = false;
			tx.rollback();
		}
		finally {
			session.close();
			
		}
		return returnValue;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, id));
		List<T> result = criteria.list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	public <T> T findByKeys(Map<String, Object> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
		}
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	public <T> T findLastByKey(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
		}
		criteria.addOrder(Order.desc(orderByFieldName));
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
		}
		
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}
	
	public <T> List<T> findAllByKeysWithALlMatches(boolean isProvider, Map<String, String> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, String> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.ilike(entry.getKey(), entry.getValue(), MatchMode.ANYWHERE));
		}
		if (isProvider) {
			criteria.add(Restrictions.eq("provider", true));
		}
		
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}
	
	@SuppressWarnings("unchecked")
	public boolean findByUserName(String value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		List<Object> result = criteria.list();
		session.close();
		return (result.size() > 0 ? true : false);
	}
	
	public <T> boolean entityExists(int id, T value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		criteria.add(Restrictions.ne("id", id));
		List<Object> result = criteria.list();
		session.close();
		return (result.size() > 0 ? true : false);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <T> List<T> findAll(String tableClass) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Query query = session.createQuery("from " + tableClass + " t order by t.id desc");
			//query.setFirstResult(0);
			//query.setMaxResults(10);
			result = (List<T>) query.list();
		}
		catch (Exception e) {
			logger.error("error:" + e.getMessage());
		}
		finally {
			session.close();
		}
		
		return (List<T>) result;
	}
	
	public <T> List<T> findAllByKey(String value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}
	
	@SuppressWarnings("unchecked")
	public <T> List<T> list(int result, int offsetreal, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(entityClassName);
		criteria.setFirstResult(offsetreal);
		criteria.setMaxResults(result);
		List<T> products = null;
		try {
			products = (List<T>) criteria.list();
			session.close();
		}
		catch (Exception e) {
			
		}
		
		return products;
	}
	
	@SuppressWarnings("unchecked")
	public List<Object[]> executeSelectQuery(String sqlQuery, String paramName, int paramValue) {
		Session session = sessionFactory.openSession();
		List<Object[]> results = null;
		try {
			SQLQuery query = session.createSQLQuery(sqlQuery);
			query.setParameter(paramName, paramValue);
			results = query.list();
			session.close();
		}
		catch (Exception e) {
			session.close();
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public List<Object[]> executeSelectQuery(String sqlQuery) {
		Session session = sessionFactory.openSession();
		List<Object[]> results = null;
		try {
			SQLQuery query = session.createSQLQuery(sqlQuery);
			results = query.list();
			session.close();
		}
		catch (Exception e) {
			session.close();
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public List<Object[]> executeSelectQuery(String provider, String caseId, String scheduleName, String userType,
	                                         String sqlQuery) {
		
		SQLQuery query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery);
		
		if (!provider.isEmpty()) {
			query.setParameter("provider", provider);
		}
		if (!caseId.isEmpty()) {
			query.setParameter("case_id", caseId);
		}
		if (!scheduleName.isEmpty()) {
			query.setParameter("scheduleName", scheduleName);
		}
		if (!userType.isEmpty()) {
			query.setParameter("userType", userType);
		}
		List<Object[]> results = query.list();
		
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public <T> List<T> search(SearchBuilder searchBuilder, int result, int offsetreal, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(entityClassName);
		
		criteria = DatabaseServiceImpl.createCriteriaCondition(searchBuilder, criteria);
		criteria.setFirstResult(offsetreal);
		criteria.setMaxResults(result);
		criteria.addOrder(Order.desc("created"));
		criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		
		List<T> data = new ArrayList<T>();
		try {
			data = (List<T>) criteria.list();
			session.close();
		}
		catch (Exception e) {
			logger.error(e);
		}
		
		return data;
	}
	
	public int countBySearch(SearchBuilder searchBuilder, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		int count = 0;
		Criteria criteria = session.createCriteria(entityClassName);
		criteria = DatabaseServiceImpl.createCriteriaCondition(searchBuilder, criteria);
		try {
			count = criteria.list().size();
			session.close();
		}
		catch (Exception e) {
			session.close();
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromViewByBEId(String viewName, String entityType, String baseEntityId) {
		Session session = sessionFactory.openSession();
		List<T> viewData = null;
		try {
			String hql = "SELECT * FROM core.\"" +  viewName + "\" "
		    + " where entity_type = '" + entityType + "'"
		    + " and base_entity_id = '" + baseEntityId + "'";
			
			Query query = session.createSQLQuery(hql);
			viewData = query.list();
			logger.info("data fetched successfully from " + viewName + ", data size: "
			        + viewData.size());
			session.close();
		}
		catch (Exception e) {
			logger.error("Data fetch from " + viewName + " error:" + e.getMessage());
		}
		return viewData;
	}
	
	
	
	
	
	
	
	
	
	


	/**
	 * @param searchBuilder fdff maxRange -1 means setMaxResults does not consider. offsetreal -1
	 *            means setFirstResult does not consider.
	 */

	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromView(SearchBuilder searchBuilder, int maxRange, int offsetreal, String viewName,
	                                   String entityType) {
		Session session = sessionFactory.openSession();
		List<T> viewData = null;
		try {
			String hql = "SELECT * FROM core.\"" + viewName + "\" " + " where entity_type = '" + entityType + "'";
			
			hql = setCondition(searchBuilder, hql);
			
			Query query = session.createSQLQuery(hql);
			if (offsetreal != -1) {
				query.setFirstResult(offsetreal);
			}
			if (maxRange != -1) {
				query.setMaxResults(maxRange);
			}
			
			viewData = query.list();
			logger.info("data fetched successfully from " + viewName + ", data size: " + viewData.size());
			session.close();
		}
		catch (Exception e) {
			logger.error("Data fetch from " + viewName + " error:" + e.getMessage());
		}
		return viewData;
	}
	
	public int getViewDataSize(SearchBuilder searchBuilder, String viewName, String entityType) {
		Session session = sessionFactory.openSession();
		int count = 0;
		try {
			String hql = "SELECT * FROM core.\"" + viewName + "\"" + " where entity_type = '" + entityType + "'";
			
			hql = setCondition(searchBuilder, hql);
			
			Query query = session.createSQLQuery(hql);
			count = query.list().size();
			session.close();
		}
		catch (Exception e) {
			logger.error("Data fetch from " + viewName + " error:" + e.getMessage());
		}
		
		return count;
	}
	
	private String setCondition(SearchBuilder searchBuilder, String hql) {
		if (searchBuilder.getDivision() != null && !searchBuilder.getDivision().isEmpty()) {
			hql = hql + " and division = '" + searchBuilder.getDivision() + "'";
		}
		if (searchBuilder.getDistrict() != null && !searchBuilder.getDistrict().isEmpty()) {
			hql = hql + " and district = '" + searchBuilder.getDistrict() + "'";
		}
		if (searchBuilder.getUpazila() != null && !searchBuilder.getUpazila().isEmpty()) {
			hql = hql + " and upazila = '" + searchBuilder.getUpazila() + "'";
		}
		/*if(searchBuilder.getUnion() != null && !searchBuilder.getUnion().isEmpty()) {
			hql = hql + " and union = '" + searchBuilder.getUnion() + "'";
		}*/
		if (searchBuilder.getWard() != null && !searchBuilder.getWard().isEmpty()) {
			hql = hql + " and ward = '" + searchBuilder.getWard() + "'";
		}
		if (searchBuilder.getSubunit() != null && !searchBuilder.getSubunit().isEmpty()) {
			hql = hql + " and subunit = '" + searchBuilder.getSubunit() + "'";
		}
		if (searchBuilder.getMauzapara() != null && !searchBuilder.getMauzapara().isEmpty()) {
			hql = hql + " and mauzapara = '" + searchBuilder.getMauzapara() + "'";
		}
		if (searchBuilder.getServerVersion() != -1) {
			hql = hql + " and server_version > '" + searchBuilder.getServerVersion() + "'";
		}
		return hql;
	}
	
	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromSQLFunction(SearchBuilder searchBuilder, Query query, Session session) {
		
		List<T> aggregatedList = null;
		try {
			aggregatedList = query.list();
			logger.info("Report Data fetched successfully from , aggregatedList size: " + aggregatedList.size());
			session.close();
		}
		catch (Exception e) {
			logger.error("Data fetch from  error:" + e.getMessage());
		}
		return aggregatedList;
	}
	
}
