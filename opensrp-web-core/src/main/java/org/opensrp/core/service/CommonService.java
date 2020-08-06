/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.opensrp.common.interfaces.DatabaseRepository;
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
	
	@Transactional
	public <T> T save(T t) throws Exception {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		
		try {
			tx = session.beginTransaction();
			session.saveOrUpdate(t);
			logger.info("saved successfully: " + t.getClass().getName());
			
			if (!tx.wasCommitted())
				tx.commit();
		}
		catch (HibernateException e) {
			tx.rollback();
			logger.error(e);
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
		}
		return t;
	}
	
	@Transactional
	public <T> T update(T t) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		
		try {
			tx = session.beginTransaction();
			session.saveOrUpdate(t);
			logger.info("updated successfully");
			if (!tx.wasCommitted())
				tx.commit();
			
		}
		catch (HibernateException e) {
			
			tx.rollback();
			logger.error(e.getMessage());
		}
		finally {
			session.close();
		}
		return t;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findById(Long id, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			criteria.add(Restrictions.eq(fieldName, id));
			result = criteria.list();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}
		return result.size() > 0 ? (T) result.get(0) : null;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		Session session = sessionFactory.openSession();
		List<T> result = new ArrayList<T>();
		try {
			Criteria criteria = session.createCriteria(className);
			criteria.add(Restrictions.eq(fieldName, value));
			result = criteria.list();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}
		return result.size() > 0 ? (T) result.get(0) : null;
	}
	
}
