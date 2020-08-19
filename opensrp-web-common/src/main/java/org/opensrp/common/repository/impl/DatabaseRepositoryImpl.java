package org.opensrp.common.repository.impl;

import java.math.BigInteger;
import java.util.*;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.*;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.dto.*;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
	private static final int SK_ID = 28;
	private static final int VILLAGE_ID = 33;
	private static final int UNION_ID = 32;
	private static final int POURASABHA_ID = 31;

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
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		long returnValue = 0;
		try {
			tx = session.beginTransaction();
			for (int i = 0; i < t.size(); i++) {
				session.saveOrUpdate(t.get(i));
			}
			logger.info("saved successfully: " + t.getClass().getName());
			if (!tx.wasCommitted()) tx.commit();
			returnValue = t.size();
		} catch (HibernateException e) {
			returnValue = 0;
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
			logger.error(e.getMessage());
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


	@Override
	public <T> boolean deleteAllByKeys(List<Integer> locationIds, Integer userId) {
		Session session = sessionFactory.openSession();
		boolean returnValue = false;
		try {
			String hql = "delete from core.users_catchment_area where user_id = :userId and location_id in (:locationIds)";
			Query query = session.createSQLQuery(hql)
					.setInteger("userId", userId)
					.setParameterList("locationIds", locationIds);
			Integer flag = query.executeUpdate();
			if (flag > 0) returnValue = true;
		}
		catch (HibernateException e) {
			returnValue = false;
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
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			criteria.add(Restrictions.eq(fieldName, id));
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}

	@Override
	public <T> List<T> findAllById(List<Integer> ids, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			String hql = "from "+className+" where "+fieldName+" in :ids";
			Query query = session.createQuery(hql).setParameterList("ids", ids);
			result = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return (List<T>) (result.size() > 0 ? (List<T>) result : null);
	}

	public <T> T findByForeignKey(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			String hql = "from "+className+" where " + fieldName + " = :id";
			Query query = session.createQuery(hql).setInteger("id", id);
			result = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return (T) (result.size() > 0 ? (T) result.get(0) : null);
	}

	public <T> List<T> findAllByForeignKey(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			String hql = "from "+className+" where " + fieldName + " = :id";
			result = session.createQuery(hql).setInteger("id", id).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			criteria.add(Restrictions.eq(fieldName, value));
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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
	 * @param fieldValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */

	@Override
	public <T> T findByKeys(Map<String, Object> fieldValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fieldValues.entrySet()) {
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
	 * @param fieldValues is map of field and corresponding value.
	 * @param orderByFieldName is name of field where ordering is applied.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return Entity object or null.
	 */
	@Override
	public <T> T findLastByKey(Map<String, Object> fieldValues, String orderByFieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fieldValues.entrySet()) {
				criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
			}
			criteria.addOrder(Order.desc(orderByFieldName));
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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
		List<T> result = new ArrayList<T>();

		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fielaValues.entrySet()) {
				criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
			}
			criteria.add(Restrictions.lt(field, fieldDateValue));
			criteria.addOrder(Order.desc(orderByFieldName));
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

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
	 * @param fieldValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of Entity object or null.
	 */

	@Override
	public <T> List<T> findAllByKeys(Map<String, Object> fieldValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fieldValues.entrySet()) {
				criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
				criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
			}
//			@SuppressWarnings("unchecked")
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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
	 * @param fieldValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return List of Entity object or null.
	 */


	@SuppressWarnings("unchecked")
	@Override
	public <T> List<T> findAllByKeysWithALlMatches(boolean isProvider, Map<String, String> fieldValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, String> entry : fieldValues.entrySet()) {
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
	 * @param fieldValues is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return boolean value.
	 */
	@Override
	@SuppressWarnings("unchecked")
	public boolean isExists(Map<String, Object> fieldValues, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<Object> result = new ArrayList<Object>();
		try {
			Criteria criteria = session.createCriteria(className);
			for (Map.Entry<String, Object> entry : fieldValues.entrySet()) {
				criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
				criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
			}
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return (result.size() > 0 ? true : false);
	}

	@Override
	@SuppressWarnings("unchecked")
	public boolean isExistsCustom(String value, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<Object> result = new ArrayList<Object>();
		try {
			Criteria criteria = session.createCriteria(className);
			Criterion criterion1 = Restrictions.eq("imei1", value);
			Criterion criterion2 = Restrictions.eq("imei2", value);
			LogicalExpression orExp = Restrictions.or(criterion1, criterion2);
			criteria.add(orExp);
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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
	 * @param fieldName is map of field and corresponding value.
	 * @param className is name of Entity class who is mapped with database table.
	 * @return boolean value.
	 */

	@Override
	@SuppressWarnings("unchecked")
	public <T> boolean entityExistsNotEqualThisId(int id, T value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<Object> result = new ArrayList<Object>();
		try {
			Criteria criteria = session.createCriteria(className);
			criteria.add(Restrictions.eq(fieldName, value));
			criteria.add(Restrictions.ne("id", id));
			result = criteria.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return (result.size() > 0 ? true : false);
	}

	@Override
	public <T> boolean isLocationExists(int parentLocationId, String name, String code, Class<?> className) {
		List<Object> result = new ArrayList<Object>();
		Session session = sessionFactory.openSession();
		try {
			String hql = "select * from core.location where (name = :name or name = :nameWithParentId or code = :code) and parent_location_id = "+parentLocationId+";";
			Query query = session.createSQLQuery(hql)
					.setString("name", name)
					.setString("nameWithParentId", name+":"+parentLocationId)
					.setString("code", code);
			result = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
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

	@Override
	public <T> List<T> findAllLocationPartialProperty(Integer roleId) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			String hql = "select l.id, split_part(l.name, ':', 1) locationName, l.parent_location_id parentLocationId, "
					+ "lt.name locationTagName, string_agg(case when ur.role_id != :roleId then null "
					+ "else u.first_name || ' - ' || u.username end, ', ') users from core.location l join "
					+ "core.location_tag lt on lt.id = l.location_tag_id left join core.users_catchment_area uca on uca.location_id = l.id "
					+ "left join core.users u on u.id = uca.user_id left join core.user_role ur on ur.user_id = u.id where lt.id != :villageId "
					+ "group by l.id, lt.name order by id asc;"; //village id = 33
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("locationName", StandardBasicTypes.STRING)
					.addScalar("parentLocationId", StandardBasicTypes.INTEGER)
					.addScalar("locationTagName", StandardBasicTypes.STRING)
					.addScalar("users", StandardBasicTypes.STRING)
					.setInteger("villageId", LocationTags.VILLAGE.getId())
					.setInteger("roleId", roleId)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationDTO.class));
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

	@Override
	public <T> List<T> findAllLocation(String tableClass) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			Query query = session.createQuery("from " + tableClass + " t order by t.id asc");
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
	 * @param entityClassName is name of Entity class who is mapped with database table.
	 * @return List of object or null.
	 */

	@Override
	@SuppressWarnings("unchecked")
	public <T> List<T> search(SearchBuilder searchBuilder, int maxResult, int offsetreal, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		List<T> data = new ArrayList<T>();
		try {
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
	 * @param entityClassName is name of Entity class who is mapped with database table.
	 * @return total count.
	 */
	@Override
	public int countBySearch(SearchBuilder searchBuilder, Class<?> entityClassName) {
		Session session = sessionFactory.openSession();
		Long count = 0L;
		try {
			Criteria criteria = session.createCriteria(entityClassName);
			criteria = DatabaseServiceImpl.createCriteriaCondition(searchBuilder, criteria);
			criteria.setProjection(Projections.rowCount());
			count = (Long) criteria.uniqueResult();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}

		return count.intValue();
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
	 * @param offsetreal is number of offset.
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
	public List<Object[]> getHouseHoldReports(String startDate, String endDate, String filterString, String searched_value, List<Object[]> allSKs, Integer searchedValueId) {
		String[] values = searched_value.split(":");
		searched_value = values[0]+(values.length > 1?"'":"");
		Session session = sessionFactory.openSession();
		String conditionString = " where cast(date_created as text) between :startDate and :endDate";
		String skForBranch = "";
		if(!"empty".equalsIgnoreCase(searched_value)) {
			conditionString += " and "+searched_value;
		}
		if (allSKs.size() != 0) {
			String providerIds = "";
			int size = allSKs.size();
			for (int i = 0; i < size; i++) {
				providerIds += "'" + allSKs.get(i)[1].toString() + "'";
				if (i != size - 1)
					providerIds += ",";
			}
			if (filterString.equalsIgnoreCase("sk_id") && searched_value.equalsIgnoreCase("empty")) {
				conditionString = conditionString + " and sk_id in (" + providerIds + ")";
				skForBranch = providerIds;
			}
		}

		System.err.println("Location Id: "+ searchedValueId);

		List<Object[]> mhvList = null;
		try {

			String filterStringAlt = filterString;
			if (filterString.equalsIgnoreCase("upazila"))filterStringAlt = "city corporation upazila";

			String exceptSK = "select *, ( select first_name from core.users where username = a.filter_name) "
					+ "from (select case when lower(lt.name) = 'division' then l.name else split_part(l.name, ':', 1) end as filter_name"
					+ " from core.location l join core.location_tag lt on l.location_tag_id = lt.id where lower(lt.name) = '"+filterStringAlt+"'"
					+ " and l.parent_location_id = "+searchedValueId;

			String sk = "select *, ( select first_name from core.users where username = a.filter_name) "
					+ "from ( with recursive main_location_tree as ( select * from "
					+ "core.location where id in ( with recursive location_tree as ("
					+ "select * from core.location l where "
					+ "l.id = "+searchedValueId+" union all select loc.* from "
					+ "core.location loc join location_tree lt on "
					+ "lt.id = loc.parent_location_id ) select distinct(lt.id) from "
					+ "location_tree lt where lt.location_tag_id = 33) union all "
					+ "select l.* from core.location l "
					+ "join main_location_tree mlt on l.id = mlt.parent_location_id ) select "
					+ "distinct(u.username) filter_name from main_location_tree mlt "
					+ "join core.users_catchment_area uca on uca.location_id = mlt.id "
					+ "join core.users u on u.id = uca.user_id join core.user_branch ub on "
					+ "ub.user_id = u.id join core.branch b on b.id = ub.branch_id "
					+ "join core.user_role ur on u.id = ur.user_id join core.role r on "
					+ "ur.role_id = r.id where ur.role_id = 28";
			String branch = "select *, (select first_name from "
					+ "core.users where username = a.filter_name) from "
					+ "( select u.username as filter_name from core.users as u where u.username in ( "
					+ skForBranch+")";

			String selectedFilter = !filterString.equalsIgnoreCase("sk_id")? exceptSK: searched_value.equalsIgnoreCase("empty")?branch:sk;

			String hql = "with agg_report as(with main_report as ("+selectedFilter+") a "
					+ "left join ( with report as ( select * from ( select distinct on "
					+ "("+filterString+") "+filterString+", "
					+ "sum(coalesce(case when entity_type = 'ec_family' then 1 else 0 end, 0)) as house_hold_count, "
					+ "sum(case when house_hold_type = 'NVO' then 1 else 0 end) as nvo, "
					+ "sum(case when house_hold_type = 'BRAC VO' then 1 else 0 end) as vo, "
					+ "(sum(case when house_hold_type = 'NVO' or house_hold_type = 'BRAC VO' then 1 else 0 end) ) as total_household, "
					+ "sum(case when gender = 'M' or gender = 'F' then 1 else 0 end) as population, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 6 then 1 else 0 end) as zero_to_six_months, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 6 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 12 then 1 else 0 end) as seven_to_twelve_months, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 12 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 18 then 1 else 0 end) as thirteen_to_eighteen, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 18 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 24 then 1 else 0 end) as nineteen_to_twenty_four, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 24 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 36 then 1 else 0 end) as twenty_five_to_thirty_six, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 36 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 then 1 else 0 end) as thirty_seven_to_sixty, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 60 then 1 else 0 end) as children_under_five, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 60 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 120 then 1 else 0 end) as children_five_to_ten, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'M' then 1 else 0 end) as ten_to_nineteen_year_male, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'F' then 1 else 0 end) as ten_to_nineteen_year_female, "
					+ "(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'M' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 120 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 228 and gender = 'F' then 1 else 0 end) ) as total_mf_ten_to_nineteen, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' then 1 else 0 end) as nineteen_to_thirty_five_male, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' then 1 else 0 end) as nineteen_to_thirty_five_female, "
					+ "(sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'M' then 1 else 0 end) + sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 228 and ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) < 420 and gender = 'F' then 1 else 0 end) ) as total_mf_aged_nineteen_tO_thirty_five, "
					+ "sum(case when ((extract( year from now() ) - extract( year from birth_date)) * 12) + extract(month from now() ) - extract(month from birth_date) >= 420 and entity_type = 'ec_family_member' then 1 else 0 end) as population_thirty_five_and_above, "
					+ "sum(case when hh_has_latrine = 'Yes' then 1 else 0 end) as count_has_sanitary_latrine, "
					+ "sum(finger_print_taken) as total_finger_print_taken, "
					+ "sum(finger_print_availability) as total_finger_print_availability from "
					+ "core.\"clientInfoFromJSON\" "
					+ conditionString
					+ " group by "+filterString+") tmp) select * "
					+ "from report ) b on a.filter_name = b."+filterString+" ) select * from "
					+ "main_report union all select 'TOTAL', null, "
					+ "sum(house_hold_count), sum(nvo), sum(vo), sum(total_household), "
					+ "sum(population), sum(zero_to_six_months), sum(seven_to_twelve_months), "
					+ "sum(thirteen_to_eighteen), sum(nineteen_to_twenty_four), "
					+ "sum(twenty_five_to_thirty_six), sum(thirty_seven_to_sixty), "
					+ "sum(children_under_five), sum(children_five_to_ten), "
					+ "sum(ten_to_nineteen_year_male), sum(ten_to_nineteen_year_female), "
					+ "sum(total_mf_ten_to_nineteen), sum(nineteen_to_thirty_five_male), "
					+ "sum(nineteen_to_thirty_five_female), sum(total_mf_aged_nineteen_tO_thirty_five), "
					+ "sum(population_thirty_five_and_above), sum(count_has_sanitary_latrine), "
					+ "sum(total_finger_print_taken), sum(total_finger_print_availability), null "
					+ "from main_report) select "
					+ "coalesce(filter_name, '') filter_name,"
					+ "coalesce(house_hold_count, 0) house_hold_count,"
					+ "coalesce(nvo, 0) nvo,"
					+ "coalesce(vo, 0) vo, "
					+ "coalesce(total_household, 0) total_household,"
					+ "coalesce(population, 0) population,"
					+ "coalesce(zero_to_six_months, 0) zero_to_six_months,"
					+ "coalesce(seven_to_twelve_months, 0) seven_to_twelve_months,"
					+ "coalesce(thirteen_to_eighteen, 0) thirteen_to_eighteen,"
					+ "coalesce(nineteen_to_twenty_four, 0) nineteen_to_twenty_four,"
					+ "coalesce(twenty_five_to_thirty_six, 0) twenty_five_to_thirty_six,"
					+ "coalesce(thirty_seven_to_sixty, 0) thirty_seven_to_sixty,"
					+ "coalesce(children_under_five, 0) children_under_five,"
					+ "coalesce(children_five_to_ten, 0) children_five_to_ten,"
					+ "coalesce(ten_to_nineteen_year_male, 0) ten_to_nineteen_year_male,"
					+ "coalesce(ten_to_nineteen_year_female, 0) ten_to_nineteen_year_female,"
					+ "coalesce(total_mf_ten_to_nineteen, 0) total_mf_ten_to_nineteen,"
					+ "coalesce(nineteen_to_thirty_five_male, 0) nineteen_to_thirty_five_male,"
					+ "coalesce(nineteen_to_thirty_five_female, 0) nineteen_to_thirty_five_female,"
					+ "coalesce(total_mf_aged_nineteen_tO_thirty_five, 0) total_mf_aged_nineteen_tO_thirty_five,"
					+ "coalesce(population_thirty_five_and_above, 0) population_thirty_five_and_above,"
					+ "coalesce(count_has_sanitary_latrine, 0) count_has_sanitary_latrine,"
					+ "coalesce(total_finger_print_taken, 0) total_finger_print_taken,"
					+ "coalesce(total_finger_print_availability, 0) total_finger_print_availability,"
					+ "first_name"
					+ " from agg_report;";

			Query query = session.createSQLQuery(hql)
					.setString("startDate", startDate)
					.setString("endDate", endDate);
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
	public List<Object[]> getAllSK(List<Object[]> branches) {
		Session session = sessionFactory.openSession();
		List<Object[]> allSK = null;
		String additionalQuery = "";
		if (branches != null && branches.size() > 0) {
			additionalQuery = " and ub.branch_id in (";
			int size = branches.size();
			for (int i = 0; i < size; i++) {
				additionalQuery += branches.get(i)[0].toString();
				if (i != size-1) additionalQuery += ",";
			}
			additionalQuery += ");";
		}
		try {
			String hql = "select u.id, u.username, concat(u.first_name, ' ', u.last_name), ub.branch_id from core.users u"
					+ " join core.user_role ur on u.id = ur.user_id join core.user_branch ub on u.id = ub.user_id"
					+ " where ur.role_id = :skId" + additionalQuery;
			allSK = session.createSQLQuery(hql).setInteger("skId", SK_ID).list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return allSK;
	}

	@Override
	public List<Object[]> getSKByBranch(String branchIds) {
		Session session = sessionFactory.openSession();
		List<Object[]> skList = null;
		try {
			String hql = "select u.id, u.username, concat(u.first_name, ' ', u.last_name), ub.branch_id from core.users u join core.user_role ur on u.id = ur.user_id"
					+ " join core.user_branch ub on u.id = ub.user_id where ur.role_id = :skId and ub.branch_id = any(array["+branchIds+"])";
			skList = session.createSQLQuery(hql)
					.setInteger("skId", SK_ID)
					.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return skList;
	}

	@Override
	public List<UserDTO> findSKByBranch(Integer branchId) {
		Session session = sessionFactory.openSession();
		List<UserDTO> skList = new ArrayList<UserDTO>();
		try {
			String hql = "select u.id id, u.username username, u.first_name firstName, u.last_name lastName from core.users u "
					+ "join core.user_role ur on u.id = ur.user_id join core.user_branch ub on u.id = ub.user_id "
					+ "where ur.role_id = :skId and ub.branch_id = :branchId";
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("lastName", StandardBasicTypes.STRING)
					.setInteger("skId", Roles.SK.getId())
					.setInteger("branchId", branchId)
					.setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
			skList = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return skList;
	}

	@Override
	public <T> T findSKByLocationSeparatedByComma(Integer locationId, Integer roleId) {
		Session session = sessionFactory.openSession();
		List<T> skIds = null;
		try {
			String hql = "select * from core.get_sk_by_location(:locationId, :roleId)";
			Query query = session.createSQLQuery(hql)
					.setInteger("locationId", locationId)
					.setInteger("roleId", roleId);
			skIds = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return skIds.get(0);
	}

	@Override
	public <T> T findSKByBranchSeparatedByComma(String branchIds) {
		Session session = sessionFactory.openSession();
		List<T> skIds = null;
		try {
			String hql = "select string_agg(u.username, ', ') skIds from core.users u join core.user_branch ub " +
					"on u.id = ub.user_id join core.user_role ur on ur.user_id = u.id where ub.branch_id = any("+branchIds+") " +
					"and ur.role_id = "+ Roles.SK.getId()+";";
			Query query = session.createSQLQuery(hql).addScalar("skIds", StandardBasicTypes.STRING);
			skIds = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return skIds.get(0);
	}

	public Integer updateParentForSS(Integer ssId, Integer parentId) {
		Session session = sessionFactory.openSession();
		int isUpdate = 0;
		try {
			String hql = "update core.users set parent_user_id = :parentId where id = :ssId";
			isUpdate = session.createSQLQuery(hql)
					.setInteger("parentId", parentId)
					.setInteger("ssId", ssId)
					.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return isUpdate;
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
	public <T> List<T> getCatchmentAreaForUser(int userId) {
		Session session = sessionFactory.openSession();
		List<T> catchmentAreas = null;
		try {
			String hql = "select * from core.get_user_location(:userId)";
			catchmentAreas = session.createSQLQuery(hql).setInteger("userId", userId).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return catchmentAreas;
	}

	@Override
	public <T> List<T> getSSListByLocation(Integer locationId, Integer roleId) {
		Session session = sessionFactory.openSession();
		List<T> ssList = new ArrayList<T>();
		try {
			String hql = "select concat(u.first_name, ' - ',u.username) ssName, uca.id ucaId from core.users_catchment_area uca "
					+ "join core.user_role ur on ur.user_id = uca.user_id join core.users u on u.id = uca.user_id "
					+ "where ur.role_id = :roleId and uca.location_id = "+locationId+";";
			Query query = session.createSQLQuery(hql)
					.addScalar("ssName", StandardBasicTypes.STRING)
					.addScalar("ucaId", StandardBasicTypes.INTEGER)
					.setInteger("roleId", roleId)
					.setResultTransformer(new AliasToBeanResultTransformer(SSWithUCAIdDTO.class));
			ssList = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return ssList;
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

	@Override
	public <T> T maxByHealthId(int id, String fieldName, String className) {
		Session session = sessionFactory.openSession();
		List<T> result = null;
		try {
			String hql = "select coalesce(max(cast(h_id as integer)), 0) maxHealthId from core."+className+ " where " + fieldName + " = :id";
			Query query = session.createSQLQuery(hql)
					.addScalar("maxHealthId", StandardBasicTypes.INTEGER)
					.setInteger("id", id);
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

			String hql = "SELECT Distinct On(c.json ->> 'baseEntityId')\n" +
					"		c.json ->> 'gender' gender, \n" +
					"       c.json->'addresses' -> 0 ->>'country' country, \n" +
					"       c.json->'addresses' -> 0 ->>'stateProvince' division, \n"+
					"       c.json->'addresses' -> 0 ->>'countyDistrict' district, \n"+
					"       c.json->'addresses' -> 0 ->>'cityVillage' village, \n"+
					"       cast(c.json ->> 'birthdate' as date) birthdate, \n" +
					"       c.json ->> 'firstName' first_name, \n" +
//					" 		c.json -> 'attributes' ->> 'Cluster' cluster, \n"+
					" 		c.json -> 'attributes' ->> 'HH_Type' household_type, \n"+
					"       c.json -> 'attributes' ->> 'HOH_Phone_Number' phone_number, \n" +
					"       c.json -> 'attributes' ->> 'householdCode' household_code, \n" +
					"       e.provider_id provider_id, \n" +
					"       cast(e.date_created as date) date_created, \n" +
					"       c.json -> 'attributes' ->> 'SS_Name' ss_name, \n"+
					"       c.json -> 'attributes' ->> 'HH_Type' household_type, \n"+
					"       c.json -> 'attributes' ->> 'Has_Latrine' has_latrine, \n"+
					"       c.json -> 'attributes' ->> 'Number_of_HH_Member' total_member, \n"+
					"       c.json -> 'attributes' ->> 'motherNameEnglish' mother_name, \n"+
					"       c.json -> 'attributes' ->> 'Relation_with_HOH' relation_household, \n"+
					"       c.json -> 'attributes' ->> 'Blood_Group' blood_group, \n"+
					"       c.json -> 'attributes' ->> 'Marital_Status' marital_status, \n"+
					"       c.json->'addresses' -> 0 -> 'addressFields' ->> 'address2' upazila, \n"+
					"       c.json->'addresses' -> 0 -> 'addressFields' ->> 'address1' city_union, \n"+
					"       c.json -> 'attributes' ->> 'nationalId' national_id \n"+
					"FROM   core.client c \n" +
					"       JOIN core.event_metadata e \n" +
					"         ON c.json ->> 'baseEntityId' = e.base_entity_id";

			clientInfoList = session.createSQLQuery(hql).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return clientInfoList;
	}

	@Override
	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs, Integer pageNumber) {
		String hql = "";
		if (formName.equalsIgnoreCase("ec family member")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_member_and_child_report_by_sk('"+startTime+"', '"+endTime+"', 'Family Member Registration', '{"+sk+"}', 10, "+ pageNumber*10+");";
			} else {
				hql = "select * from report.get_member_and_child_report('"+startTime+"', '"+endTime+"', 'Family Member Registration', 10, "+ pageNumber*10+");";
			}
		} else if (formName.equalsIgnoreCase("ec child")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_member_and_child_report_by_sk('"+startTime+"', '"+endTime+"', 'Child Registration', '{"+sk+"}', 10, "+ pageNumber*10+");";
			} else {
				hql = "select * from report.get_member_and_child_report('"+startTime+"', '"+endTime+"', 'Child Registration', 10, "+ pageNumber*10+");";
			}
		} else if (formName.equalsIgnoreCase("ec family")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_household_report_by_sk('"+startTime+"', '"+endTime+"', '{"+sk+"}', 10, "+ pageNumber*10+");";
			} else {
				hql = "select * from report.get_household_report('"+startTime+"', '"+endTime+"', 10, "+ pageNumber*10+");";
			}
		}

		System.out.println("::HQL::");
		System.out.println(hql);
		Session session = sessionFactory.openSession();
		List<Object[]> clientInfoList = new ArrayList<Object[]>();
		try {
			clientInfoList = session.createSQLQuery(hql).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return clientInfoList;
	}


	@Override
	public Integer getClientInfoFilterCount(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs) {
		String hql = "";
		if (formName.equalsIgnoreCase("ec family member")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_member_and_child_report_by_sk_count('"+startTime+"', '"+endTime+"', 'Family Member Registration', '{"+sk+"}');";
			} else {
				hql = "select * from report.get_member_and_child_report_count('"+startTime+"', '"+endTime+"', 'Family Member Registration');";
			}
		} else if (formName.equalsIgnoreCase("ec child")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_member_and_child_report_by_sk_count('"+startTime+"', '"+endTime+"', 'Child Registration', '{"+sk+"}');";
			} else {
				hql = "select * from report.get_member_and_child_report_count('"+startTime+"', '"+endTime+"', 'Child Registration');";
			}
		} else if (formName.equalsIgnoreCase("ec family")) {
			if (!StringUtils.isBlank(sk)) {
				hql = "select * from report.get_household_report_by_sk_count('"+startTime+"', '"+endTime+"', '{"+sk+"}');";
			} else {
				hql = "select * from report.get_household_report_count('"+startTime+"', '"+endTime+"');";
			}
		}
		Session session = sessionFactory.openSession();
		Integer clientInfoCount = 0;
		try {
			clientInfoCount = ((BigInteger)session.createSQLQuery(hql).uniqueResult()).intValue();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return clientInfoCount;
	}

	@Override
	public List<Object[]> getExportByCreator(String username, String formName) {
		Session session = sessionFactory.openSession();
		List<Object[]> exportData = new ArrayList<Object[]>();
		try	{
			exportData = session.createSQLQuery("select file_name, status from export where creator = :username and form_name = :formName order by id desc limit 1")
					.setParameter("username", username)
					.setString("formName", formName)
					.list();


		}  catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return exportData;
	}


	@Override
	public List<Object[]> getUserListByFilterString(int locationId, int locationTagId, int roleId, int branchId, String name, int limit, int offset, String orderColumn, String orderDirection) {
		Session session = sessionFactory.openSession();
		List<Object[]> userList = null;
		String andUsername = (name==null || name.equalsIgnoreCase(""))?"":" and user_ucv_branch.username ilike '%"+name+"%' ";
		String afterWhere = "";
		if (branchId > 0) afterWhere += " and user_ucv_branch.branch_id = "+branchId;

		if (roleId > 0) afterWhere += " and vur.id = " + roleId;

		if(!org.apache.commons.lang3.StringUtils.isBlank(name)){
			afterWhere += " and user_ucv_branch.username like '" + name.trim() + "%'";
		}
		try {
			String sql = "with recursive subordinates as (select id, code, name, "
					+ "location_tag_id, parent_location_id from core.location where "
					+ "id = :locationId union select e.id, e.code, e.name, "
					+ "e.location_tag_id, e.parent_location_id from core.location e "
					+ "inner join subordinates s on s.id = e.parent_location_id) , vl as(select "
					+ "id from subordinates where location_tag_id = any(select "
					+ "id from core.location_tag)), ucv as(select uc.id, "
					+ "uc.location_id, uc.user_id from vl, core.users_catchment_area uc "
					+ "where vl.id = uc.location_id), user_ucv as(select "
					+ "distinct ucv.user_id, u.first_name, u.last_name, u.username, "
					+ "u.mobile from ucv, core.users u where ucv.user_id = u.id), "
					+ "user_ucv_branch as(select user_ucv.*, vub.id branch_id, branch_name "
					+ "from user_ucv, core.vw_user_branch vub where "
					+ "user_ucv.user_id = vub.user_id) "
					+ "select user_ucv_branch.username username, "
					+ "(user_ucv_branch.first_name || ' ' || user_ucv_branch.last_name) full_name, "
					+ "user_ucv_branch.mobile mobile, vur.role_name role_name, "
					+ "string_agg(user_ucv_branch.branch_name, ', ') branch, user_ucv_branch.user_id, "
					+ "vur.id role_id from user_ucv_branch, core.vw_user_role vur where "
					+ "user_ucv_branch.user_id = vur.user_id "+andUsername+afterWhere+" group by user_ucv_branch.user_id, "
					+ "user_ucv_branch.first_name, user_ucv_branch.last_name, user_ucv_branch.username, "
					+ "user_ucv_branch.mobile, vur.id, vur.role_name ";

			Query query = session.createSQLQuery(sql + " order by "+ orderColumn+ " " + orderDirection +" limit "+limit+" offset "+offset)
					.setInteger("locationId", locationId);
			userList = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return userList;
	}

	@Override
	public <T> T getUserListByFilterStringCount(int locationId, int locationTagId, int roleId, int branchId, String name, int limit, int offset) {
		Session session = sessionFactory.openSession();
		List<T> userList = new ArrayList<T>();
		String andUsername = (name==null || name.equalsIgnoreCase(""))?"":" and user_ucv_branch.username ilike '%"+name+"%' ";
		String afterWhere = "";
		if(!org.apache.commons.lang3.StringUtils.isBlank(name)){
			afterWhere += " and user_ucv_branch.username like '" + name.trim() + "%'";
		}
		if (roleId > 0) afterWhere += " and vur.id = " + roleId;
		if (branchId > 0) afterWhere += " and user_ucv_branch.branch_id = "+branchId;
		try {
			String sql = "with recursive subordinates as (select id, code, name, "
					+ "location_tag_id, parent_location_id from core.location where "
					+ "id = :locationId union select e.id, e.code, e.name, "
					+ "e.location_tag_id, e.parent_location_id from core.location e "
					+ "inner join subordinates s on s.id = e.parent_location_id) , vl as(select "
					+ "id from subordinates where location_tag_id = any(select "
					+ "id from core.location_tag)), ucv as(select uc.id, "
					+ "uc.location_id, uc.user_id from vl, core.users_catchment_area uc "
					+ "where vl.id = uc.location_id), user_ucv as(select "
					+ "distinct ucv.user_id, u.first_name, u.last_name, u.username, "
					+ "u.mobile from ucv, core.users u where ucv.user_id = u.id), "
					+ "user_ucv_branch as(select user_ucv.*, vub.id branch_id, branch_name "
					+ "from user_ucv, core.vw_user_branch vub where user_ucv.user_id = vub.user_id) "
					+ "select count(distinct(user_ucv_branch.user_id)) totalUser from user_ucv_branch, core.vw_user_role vur where "
					+ "user_ucv_branch.user_id = vur.user_id "+andUsername+afterWhere+" ";

			Query query = session.createSQLQuery(sql)
					.addScalar("totalUser", StandardBasicTypes.INTEGER)
					.setInteger("locationId", locationId);
			userList = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return userList.get(0);
	}

	@Override
	public List<Object[]> getUserListWithoutCatchmentArea(int roleId, int branchId, String name, Integer limit, Integer offset, String orderColumn, String orderDirection) {
		List<Object[]> users = new ArrayList<Object[]>();
		Session session = sessionFactory.openSession();
		String andUsername = (name==null || name.equalsIgnoreCase(""))?"":" and u.username ilike '%"+name+"%'";
		try {
			String hql = "select distinct(u.username) username, concat(u.first_name, ' ', u.last_name) full_name, "
					+ "u.mobile mobile, r.name role_name, (select string_agg(b1.name, ', ') "
					+ "from core.branch b1 join core.user_branch ub1 on b1.id = ub1.branch_id where ub1.user_id = u.id) branch, "
					+ "u.id from core.users as u join core.user_role ur on ur.user_id = u.id "
					+ "join core.user_branch ub on ub.user_id = u.id "
					+ "left join core.users_catchment_area uca on uca.user_id = u.id "
					+ "join core.role r on r.id = ur.role_id join core.branch b on b.id = ub.branch_id "
					+ "where uca.user_id is null"+andUsername;
			if (branchId > 0) hql += " and ub.branch_id = "+branchId;
			if (roleId > 0) hql += " and ur.role_id = "+roleId;
			hql +=  " order by "+orderColumn+" "+orderDirection+" limit "+limit+ " offset "+offset;
			Query query = session.createSQLQuery(hql);
			users = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return users;
	}

	@Override
	public <T> T getUserListWithoutCatchmentAreaCount(int roleId, int branchId, String name) {
		List<T> users = new ArrayList<T>();
		Session session = sessionFactory.openSession();
		String andUsername = (name==null || name.equalsIgnoreCase(""))?"":" and u.username ilike '%"+name+"%'";
		try {
			String hql = "select count(distinct(u.id)) totalUser from core.users as u join core.user_role ur on ur.user_id = u.id "
					+ "join core.user_branch ub on ub.user_id = u.id "
					+ "left join core.users_catchment_area uca on uca.user_id = u.id "
					+ "join core.role r on r.id = ur.role_id join core.branch b on b.id = ub.branch_id "
					+ "where uca.user_id is null"+andUsername;
			if (branchId > 0) hql += " and ub.branch_id = "+branchId;
			if (roleId > 0) hql += " and ur.role_id = "+roleId;
			Query query = session.createSQLQuery(hql).addScalar("totalUser", StandardBasicTypes.INTEGER);
			users = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return users.get(0);
	}

	@Override
	public List<UserAssignedLocationDTO> assignedLocationByRole(Integer roleId) {
		Session session = sessionFactory.openSession();
		List<UserAssignedLocationDTO> userAssignedLocationDTOS = new ArrayList<UserAssignedLocationDTO>();
		try {
			String hql = "select u.id as id, u.username as username, concat(u.first_name, ' ', u.last_name) as name, "
					+ "uca.location_id as locationId, ur.role_id as roleId from core.users u "
					+ "join core.user_role ur on u.id = ur.user_id join core.users_catchment_area uca on "
					+ "u.id = uca.user_id where ur.role_id = "+roleId+";";
			userAssignedLocationDTOS = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("locationId", StandardBasicTypes.INTEGER)
					.addScalar("roleId", StandardBasicTypes.INTEGER)
					.setResultTransformer(new AliasToBeanResultTransformer(UserAssignedLocationDTO.class))
					.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return userAssignedLocationDTOS;
	}

	@Override
	public int updatePassword(ChangePasswordDTO dto) {
		Session session = sessionFactory.openSession();
		int result = 0;
		try {
			String sql = "update core.users set password = :password where username = :username";
			Query query = session.createSQLQuery(sql)
					.setString("password", dto.getPassword())
					.setString("username", dto.getUsername());
			result = query.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return result;
	}

	public int deleteCatchmentAreas(List<Integer> ids) {
		Session session = sessionFactory.openSession();
		int result = 0;
		try {
			String sql = "delete from core.users_catchment_area where id in (:ids)";
			Query query = session.createSQLQuery(sql)
					.setParameterList("ids", ids);
			result = query.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return result;
	}

	@Override
	public <T> List<T> getChildUserByParentUptoUnion(Integer userId, String roleName) {
		Session session = sessionFactory.openSession();
		List<T> users = new ArrayList<T>();
		try {
			String hql = "with sk as (select distinct(u.*) from core.users u "
					+ "join core.user_branch ub on ub.user_id = u.id join core.user_role ur on ur.user_id = u.id "
					+ "join core.role r on r.id = ur.role_id where ub.branch_id in ( "
					+ "select branch_id from core.user_branch where user_id = :userId) and r.name = '"+roleName+"' "
					+ ") select distinct sk.id id, sk.username username, sk.first_name firstName, "
					+ "sk.last_name lastName, sk.mobile mobile, "
					+ "(select string_agg(b.name, ', ') from core.user_branch ub "
					+ "join core.branch b on ub.branch_id = b.id where ub.user_id = sk.id) branches, "
					+ "(select string_agg(distinct(split_part(loc_ggp.name, ':', 1)), ', ') from core.users_catchment_area uca1 "
					+ "join core.location loc_c on loc_c.id = uca1.location_id "
					+ "join core.location loc_p on loc_p.id = loc_c.parent_location_id "
					+ "join core.location loc_gp on loc_gp.id = loc_p.parent_location_id "
					+ "join core.location loc_ggp on loc_ggp.id = loc_gp.parent_location_id "
					+ "where uca1.user_id = sk.id) upazilaList, "
					+ "(select string_agg(distinct(split_part(loc_p.name, ':', 1)), ', ') from core.users_catchment_area uca1 "
					+ "join core.location loc_c on loc_c.id = uca1.location_id "
					+ "join core.location loc_p on loc_p.id = loc_c.parent_location_id "
					+ "where uca1.user_id = sk.id) locationList, sk.enabled status, sk.app_version appVersion, "
					+ "coalesce(sk.enable_sim_print, false) enableSimPrint "
					+ "from sk join core.user_branch ub on ub.user_id = sk.id join core.branch b on b.id = ub.branch_id "
					+ "order by upazilaList, firstName, lastName;";

			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("lastName", StandardBasicTypes.STRING)
					.addScalar("mobile", StandardBasicTypes.STRING)
					.addScalar("branches", StandardBasicTypes.STRING)
					.addScalar("upazilaList", StandardBasicTypes.STRING)
					.addScalar("locationList", StandardBasicTypes.STRING)
					.addScalar("status", StandardBasicTypes.BOOLEAN)
					.addScalar("appVersion", StandardBasicTypes.STRING)
					.addScalar("enableSimPrint", StandardBasicTypes.BOOLEAN)
					.setInteger("userId", userId)
					.setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
			users = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return users;
	}

	@Override
	public <T> List<T> getChildUserByParentUptoVillage(Integer userId, String roleName) {
		Session session = sessionFactory.openSession();
		List<T> users = new ArrayList<T>();
		try {
//			String hql = "with recursive loc_tree as (select * from core.location loc1 "
//					+ "where loc1.id in (select location_id from core.users_catchment_area where user_id = :userId) "
//					+ "union all select loc2.* from core.location loc2 "
//					+ "join loc_tree lt on lt.id = loc2.parent_location_id "
//					+ ") select distinct u.id, u.username, u.first_name firstName, u.last_name lastName, u.mobile, "
//					+ "(select string_agg(b.name, ', ') from core.user_branch ub join core.branch b on ub.branch_id = b.id "
//					+ "where ub.user_id = u.id) branches, "
//					+ "(select string_agg(distinct(split_part(loc_c.name, ':', 1)), ', ') from core.users_catchment_area uca1 "
//					+ "join core.location loc_c on loc_c.id = uca1.location_id "
//					+ "where uca1.user_id = u.id) locationList "
//					+ "from loc_tree lt "
//					+ "join core.users_catchment_area uca on lt.id = uca.location_id "
//					+ "join core.users u on u.id = uca.user_id join core.user_role ur on u.id = ur.user_id "
//					+ "join core.role r on r.id = ur.role_id where r.name = '"+roleName+"' order by firstName;";
			String hql = "select * from core.get_ss_by_sk(:userId) order by locationList, firstName, lastName;";

			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("lastName", StandardBasicTypes.STRING)
					.addScalar("mobile", StandardBasicTypes.STRING)
					.addScalar("branches", StandardBasicTypes.STRING)
					.addScalar("locationList", StandardBasicTypes.STRING)
					.addScalar("unionList", StandardBasicTypes.STRING)
					.setInteger("userId", userId)
					.setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
			users = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return users;
	}

	@Override
	public <T> List<T> getLocationByAM(Integer amId, Integer roleId) {
		Session session = sessionFactory.openSession();
		List<T> locations = new ArrayList<T>();

		try {
			String hql = "select _id id, _locationname locationname, _parentlocationid parentlocationid, "
					+ "_locationtagname locationtagname, _users users from core.get_location_by_am(:amId, :roleId);";
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("locationName", StandardBasicTypes.STRING)
					.addScalar("parentLocationId", StandardBasicTypes.INTEGER)
					.addScalar("locationTagName", StandardBasicTypes.STRING)
					.addScalar("users", StandardBasicTypes.STRING)
					.setInteger("amId", amId)
					.setInteger("roleId", roleId)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationDTO.class));
			locations = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return locations;
	}

	@Override
	public <T> List<T> getSSWithoutCatchmentAreaByAM(Integer userId) {
		Session session = sessionFactory.openSession();
		List<T> ssList = new ArrayList<T>();
		try {
			String hql = "select u.id, u.username, u.first_name firstName, u.last_name lastName, u.mobile, "
					+ "(select string_agg(b.name, ', ') from core.user_branch ub2 join core.branch b on ub2.branch_id = b.id "
					+ "where ub2.user_id = u.id) branches from core.users u join core.user_branch ub on ub.user_id = u.id "
					+ "join core.user_role ur on ur.user_id = u.id "
					+ "left join core.users_catchment_area uca on uca.user_id = u.id "
					+ "where ur.role_id = 29 and ub.branch_id in ( "
					+ "select ub1.branch_id from core.user_branch ub1 join core.users u1 on u1.id = ub1.user_id where u1.id = :userId"
					+ ") and uca.user_id is null;";

			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("lastName", StandardBasicTypes.STRING)
					.addScalar("mobile", StandardBasicTypes.STRING)
					.addScalar("branches", StandardBasicTypes.STRING)
					.setInteger("userId", userId)
					.setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
			ssList = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return ssList;
	}

	@Override
	public Integer updateSSParentBySKAndLocation(Integer skId, Integer ssRoleId, List<Integer> locationList) {
		Session session = sessionFactory.openSession();
		Integer totalUpdatedRow = 0;
		try {
			String hql = "update core.users set parent_user_id = :skId where "
					+ "id = any(select distinct uca.user_id from "
					+ "core.users_catchment_area uca join core.user_role ur on "
					+ "ur.user_id = uca.user_id where uca.location_id in(:locationList) "
					+ "and ur.role_id = :ssRoleId and uca.user_id != :skId );";
			Query query = session.createSQLQuery(hql)
					.setInteger("skId", skId)
					.setInteger("ssRoleId", ssRoleId)
					.setParameterList("locationList", locationList);
			totalUpdatedRow = query.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return totalUpdatedRow;
	}

	@Override
	public <T> T findAMByBranchId(Integer branchId) {
		List<T> users = new ArrayList<T>();
		Session session = sessionFactory.openSession();
		String hql = "select u.id id, u.username username, u.first_name firstName, u.last_name lastName from core.users u, core.user_branch ub, core.user_role ur where u.id = ub.user_id and " +
				"u.id = ur.user_id and branch_id = :branchId and ur.role_id = :roleId";
		try {
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.addScalar("username", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("lastName", StandardBasicTypes.STRING)
					.setInteger("branchId", branchId)
					.setInteger("roleId", Roles.AM.getId())
					.setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
			users = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return users!=null && users.size() > 0?users.get(0):null;
	}

	@Override
	public <T> List<T> getLocations(String name, Integer length, Integer start, String orderColumn, String orderDirection) {
		Session session = sessionFactory.openSession();
		List<T> locations = new ArrayList<T>();
		String andName = (name==null || name.equalsIgnoreCase(""))?"":" and l.name ilike '%"+name+"%'";
		try {
			String sql = "select split_part(l.name, ':', 1) as name, split_part(l.description, ':', 1) as description, "
					+ "l.code as code, lt.name locationTagName from core.location l, core.location_tag lt where "
					+ "lt.id = l.location_tag_id" + andName + " order by "+orderColumn+" "+orderDirection + " "
					+ "limit "+length+" offset "+start+";";
			Query query = session.createSQLQuery(sql)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("description", StandardBasicTypes.STRING)
					.addScalar("code", StandardBasicTypes.STRING)
					.addScalar("locationTagName", StandardBasicTypes.STRING)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationDTO.class));
			locations = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return locations;
	}

	@Override
	public <T> T getLocationCount(String name) {
		Session session = sessionFactory.openSession();
		List<T> locationSize = new ArrayList<T>();
		String andName = (name==null || name.equalsIgnoreCase(""))?"":" where name ilike '%"+name+"%'";
		try {
			String sql = "select count(*) totalLocation from core.location" + andName +";";
			locationSize = session.createSQLQuery(sql).addScalar("totalLocation", StandardBasicTypes.INTEGER).list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return locationSize.get(0);
	}

	@Override
	public <T> List<T> getCOVID19Report(String startDate, String endDate, String sql, Integer offset, Integer limit) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("skId", StandardBasicTypes.STRING)
					.addScalar("ssName", StandardBasicTypes.STRING)
					.addScalar("visitNumberToday", StandardBasicTypes.INTEGER)
					.addScalar("numberOfSymptomsFound", StandardBasicTypes.INTEGER)
					.addScalar("numberOfContactPersonFromAbroad", StandardBasicTypes.INTEGER)
					.addScalar("numberOfPersonContactedWithSymptoms", StandardBasicTypes.INTEGER)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("contactPhone", StandardBasicTypes.STRING)
					.addScalar("genderCode", StandardBasicTypes.STRING)
					.addScalar("symptomsFound", StandardBasicTypes.STRING)
					.addScalar("submittedDate", StandardBasicTypes.DATE)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setInteger("offset", offset)
					.setInteger("limit", limit)
					.setResultTransformer(new AliasToBeanResultTransformer(COVID19ReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> T getCOVID19ReportCount(String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql).addScalar("totalRows", StandardBasicTypes.INTEGER);
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report.get(0);
	}

	@Override
	public <T> List<T> getCOVID19ReportBySK(String startDate, String endDate, String sql, Integer offset, Integer limit) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("skId", StandardBasicTypes.STRING)
					.addScalar("ssName", StandardBasicTypes.STRING)
					.addScalar("visitNumberToday", StandardBasicTypes.INTEGER)
					.addScalar("numberOfSymptomsFound", StandardBasicTypes.INTEGER)
					.addScalar("numberOfContactPersonFromAbroad", StandardBasicTypes.INTEGER)
					.addScalar("numberOfPersonContactedWithSymptoms", StandardBasicTypes.INTEGER)
					.addScalar("firstName", StandardBasicTypes.STRING)
					.addScalar("contactPhone", StandardBasicTypes.STRING)
					.addScalar("genderCode", StandardBasicTypes.STRING)
					.addScalar("symptomsFound", StandardBasicTypes.STRING)
					.addScalar("submittedDate", StandardBasicTypes.DATE)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setInteger("offset", offset)
					.setInteger("limit", limit)
					.setResultTransformer(new AliasToBeanResultTransformer(COVID19ReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getElcoReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProviderName", StandardBasicTypes.STRING)
					.addScalar("totalElcoVisited", StandardBasicTypes.INTEGER)
					.addScalar("adolescent", StandardBasicTypes.INTEGER)
					.addScalar("nonAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("userTotalFpMethodUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("userTotalFpMethodUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("newTotalFpMethodUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracNewIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtNewIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherNewIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referNewIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("newTotalFpMethodUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracNewOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtNewOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherNewOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referNewOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("changeTotalFpMethodUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracChangeIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtChangeIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherChangeIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referChangeIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("changeTotalFpMethodUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracChangeOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtChangeOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherChangeOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referChangeOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("reInitiatedTotalFpMethodUserIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracReInitiatedIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtReInitiatedIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherReInitiatedIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referReInitiatedIncludingAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("reInitiatedTotalFpMethodUserOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("bracReInitiatedOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("govtReInitiatedOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("otherReInitiatedOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("referReInitiatedOnlyAdolescent", StandardBasicTypes.INTEGER)
					.addScalar("nsv", StandardBasicTypes.INTEGER)
					.addScalar("tubectomy", StandardBasicTypes.INTEGER)
					.addScalar("condom", StandardBasicTypes.INTEGER)
					.addScalar("pill", StandardBasicTypes.INTEGER)
					.addScalar("implant", StandardBasicTypes.INTEGER)
					.addScalar("iud", StandardBasicTypes.INTEGER)
					.addScalar("injection", StandardBasicTypes.INTEGER)
					.addScalar("totalPermanentFpUser", StandardBasicTypes.INTEGER)
					.addScalar("totalTemporaryFpUser", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(ElcoReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getAggregatedReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("householdCount", StandardBasicTypes.INTEGER)
					.addScalar("bracVo", StandardBasicTypes.INTEGER)
					.addScalar("nvo", StandardBasicTypes.INTEGER)
					.addScalar("householdTotal", StandardBasicTypes.INTEGER)
					.addScalar("latrineCount", StandardBasicTypes.INTEGER)
					.addScalar("populationCount", StandardBasicTypes.INTEGER)
					.addScalar("from0To6", StandardBasicTypes.INTEGER)
					.addScalar("from6to11", StandardBasicTypes.INTEGER)
					.addScalar("from12To17", StandardBasicTypes.INTEGER)
					.addScalar("from18To23", StandardBasicTypes.INTEGER)
					.addScalar("from24To35", StandardBasicTypes.INTEGER)
					.addScalar("from36To59", StandardBasicTypes.INTEGER)
					.addScalar("from0To59", StandardBasicTypes.INTEGER)
					.addScalar("from60To119", StandardBasicTypes.INTEGER)
					.addScalar("from120To227Male", StandardBasicTypes.INTEGER)
					.addScalar("from120To227Female", StandardBasicTypes.INTEGER)
					.addScalar("from120To227Total", StandardBasicTypes.INTEGER)
					.addScalar("from240To419Male", StandardBasicTypes.INTEGER)
					.addScalar("from240To419Female", StandardBasicTypes.INTEGER)
					.addScalar("from240To419Total", StandardBasicTypes.INTEGER)
					.addScalar("from420AndPlusMale", StandardBasicTypes.INTEGER)
					.addScalar("from420AndPlusFemale", StandardBasicTypes.INTEGER)
					.addScalar("from420AndPlusTotal", StandardBasicTypes.INTEGER)
					.addScalar("fingerPrintTaken", StandardBasicTypes.INTEGER)
					.addScalar("reproductiveAgeGroup", StandardBasicTypes.INTEGER)
					.addScalar("activeSk", StandardBasicTypes.INTEGER)
					.addScalar("totalPopulation", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(AggregatedReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getAggregatedBiometricReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("registeredWithBio", StandardBasicTypes.INTEGER)
					.addScalar("eligibleForRegistration", StandardBasicTypes.INTEGER)
					.addScalar("allIdentified", StandardBasicTypes.INTEGER)
					.addScalar("allVerified", StandardBasicTypes.INTEGER)
					.addScalar("allBypass", StandardBasicTypes.INTEGER)
					.addScalar("ancTotalIdentified", StandardBasicTypes.INTEGER)
					.addScalar("ancTotalVerified", StandardBasicTypes.INTEGER)
					.addScalar("ancTotalBypass", StandardBasicTypes.INTEGER)
					.addScalar("pncTotalIdentified", StandardBasicTypes.INTEGER)
					.addScalar("pncTotalVerified", StandardBasicTypes.INTEGER)
					.addScalar("pncTotalBypass", StandardBasicTypes.INTEGER)
					.addScalar("elcoTotalIdentified", StandardBasicTypes.INTEGER)
					.addScalar("elcoTotalVerified", StandardBasicTypes.INTEGER)
					.addScalar("elcoTotalBypass", StandardBasicTypes.INTEGER)
					.addScalar("otherTotalIdentified", StandardBasicTypes.INTEGER)
					.addScalar("otherTotalVerified", StandardBasicTypes.INTEGER)
					.addScalar("otherTotalBypass", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(AggregatedBiometricDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getIndividualBiometricReport(String startDate, String endDate, String sql){
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("providerName", StandardBasicTypes.STRING)
					.addScalar("serviceName", StandardBasicTypes.STRING)
					.addScalar("eventDate", StandardBasicTypes.DATE)
					.addScalar("identified", StandardBasicTypes.STRING)
					.addScalar("verifiedOrBypass", StandardBasicTypes.STRING)
					.addScalar("memberName", StandardBasicTypes.STRING)
					.addScalar("memberId", StandardBasicTypes.STRING)
					.addScalar("branchName", StandardBasicTypes.STRING)
					.setResultTransformer(new AliasToBeanResultTransformer(IndividualBiometricReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getPregnancyReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("totalPregnant", StandardBasicTypes.INTEGER)
					.addScalar("adolescentPregnant", StandardBasicTypes.INTEGER)
					.addScalar("firstTrimesterPregnant", StandardBasicTypes.INTEGER)
					.addScalar("secondTrimesterPregnant", StandardBasicTypes.INTEGER)
					.addScalar("pregnantOldAndNew", StandardBasicTypes.INTEGER)
					.addScalar("normal", StandardBasicTypes.INTEGER)
					.addScalar("cesarean", StandardBasicTypes.INTEGER)
					.addScalar("bracCsba", StandardBasicTypes.INTEGER)
					.addScalar("dnfcs", StandardBasicTypes.INTEGER)
					.addScalar("tbaAndOthers", StandardBasicTypes.INTEGER)
					.addScalar("totalDeliveries", StandardBasicTypes.INTEGER)
					.addScalar("anc1To3", StandardBasicTypes.INTEGER)
					.addScalar("anc4And4Plus", StandardBasicTypes.INTEGER)
					.addScalar("totalAnc", StandardBasicTypes.INTEGER)
					.addScalar("ttProtectedMothers", StandardBasicTypes.INTEGER)
					.addScalar("pnc48SK", StandardBasicTypes.INTEGER)
					.addScalar("pnc48Others", StandardBasicTypes.INTEGER)
					.addScalar("completed42Days", StandardBasicTypes.INTEGER)
					.addScalar("pnc1And2", StandardBasicTypes.INTEGER)
					.addScalar("pnc3And3Plus", StandardBasicTypes.INTEGER)
					.addScalar("totalPnc", StandardBasicTypes.INTEGER)
					.addScalar("pregnancyComplicationReferred", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(PregnancyReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	@Override
	public <T> List<T> getChildNutritionReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("childrenVisited19To36", StandardBasicTypes.INTEGER)
					.addScalar("immunizedChildren18To36", StandardBasicTypes.INTEGER)
					.addScalar("ncdPackage", StandardBasicTypes.INTEGER)
					.addScalar("adolescentPackage", StandardBasicTypes.INTEGER)
					.addScalar("iycfPackage", StandardBasicTypes.INTEGER)
					.addScalar("womenPackage", StandardBasicTypes.INTEGER)
					.addScalar("breastFeedIn1Hour", StandardBasicTypes.INTEGER)
					.addScalar("breastFeedIn24Hour", StandardBasicTypes.INTEGER)
					.addScalar("complementaryFoodAt7Months", StandardBasicTypes.INTEGER)
					.addScalar("pushtikonaInLast24Hour", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(ChildNutritionReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	public <T> List<T> getForumReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("adolescentForumTarget", StandardBasicTypes.INTEGER)
					.addScalar("adolescentForumAchievement", StandardBasicTypes.INTEGER)
					.addScalar("womenForumTarget", StandardBasicTypes.INTEGER)
					.addScalar("womenForumAchievement", StandardBasicTypes.INTEGER)
					.addScalar("ncdForumTarget", StandardBasicTypes.INTEGER)
					.addScalar("ncdForumAchievement", StandardBasicTypes.INTEGER)
					.addScalar("childForumTarget", StandardBasicTypes.INTEGER)
					.addScalar("childForumAchievement", StandardBasicTypes.INTEGER)
					.addScalar("adultForumTarget", StandardBasicTypes.INTEGER)
					.addScalar("adultForumAchievement", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(ForumReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	public <T> List<T> getForumIndividualReport(String startDate, String endDate, String sql) {
		Session session = sessionFactory.openSession();
		List<T> report = new ArrayList<T>();
		try {
			Query query = session.createSQLQuery(sql)
					.addScalar("locationOrProvider", StandardBasicTypes.STRING)
					.addScalar("target", StandardBasicTypes.INTEGER)
					.addScalar("achievement", StandardBasicTypes.INTEGER)
					.addScalar("totalParticipant", StandardBasicTypes.INTEGER)
					.addScalar("serviceSold", StandardBasicTypes.INTEGER)
					.setString("startDate", startDate)
					.setString("endDate", endDate)
					.setResultTransformer(new AliasToBeanResultTransformer(ForumIndividualReportDTO.class));
			report = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return report;
	}

	public <T> List<T> getUniqueLocation(String village, String ward) {
		List<T> locations = null;
		Session session = sessionFactory.openSession();

		try {
			String hql = "select l1.id as id from core.location l1 join core.location l2 on l1.parent_location_id = l2.id"
					+ " where l1.location_tag_id = :villageId and l2.location_tag_id = :unionId and l1.name like concat(:village,':%')"
					+ " and l2.name like concat(:ward,':%');";
			Query query = session.createSQLQuery(hql)
					.addScalar("id", StandardBasicTypes.INTEGER)
					.setString("village", village)
					.setString("ward", ward)
					.setInteger("villageId", VILLAGE_ID)
					.setInteger("unionId", UNION_ID)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationTreeDTO.class));
			locations = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return locations.size()>0?locations:null;
	}

}
