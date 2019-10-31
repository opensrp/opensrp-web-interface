package org.opensrp.common.repository.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.google.gson.JsonObject;
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
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.dto.LocationTreeDTO;
import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;
import javax.xml.transform.Transformer;

/**
 * <p>
 * Concrete implementation of a DatabaseRepository.<br/>
 * The main contract here is the communication with hibernate repository through
 * {@link #sessionFactory}.currently Various types of query and database operation are supported
 * both entity class and view, but has a lot of chance to improve it and its gets maturity day by
 * day.So its only perform Database operation related action.<br/>
 * </p>
 * <b>Exposes One interface:</b>
 * <ul>
 * <li>{@link DatabaseRepository} to the application</li>
 * </ul>
 * <br/>
 * This class is not thread-safe.
 * 
 * @author proshanto
 * @author nursat
 * @author prince
 * @version 0.1.0
 * @since 2018-05-30
 */
@Repository
public class DatabaseRepositoryImpl implements DatabaseRepository {
	
	private static final Logger logger = Logger.getLogger(DatabaseRepositoryImpl.class);
	
	@Autowired
	private SessionFactory sessionFactory;
	
	public DatabaseRepositoryImpl() {
		
	}
	
	/**
	 * Save data object to persistent through Hibernate {@link #sessionFactory}
	 * 
	 * @param t is data object.
	 * @exception Exception
	 * @return 1 for success and -1 for failure.
	 */
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
			logger.error(e);
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
			
		}
		return returnValue;
	}

	@Override
	public <T> long saveAll(List<T> t) throws Exception {
		System.out.println("SAVE ALL");
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		long returnValue = -1;
		try {
			tx = session.beginTransaction();
			System.out.println("Save.... "+ t.size());
			for (int i = 0; i < t.size(); i++) {
				System.out.println(""+t.toString());
				session.saveOrUpdate(t.get(i));
			}
			logger.info("saved successfully: " + t.getClass().getName());
			returnValue = 1;
			if (!tx.wasCommitted())
				tx.commit();
		}
		catch (HibernateException e) {
			returnValue = -1;
			tx.rollback();
			logger.error(e);
			e.printStackTrace();
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();

		}
		return returnValue;
	}
	
	/**
	 * Update data object to persistent through Hibernate {@link #sessionFactory}
	 * 
	 * @param t is data object.
	 * @exception Exception
	 * @return 1 for success and -1 for failure.
	 */
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
			logger.error(e);
		}
		finally {
			session.close();
		}
		return returnValue;
	}
	
	/**
	 * Delete data object from persistent through Hibernate {@link #sessionFactory}
	 * 
	 * @param t is data object.
	 * @exception Exception
	 * @return true for success and false for failure.
	 */
	
	@Override
	public <T> boolean delete(T t) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		System.out.println("DELETE METHOD A ASHCHHE");
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
			logger.error(e);
		}
		finally {
			session.close();
		}
		return returnValue;
	}
	
	/**
	 * <p>
	 * {@link #findById(int, String, Class)} fetch entity by {@link #sessionFactory}. This is a
	 * common method for all Entity class, so it works for any entity class.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> findById(12,id,User.class).
	 * 
	 * @param id is unique id of a entity (primary key of a table and type should be int).
	 * @param fieldName is name of primary key of a entity class.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
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

	public <T> T findByForeignKey(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		String hql = "from "+className+" where " + fieldName + " = :id";
		List<T> result = session.createQuery(hql).setInteger("id", id).list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}

	public <T> List<T> findAllByForeignKey(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		String hql = "from "+className+" where " + fieldName + " = :id";
		List<T> result = session.createQuery(hql).setInteger("id", id).list();
		session.close();
		return (result.size() > 0 ? result : null);
	}
	
	/**
	 * <p>
	 * {@link #findByKey(String, String, Class)} fetch entity by {@link #sessionFactory}. This is a
	 * common method for all Entity class, so it works for any entity class.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> findByKey("john", "name", User.class).
	 * 
	 * @param fieldName is field or property name of Entity class and type should be String.
	 * @param value is given value type String.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
	
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
	
	/**
	 * <p>
	 * {@link #findByKeys(Map, Class)} fetch entity by {@link #sessionFactory}. This is a common
	 * method for all Entity class, so it works for any entity class.its returns first record of the
	 * Record set.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); findByKeys(params, User.class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
	
	@Override
	public <T> T findByKeys(Map<String, Object> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		@SuppressWarnings("unchecked")
		List<T> result = null;
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
				criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
			}
			result = criteria.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	/**
	 * <p>
	 * {@link #findLastByKey(Map, String, Class)} fetch entity by {@link #sessionFactory}. This is a
	 * common method for all Entity class, so it works for any entity class.its returns last record
	 * of the Record set.its only support descending order.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); findLastByKey(params,"id", User.class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param orderByFieldName is name of field where ordering is applied.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
	@Override
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
	
	/**
	 * <p>
	 * {@link #findLastByKeyLessThanDateConditionOneField(Map, Date, String, String, Class)} fetch
	 * entity by {@link #sessionFactory}. This is a common method for all Entity class, so it works
	 * for any entity class.its returns last record of the Record set.its only support descending
	 * order.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); findLastByKeyLessThanDateConditionOneField(params,
	 * 2018-10-15,"created","id,User,class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param fieldDateValue is condition date value.
	 * @param field is name of fieldDate where fieldDateValue is imposed.
	 * @param orderByFieldName is name of field where ordering is applied.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
	@Override
	public <T> T findLastByKeyLessThanDateConditionOneField(Map<String, Object> fielaValues, Date fieldDateValue,
	                                                        String field, String orderByFieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
		}
		criteria.add(Restrictions.lt(field, fieldDateValue));
		criteria.addOrder(Order.desc(orderByFieldName));
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}
	
	/**
	 * <p>
	 * {@link #findAllByKeys(Map, Class)} fetch entity by {@link #sessionFactory}. This is a common
	 * method for all Entity class, so it works for any entity class.its returns all records of the
	 * result.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); findAllByKeys(params, User.class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of Entity object or null.
	 */
	
	@Override
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
			criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		}
		
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}
	
	/**
	 * <p>
	 * {@link #findAllByKeysWithALlMatches(boolean, Map, Class)} fetch entity by
	 * {@link #sessionFactory}. This is a common method for all Entity class, so it works for any
	 * entity class.its returns all records of the result.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); findAllByKeysWithALlMatches(false,params, User.class).
	 * 
	 * @param isProvider is a boolean value which only imposed for user Entity(if needs only
	 *            provider list form User list then use true otherwise false always).
	 * @param fielaValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of Entity object or null.
	 */

	
	@SuppressWarnings("unchecked")
	@Override
	public <T> List<T> findAllByKeysWithALlMatches(boolean isProvider, Map<String, String> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, String> entry : fielaValues.entrySet()) {
				criteria.add(Restrictions.ilike(entry.getKey(), entry.getValue(), MatchMode.ANYWHERE));
			}
			if (isProvider) {
				criteria.add(Restrictions.eq("provider", true));
			}
			result = criteria.list();
		}catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		if(result!= null){
			return (List<T>) (result.size() > 0 ? (List<T>) result : null);
		}
		
		return null;
	}
	
	/**
	 * <p>
	 * {@link #isExists(String, String, Class)} fetch entity by {@link #sessionFactory}. This is a
	 * common method for all Entity class, so it works for any entity class.its returns true or
	 * false depends on query result.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); isExists(params, User.class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return boolean value.
	 */
	@Override
	@SuppressWarnings("unchecked")
	public boolean isExists(Map<String, Object> fielaValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
			criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		}
		List<Object> result = criteria.list();
		session.close();
		return (result.size() > 0 ? true : false);
	}
	
	/**
	 * <p>
	 * {@link #entityExistsNotEualThisId(String, String, Class)} fetch entity by
	 * {@link #sessionFactory}. This is a common method for all Entity class, so it works for any
	 * entity class.This method is only purpose of data editing checked.Data updating time its
	 * requires to know any records exists with the sane name except this Entity.suppose userName is
	 * unique at updating time of user information same userName should gets update with same
	 * entity, it this scenario this method help us.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("parentId", parentId); isExists(params, User.class).
	 * 
	 * @param fielaValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return boolean value.
	 */
	
	@Override
	@SuppressWarnings("unchecked")
	public <T> boolean entityExistsNotEualThisId(int id, T value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		criteria.add(Restrictions.ne("id", id));
		List<Object> result = criteria.list();
		session.close();
		return (result.size() > 0 ? true : false);
	}
	
	/**
	 * <p>
	 * {@link #findAll(String)} fetch entity by {@link #sessionFactory}. This is a common method for
	 * RWA Query.List of all Objects.This method directly communicate with database by database
	 * table name.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> findAll("user").
	 * 
	 * @param tableClass is name of table name of database.
	 * @return List of Object or null.
	 */
	@SuppressWarnings("unchecked")
	@Override
	public <T> List<T> findAll(String tableClass) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Query query = session.createQuery("from " + tableClass + " t order by t.id desc");
			result = (List<T>) query.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return (List<T>) result;
	}
	
	/**
	 * <p>
	 * {@link #findAllByKey(String, String, Class)} fetch entity by {@link #sessionFactory}. This is
	 * a common method for all Entity class, so it works for any entity class.its returns all
	 * records of the result.If only one key is for condition then this method may be used but
	 * {@link #findAllByKeys(Map, Class)} also an alternative option.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> findAllByKey("john","userName", User.class).
	 * 
	 * @param value is search string.
	 * @param fieldName is field name.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of Entity object or null.
	 */
	@Override
	public <T> List<T> findAllByKey(String value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		@SuppressWarnings("unchecked")
		List<T> result = criteria.list();
		session.close();
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Object[]> executeSelectQuery(String sqlQuery, Map<String, Object> params) {
		Session session = sessionFactory.openSession();
		
		List<Object[]> results = null;
		try {
			SQLQuery query = session.createSQLQuery(sqlQuery);
			for (Map.Entry<String, Object> param : params.entrySet()) {
				query.setParameter(param.getKey(), param.getValue());
			}
			
			results = query.list();
			
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return results;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> executeSelectQuery(String sqlQuery) {
		Session session = sessionFactory.openSession();
		List<T> results = null;
		try {
			SQLQuery query = session.createSQLQuery(sqlQuery);
			results = query.list();
			
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return results;
	}
	
	/**
	 * <p>
	 * {@link #search(SearchBuilder, int, int, Class)} fetch entity by {@link #sessionFactory}. This
	 * is a common method for all Entity class, so it works for any entity class.Its returns number
	 * of records defined to the configuration (default 10).This method supports pagination with
	 * search option.
	 * </p>
	 * *
	 * <p>
	 * maxRange -1 means maxResult does not consider. offsetreal -1 means setFirstResult does not
	 * consider.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> SearchBuilder searchBuilder; searchBuilder.setDistrict("DHAKA");
	 * search(searchBuilder,1,1, User.class).
	 * 
	 * @param searchBuilder is object of search option.
	 * @param maxResult is total records returns
	 * @param offsetreal is starting position of query.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of object or null.
	 */
	
	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> search(SearchBuilder searchBuilder, int maxResult, int offsetreal, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(entityClassName);
		
		criteria = DatabaseServiceImpl.createCriteriaCondition(searchBuilder, criteria);
		
		if (offsetreal != -1) {
			criteria.setFirstResult(offsetreal);
		}
		if (maxResult != -1) {
			criteria.setMaxResults(maxResult);
		}
		criteria.addOrder(Order.desc("created"));
		criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		
		List<T> data = new ArrayList<T>();
		try {
			data = (List<T>) criteria.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return data;
	}
	
	/**
	 * <p>
	 * {@link #countBySearch(SearchBuilder, Class)} fetch entity by {@link #sessionFactory}. This is
	 * a common method for all Entity class, so it works for any entity class.its returns count of
	 * the result.This method supports search option.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> SearchBuilder searchBuilder; searchBuilder.setDistrict("DHAKA");
	 * search(searchBuilder, User.class).
	 * 
	 * @param searchBuilder is object of search option.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return total count.
	 */
	@Override
	public int countBySearch(SearchBuilder searchBuilder, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		int count = 0;
		Criteria criteria = session.createCriteria(entityClassName);
		criteria = DatabaseServiceImpl.createCriteriaCondition(searchBuilder, criteria);
		try {
			count = criteria.list().size();
			
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return count;
	}
	
	/**
	 * <p>
	 * {@link #getDataFromViewByBEId(String, String, String)} fetch entity by
	 * {@link #sessionFactory}. This is a common method for all View, so it works for any View.Its
	 * returns all records of the result.This method gets data by baseEntity ID.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> getDataFromViewByBEId("client","household",
	 * "112233-frtttt-huoie-345555").
	 * 
	 * @param viewName is name of View.
	 * @param entityType is name of ENtity Type Such as "child,member".
	 * @param baseEntityId is client unique id.
	 * @return List of Object or null.
	 */
	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromViewByBEId(String viewName, String entityType, String baseEntityId) {
		Session session = sessionFactory.openSession();
		List<T> viewData = null;
		try {
			String hql = "SELECT * FROM core.\"" + viewName + "\" " + " where entity_type = '" + entityType + "'"
			        + " and base_entity_id = '" + baseEntityId + "'";
			Query query = session.createSQLQuery(hql);
			viewData = query.list();
			logger.info("data fetched successfully from " + viewName + ", data size: " + viewData.size());
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return viewData;
	}
	
	/**
	 * <p>
	 * {@link #getDataFromView(SearchBuilder, int, int, String, String, String)} fetch entity by
	 * {@link #sessionFactory}.This is a common method for all View, so it works for any View.This
	 * method supports pagination with search option.
	 * <p>
	 * <p>
	 * maxRange -1 means setMaxResults does not consider. offsetreal -1 means setFirstResult does
	 * not consider.
	 * </p>
	 * 
	 * @param searchBuilder is search option list.
	 * @param offset is number of offset.
	 * @param maxRange is returned maximum number of data.
	 * @param viewName is name of target view.
	 * @param orderingBy is the order by condition of query.
	 * @param entityType is name of ENtity Type Such as "child,member".
	 * @return List<T>.
	 */
	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromView(SearchBuilder searchBuilder, int maxRange, int offsetreal, String viewName,
	                                   String entityType, String orderingBy) {
		Session session = sessionFactory.openSession();
		List<T> viewData = null;
		try {
			String hql = "SELECT * FROM core.\"" + viewName + "\" " + " where entity_type = '" + entityType + "'  ";
			
			hql = setViewCondition(searchBuilder, hql);
			if (!orderingBy.isEmpty()) {
				hql += " order by " + orderingBy + " asc";
			}
			Query query = session.createSQLQuery(hql);
			if (offsetreal != -1) {
				query.setFirstResult(offsetreal);
			}
			if (maxRange != -1) {
				query.setMaxResults(maxRange);
			}
			
			viewData = query.list();
			logger.info("data fetched successfully from " + viewName + ", data size: " + viewData.size());
			
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return viewData;
	}
	
	/**
	 * <p>
	 * {@link #getViewDataSize(SearchBuilder, String, String)} fetch entity by
	 * {@link #sessionFactory}. This is a common method for all View, so it works for any View.This
	 * method supports search option.
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> SearchBuilder searchBuilder; searchBuilder.setDistrict("DHAKA");
	 * search(searchBuilder, User.class).
	 * 
	 * @param entityType is name of ENtity Type Such as "child,member".
	 * @param searchBuilder is object of search option.
	 * @param viewName is name of target view.
	 * @return total count.
	 */
	
	@Override
	public int getViewDataSize(SearchBuilder searchBuilder, String viewName, String entityType) {
		Session session = sessionFactory.openSession();
		int count = 0;
		try {
			String hql = "SELECT * FROM core.\"" + viewName + "\"" + " where entity_type = '" + entityType + "'";
			
			hql = setViewCondition(searchBuilder, hql);
			Query query = session.createSQLQuery(hql);
			count = query.list().size();
		}
		catch (Exception e) {
			logger.error("Data fetch from " + viewName + " error:" + e.getMessage());
		}
		finally {
			session.close();
		}
		
		return count;
	}
	
	private String setViewCondition(SearchBuilder searchBuilder, String hql) {
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
		if (searchBuilder.getPregStatus() != null && !searchBuilder.getPregStatus().isEmpty()) {
			hql = hql + " and is_pregnant = '" + searchBuilder.getPregStatus() + "'";
		}
		if (searchBuilder.getName() != null && !searchBuilder.getName().isEmpty()) {
			hql = hql + " and first_name ilike '%" + searchBuilder.getName() + "%'";
		}
		
		logger.info(hql);
		return hql;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> getDataFromSQLFunction(Query query, Session session) {
		
		List<T> aggregatedList = null;
		try {
			aggregatedList = query.list();
			logger.info("Report Data fetched successfully from , aggregatedList size: " + aggregatedList.size());
			
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return aggregatedList;
	}

	@Override
	public <T> List<T> getDataByMHV(String username) {
		Session session = sessionFactory.openSession();
		List<T> viewData = null;

		try {
			String hql = "select vc1.health_id as household_id, concat(vc1.first_name, ' ', vc1.lastName) as full_name," +
					" count(case when (vc2.gender = 'M' or vc2.gender = 'F') and vc1.provider_id = vc2.provider_id then 1 end) as population_count," +
					" count(case when vc2.gender = 'M' and vc1.provider_id = vc2.provider_id then 1 end) as male_count," +
					" count(case when vc2.gender = 'F' and vc1.provider_id = vc2.provider_id then 1 end) as female_count, vc1.base_entity_id" +
					" from core.\"viewJsonDataConversionOfClient\" vc1" +
					" left join core.\"viewJsonDataConversionOfClient\" vc2 on vc1.base_entity_id = vc2.relationships_id" +
					" where vc1.provider_id = '"+ username +"' and vc1.entity_type = 'ec_household' " +
					"group by vc1.first_name, vc1.lastName, vc1.health_id, vc1.base_entity_id;";
			Query query = session.createSQLQuery(hql);
			viewData = query.list();
			logger.info("data fetched successfully from " + "viewJsonDataConversionOfClient" + ", data size: " + viewData.size());
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return viewData;
	}

	@Override
	public <T> List<T> getMemberListByHousehold(String householdBaseId, String mhvId) {
		Session session = sessionFactory.openSession();
		List<T> aggregatedList = null;

		try {
			String hql = "select concat(first_name, ' ', lastName) as name, case when gender = 'M' then 'Male' else 'Female' end as gender," +
					" concat(extract(year from age(now(), birth_date)), ' year(s) ', extract(month from age(now(), birth_date)), ' month(s)') as age, health_id" +
					" from core.\"viewJsonDataConversionOfClient\" where relationships_id = '"+householdBaseId+"' and entity_type != 'ec_household' and provider_id = '"+mhvId+"';";
			Query query = session.createSQLQuery(hql);
			aggregatedList = query.list();
			logger.info("data fetched successfully from viewJsonDataConversionOfClient, data size: "+ aggregatedList.size());
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		return aggregatedList;
	}

	@Override
	public <T> T getMemberByHealthId(String healthId) {
		Session session = sessionFactory.openSession();
		T member = null;
		try {
			String hql = "select * from core.\"viewJsonDataConversionOfClient\" where health_id = '"+ healthId +"';";
			Query query = session.createSQLQuery(hql);
			List<T> members = query.list();
			if (members.size() > 0) {
				member = members.get(0);
			}
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return member;
	}

	@Override
	public <T> T getMemberByBaseEntityId(String baseEntityId) {
		Session session = sessionFactory.openSession();
		T member = null;
		try {
			String hql = "select * from core.\"viewJsonDataConversionOfClient\" where base_entity_id = '"+ baseEntityId +"';";
			Query query = session.createSQLQuery(hql);
			List<T> members = query.list();
			if (members.size() > 0) {
				member = members.get(0);
			}
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return member;
	}

	@Override
	public <T> List<T> getMemberListByCC(String ccName) {
		Session session = sessionFactory.openSession();
		List<T> memberList = null;
		try {
			String hql = "select concat(vc.first_name, ' ', vc.lastName) as name, case when vc.gender = 'M' then 'Male' else 'Female' end as gender," +
					" concat(extract(year from age(now(), vc.birth_date)), ' year(s) ', extract(month from age(now(), vc.birth_date)), ' month(s)') as age," +
					" vc.health_id, vc.base_entity_id, r.status from core.\"viewJsonDataConversionOfClient\" vc left join" +
					" core.reviews r on vc.base_entity_id = r.base_entity_id where vc.cc_name = '"
					+ ccName +"' and vc.entity_type != 'ec_household';";
			Query query = session.createSQLQuery(hql);
			memberList = query.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return memberList;
	}

	@Override
	public <T> List<T> getUpazilaList() {
		Session session = sessionFactory.openSession();
		List<T> upazilaList = null;
		try {
			String hql = "select distinct(upazila), count(case when entity_type = 'ec_household' then 1 end) as household_count," +
					" count(case when entity_type != 'ec_household' then 1 end) as population_count from core.\"viewJsonDataConversionOfClient\" group by upazila;\n";
			Query query = session.createSQLQuery(hql);
			upazilaList = query.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return upazilaList;
	}

	@Override
	public <T> List<T> getCCListByUpazila(SearchBuilder searchBuilder) {
		Session session = sessionFactory.openSession();
		List<T> ccList = null;
		try {
			String hql = "select distinct(cc_name), provider_id, count(case when entity_type = 'ec_household' then 1 end) as household_count," +
					" count(case when gender = 'M' or gender = 'F' then 1 end) as population_count, count(case when gender='F' then 1 end) as female," +
					" count(case when gender = 'M' then 1 end) as male from core.\"viewJsonDataConversionOfClient\" where upazila = '"
					+ searchBuilder.getUpazila() +"' and cc_name != '' group by cc_name, provider_id order by cc_name, provider_id;";
			Query query = session.createSQLQuery(hql);
			ccList = query.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return ccList;
	}

	@Override
	public List<ReportDTO> getMHVListFilterWise(String filterString) {
		Session session = sessionFactory.openSession();
		List<ReportDTO> mhvList = null;
		try {
			String hql = "select distinct(provider_id) as mhv, count(case when entity_type = 'ec_household' then 1 end) as household," +
					" count(case when entity_type != 'ec_household' then 1 end) as population, count(case when gender='F' then 1 end) as female," +
					" count(case when gender = 'M' then 1 end) as male from core.\"viewJsonDataConversionOfClient\" "+
					filterString +" group by provider_id order by provider_id;";
			Query query = session.createSQLQuery(hql)
					.addScalar("mhv", StandardBasicTypes.STRING)
					.addScalar("household", StandardBasicTypes.INTEGER)
					.addScalar("population", StandardBasicTypes.INTEGER)
					.addScalar("female", StandardBasicTypes.INTEGER)
					.addScalar("male", StandardBasicTypes.INTEGER)
					.setResultTransformer(Transformers.aliasToBean(ReportDTO.class));
			mhvList = query.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return mhvList;
	}
	
	@Override
	public List<Object[]> getHouseHoldReports(String filterString,String searched_value) {
		Session session = sessionFactory.openSession();
		String conditionString = "";
		
		if("empty".equalsIgnoreCase(searched_value)) {
			 conditionString = "";
		}
		else {
			conditionString = " where "+searched_value;
		}
		
		List<Object[]> mhvList = null;
		try {
			String hql = ""
					+ "select "
					+ "	distinct "+filterString+", "
					+ "	sum(case when entity_type = 'ec_family' then 1 else 0 end) as house_hold_count, "
					+ "	sum(case when house_hold_type = 'NVO' then 1 else 0 end) as NVO, "
					+ "	sum(case when house_hold_type = 'BRAC VO' then 1 else 0 end) as VO, "
					+ "	(sum(case when house_hold_type = 'NVO' then 1 else 0 end) + sum(case when house_hold_type = 'BRAC VO' then 1 else 0 end) ) as Total, "
					+ "	sum(case when entity_type = 'ec_family_member' then 1 else 0 end) as population, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) <= 6 and entity_type = 'ec_child' then 1 else 0 end) as zeroToSixMOnths, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 6 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 13 and entity_type = 'ec_child' then 1 else 0 end) as sevenToTwelveMonths, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 12 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 19 and entity_type = 'ec_child' then 1 else 0 end) as thirteenToEighteen, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 18 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 25 and entity_type = 'ec_child' then 1 else 0 end) as nineteenTotwentyFour, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 24 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 37 and entity_type = 'ec_child' then 1 else 0 end) as twentyFiveTothirtySix, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 36 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 and entity_type = 'ec_child' then 1 else 0 end) as thirtySevenToSixty, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 and entity_type = 'ec_child' then 1 else 0 end) as childrenUnderFIve, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 60 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 120 and entity_type = 'ec_family_member' then 1 else 0 end) as childrenFIveToten, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) <= 228 and gender = 'M' and entity_type = 'ec_family_member' then 1 else 0 end) as tenToNineteenYearMale, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) <= 228 and gender = 'F' and entity_type = 'ec_family_member' then 1 else 0 end) as tenToNineteenYearFemale, "
					+ "	(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) <= 228 and gender = 'M' and entity_type = 'ec_family_member' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) <= 228 and gender = 'F' and entity_type = 'ec_family_member' then 1 else 0 end) ) as TotalMFTenToNineteen, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' and entity_type = 'ec_family_member' then 1 else 0 end) as nineTeenToThirtyFiveMale, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' and entity_type = 'ec_family_member' then 1 else 0 end) as nineTeenToThirtyFiveFemale, "
					+ "	(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' and entity_type = 'ec_family_member' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) > 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' and entity_type = 'ec_family_member' then 1 else 0 end) ) as TotalMFAgedNineteenTOThirtyFive, "
					+ "	sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 420 and entity_type = 'ec_family_member' then 1 else 0 end) as populationThirtyFiveAndAbove, "
					+ "	sum(case when hh_has_latrine = 'Yes' then 1 else 0 end) as countHasSanitaryLatrine "
					+ "	 "
					+ "from "
					+ "	core.\"clientInfoFromJSON\" " + conditionString
					+ "group by "
					+filterString+";";
			Query query = session.createSQLQuery(hql);
			mhvList = query.list();
		} catch (Exception e) {
			logger.error(e);
		} finally {
			session.close();
		}
		return mhvList;
	}

	@Override
	public List<LocationTreeDTO> getProviderLocationTreeByChildRole(int memberId, int childRoleId) {
		List<LocationTreeDTO> treeDTOS = new ArrayList<LocationTreeDTO>();
		Session session = sessionFactory.openSession();
		try {
			String hql = "select * from core.get_location_tree(:memberId, :childRoleId)";
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("code", StandardBasicTypes.STRING)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("leaf_loc_id", StandardBasicTypes.INTEGER)
					.addScalar("member_id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("first_name", StandardBasicTypes.STRING)
					.addScalar("last_name", StandardBasicTypes.STRING)
					.addScalar("loc_tag_name", StandardBasicTypes.STRING)
					.setResultTransformer(Transformers.aliasToBean(LocationTreeDTO.class))
					.setInteger("memberId", memberId)
					.setInteger("childRoleId", childRoleId);
			treeDTOS = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return treeDTOS;
	}

	@Override
	public List<Object[]> getAllSK() {
		Session session = sessionFactory.openSession();
		List<Object[]> allSK = null;
		try {
			String hql = "select distinct(u.username) from core.users u join core.user_role ur on u.id = ur.user_id where ur.role_id = 9";
			allSK = session.createSQLQuery(hql).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return allSK;
	}

	@Override
	public <T> List<T> getCatchmentArea(int userId) {
		Session session = sessionFactory.openSession();
		List<T> catchmentAreas = null;
		try {
			String hql = "select * from core.get_user_catchment(:userId)";
			catchmentAreas = session.createSQLQuery(hql).setInteger("userId", userId).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return catchmentAreas;
	}

	@Override
	public <T> List<T> getVillageIdByProvider(int memberId, int childRoleId, int locationTagId) {
		Session session = sessionFactory.openSession();
		List<T> results = null;
		try {
			String hql = "select * from core.get_location_tree_id(:memberId, :childRoleId, :locationTagId);";
			Query query = session.createSQLQuery(hql)
					.setInteger("memberId", memberId)
					.setInteger("childRoleId", childRoleId)
					.setInteger("locationTagId", locationTagId);
			results = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return results;
	}

	@Override
	public <T> T countByField(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			String hql = "select count(*) from core."+className+ " where " + fieldName + " = :id";
			Query query = session.createSQLQuery(hql).setInteger("id", id);
			result = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return result.get(0);
	}

	public <T> List<T> getReportData(SearchBuilder searchBuilder, String procedureName) {
		Session session = sessionFactory.openSession();
		List<T> aggregatedList = null;
		try {
			String hql = "select * from core." + procedureName + "(array[:division,:district,:upazila"
					+ ",:union,:ward,:cc_name,:subunit,:mauzapara,:provider,:start_date,:end_date,:pregnancy_status,:age_from,:age_to])";
			Query query = session.createSQLQuery(hql);
			setParameter(searchBuilder, query);
			aggregatedList = query.list();

			logger.info("Report Data fetched successfully from " + procedureName
					+", aggregatedList size: " + aggregatedList.size());
		}
		catch (Exception e) {
			logger.error("Data fetch from " + procedureName + " error:" + e.getMessage());
		}
		finally {
			session.close();
		}
		return aggregatedList;
	}

	private void setParameter(SearchBuilder searchFilterBuilder, Query query) {
		if (searchFilterBuilder.getDivision() != null && !searchFilterBuilder.getDivision().isEmpty()) {
			query.setParameter("division", searchFilterBuilder.getDivision());
		} else {
			query.setParameter("division", "");
		}

		if (searchFilterBuilder.getDistrict() != null && !searchFilterBuilder.getDistrict().isEmpty()) {
			query.setParameter("district", searchFilterBuilder.getDistrict());
		} else {
			query.setParameter("district", "");
		}

		if (searchFilterBuilder.getUnion() != null && !searchFilterBuilder.getUnion().isEmpty()) {
			query.setParameter("union", searchFilterBuilder.getUnion());
		} else {
			query.setParameter("union", "");
		}

		if (searchFilterBuilder.getUpazila() != null && !searchFilterBuilder.getUpazila().isEmpty()) {
			query.setParameter("upazila", searchFilterBuilder.getUpazila());
		} else {
			query.setParameter("upazila", "");
		}

		if (searchFilterBuilder.getWard() != null && !searchFilterBuilder.getWard().isEmpty()) {
			query.setParameter("ward", searchFilterBuilder.getWard());
		} else {
			query.setParameter("ward", "");
		}

        if (searchFilterBuilder.getCommunityClinic() != null && !searchFilterBuilder.getCommunityClinic().isEmpty()) {
            query.setParameter("cc_name", searchFilterBuilder.getCommunityClinic());
        } else {
            query.setParameter("cc_name", "");
        }

		if (searchFilterBuilder.getMauzapara() != null && !searchFilterBuilder.getMauzapara().isEmpty()) {
			query.setParameter("mauzapara", searchFilterBuilder.getMauzapara());
		} else {
			query.setParameter("mauzapara", "");
		}

		if (searchFilterBuilder.getSubunit() != null && !searchFilterBuilder.getSubunit().isEmpty()) {
			query.setParameter("subunit", searchFilterBuilder.getSubunit());
		} else {
			query.setParameter("subunit", "");
		}

		if (searchFilterBuilder.getPregStatus() != null && !searchFilterBuilder.getPregStatus().isEmpty()) {
			query.setParameter("pregnancy_status", searchFilterBuilder.getPregStatus());
		} else {
			query.setParameter("pregnancy_status", "");
		}

		if (searchFilterBuilder.getProvider() != null && !searchFilterBuilder.getProvider().isEmpty()) {
			query.setParameter("provider", searchFilterBuilder.getProvider());
		} else {
			query.setParameter("provider", "");
		}

		if (searchFilterBuilder.getStart() != null && !searchFilterBuilder.getStart().isEmpty()
				&& searchFilterBuilder.getEnd() != null && !searchFilterBuilder.getEnd().isEmpty()) {
			query.setParameter("start_date", searchFilterBuilder.getStart());
			query.setParameter("end_date", searchFilterBuilder.getEnd());
		} else {
			query.setParameter("start_date", "");
			query.setParameter("end_date", "");
		}

		if (searchFilterBuilder.getAgeFrom() != null && !searchFilterBuilder.getAgeFrom().isEmpty()
				&& searchFilterBuilder.getAgeTo() != null && !searchFilterBuilder.getAgeTo().isEmpty()) {
			query.setParameter("age_from", searchFilterBuilder.getAgeFrom());
			query.setParameter("age_to", searchFilterBuilder.getAgeTo());
		} else {
			query.setParameter("age_from", "");
			query.setParameter("age_to", "");
		}
	}

	public List<Object[]> getClientInformation(){
		Session session = sessionFactory.openSession();
		List<Object[]> clientInfoList = new ArrayList<Object[]>();
		try {

			String hql = "SELECT c.json ->> 'gender'                                         gender, \n" +
					"       c.json -> 'addresses' -> 0 -> 'addressFields' ->> 'country' country, \n" +
					"       c.json->'addresses' -> 0 -> 'addressFields' ->>'stateProvince'  division, \n"+
					"       c.json->'addresses' -> 0 -> 'addressFields' ->>'countyDistrict'  district, \n"+
					"       c.json->'addresses' -> 0 -> 'addressFields' ->>'cityVillage'  village, \n"+
					"       cast(c.json ->> 'birthdate' as date)                                      birthdate, \n" +
					"       c.json ->> 'firstName'                                      first_name, \n" +
					"       c.json -> 'attributes' ->> 'phoneNumber'                    phone_number, \n" +
					"       c.json -> 'attributes' ->> 'householdCode' \n" +
					"       household_code, \n" +
					"        e.provider_id                                        provider_id, \n" +
					"       cast(e.date_created as date)                                    date_created \n" +
					"FROM   core.client c \n" +
					"       JOIN core.event_metadata e  \n" +
					"         ON c.json ->> 'baseEntityId' = e.base_entity_id;";
//					"FROM core.client c";
			clientInfoList = session.createSQLQuery(hql).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return clientInfoList;
	}

	@Override
	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk) {
		String wh = "";
		List<String> conds = new ArrayList<String>();
		String stCond,edCond,formCond,skCond;
		if(startTime != "" && endTime == "")
			endTime = new Date().toString();
		if(startTime != "" && endTime != ""){
			stCond = "e.date_created BETWEEN \'" + startTime+"\' AND \'"+endTime+"\'";
			conds.add(stCond);
		}

		if(formName.contains("-1") == false){
			formCond = "  e.event_type =\'" + formName +"\'";

			conds.add(formCond);
		}
		if(sk.contains("-1") == false){
			skCond = "e.provider_id =\'" + sk+"\'";
			conds.add(skCond);
		}
		if(conds.size() == 0) wh = "";
		else {
			wh = "\nWHERE ";
			wh += conds.get(0);
			for(int i = 1; i < conds.size();i++){
				wh += " AND ";
				wh += conds.get(i);
			}
		}

		Session session = sessionFactory.openSession();
		List<Object[]> clientInfoList = new ArrayList<Object[]>();
		try {

			String hql = "SELECT c.json ->> 'gender'                                         gender, \n" +
					"       c.json -> 'addresses' -> 0 -> 'addressFields' ->> 'country' country,\n" +
					"\t    c.json->'addresses' -> 0 -> 'addressFields' ->>'stateProvince'  division,\n" +
					"\t\tc.json->'addresses' -> 0 -> 'addressFields' ->>'countyDistrict'  district, \n" +
					"\t\tc.json->'addresses' -> 0 -> 'addressFields' ->>'cityVillage'  village,\n" +
					"       cast(c.json ->> 'birthdate' as date)                                      birthdate, \n" +
					"       c.json ->> 'firstName'                                      first_name, \n" +
					"       c.json -> 'attributes' ->> 'phoneNumber'                    phone_number, \n" +
					"       c.json -> 'attributes' ->> 'householdCode' \n" +
					"       household_code, \n" +
					"       e.provider_id                                     provider_id, \n" +
					"       cast(e.date_created as date)                                      date_created \n" +
					"FROM   core.client c \n" +
					"       JOIN core.event_metadata e \n" +
					"         ON c.json ->> 'baseEntityId' = e.base_entity_id";
					hql += wh;
					hql += ";";
			clientInfoList = session.createSQLQuery(hql).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return clientInfoList;
	}


	public <T> List<T> getUniqueLocation(String village, String ward) {
		List<T> locations = null;
		Session session = sessionFactory.openSession();

		try {
			String hql = "select l1.id as id from core.location l1 join core.location l2 on l1.parent_location_id = l2.id"
					+ " where l1.location_tag_id = 26 and l2.location_tag_id = 25 and l1.name like concat(:village,':%')"
					+ " and l2.name like concat(:ward,':%');";
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.setString("village", village)
					.setString("ward", ward)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationTreeDTO.class));
			locations = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		System.out.println("location size::-> "+ locations.size());

		return locations.size()>0?locations:null;
	}

}
