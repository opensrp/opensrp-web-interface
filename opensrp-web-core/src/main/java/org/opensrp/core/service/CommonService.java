/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public abstract class CommonService {
	
	private static final Logger logger = Logger.getLogger(CommonService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	public CommonService() {
		
	}
	
	public Session getSessionFactory() {
		return sessionFactory.getCurrentSession();
	}
	
	@Transactional
	public <T> T save(T t) throws Exception {
		Session session = getSessionFactory();
		
		session.saveOrUpdate(t);
		
		logger.info("saved successfully: " + t.getClass().getName());
		
		return t;
	}
	
	@Transactional
	public <T> T update(T t) {
		Session session = getSessionFactory();
		
		session.saveOrUpdate(t);
		logger.info("updated successfully");
		
		return t;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findById(Long id, String fieldName, Class<?> className) {
		Session session = getSessionFactory();
		List<T> result = new ArrayList<T>();
		
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, id));
		result = criteria.list();
		
		return result.size() > 0 ? (T) result.get(0) : null;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		Session session = getSessionFactory();
		List<T> result = new ArrayList<T>();
		
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		result = criteria.list();
		
		return result.size() > 0 ? (T) result.get(0) : null;
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		Session session = getSessionFactory();
		
		boolean returnValue = false;
		
		logger.info("deleting: " + t.getClass().getName());
		session.delete(t);
		
		returnValue = true;
		
		return returnValue;
	}
	
	@Transactional
	public <T> boolean deleteAllByPrimaryKey(T t, String tableName, String fieldName) {
		Session session = getSessionFactory();
		
		boolean returnValue = false;
		String hql = "delete from core." + tableName + " where " + fieldName + "=" + t;
		Query query = session.createSQLQuery(hql);
		query.executeUpdate();
		
		returnValue = true;
		
		return returnValue;
	}
	
	@Transactional
	public <T> void deleteAllByPrimaryKey(T t, String tableName, String fieldName, Session session) {
		
		String hql = "delete from core." + tableName + " where " + fieldName + "=" + t;
		Query query = session.createSQLQuery(hql);
		query.executeUpdate();
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findByKeys(Map<String, Object> fieldValues, Class<?> className) {
		Session session = getSessionFactory();
		List<T> result = null;
		
		Criteria criteria = session.createCriteria(className);
		for (Map.Entry<String, Object> entry : fieldValues.entrySet()) {
			criteria.add(Restrictions.eq(entry.getKey(), entry.getValue()));
		}
		result = criteria.list();
		
		return result.size() > 0 ? (T) result.get(0) : null;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Location> getLocationByTagId(int tagId) {
		String sqlQuery = "SELECT location.id id, split_part(location.name, ':', 1) as name from core.location "
		        + " WHERE location_tag_id=:location_tag_id";
		
		Session session = getSessionFactory();
		
		List<Location> results = new ArrayList<>();
		
		Query query = session.createSQLQuery(sqlQuery).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("name", StandardBasicTypes.STRING).setInteger("location_tag_id", tagId)
		        .setResultTransformer(new AliasToBeanResultTransformer(Location.class));
		results = query.list();
		
		return results;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Location> getLocationByParentId(int parentId) {
		String sqlQuery = "SELECT location.id id, split_part(location.name, ':', 1) as name from core.location "
		        + " WHERE parent_location_id=:parentId";
		
		Session session = getSessionFactory();
		
		List<Location> results = new ArrayList<>();
		
		Query query = session.createSQLQuery(sqlQuery).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("name", StandardBasicTypes.STRING).setInteger("parentId", parentId)
		        .setResultTransformer(new AliasToBeanResultTransformer(Location.class));
		results = query.list();
		
		return results;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Branch> getLocationByLocationId(int parentId) {
		String sqlQuery = "select b.id,b.code,b.name from core.branch as b where b.division =:parentId or b.district =:parentId or b.upazila = :parentId";
		
		Session session = getSessionFactory();
		
		List<Branch> results = new ArrayList<>();
		
		Query query = session.createSQLQuery(sqlQuery).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("code", StandardBasicTypes.STRING).addScalar("name", StandardBasicTypes.STRING)
		        .setInteger("parentId", parentId).setResultTransformer(new AliasToBeanResultTransformer(Branch.class));
		results = query.list();
		
		return results;
		
	}
}
