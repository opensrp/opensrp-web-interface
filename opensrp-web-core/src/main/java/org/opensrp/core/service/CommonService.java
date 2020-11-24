/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.dto.BranchDTO;
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
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> List<T> findAllByKey(String value, String fieldName, Class<?> className) {
		Session session = getSessionFactory();
		List<T> result = new ArrayList<T>();
		
		Criteria criteria = session.createCriteria(className);
		criteria.add(Restrictions.eq(fieldName, value));
		result = criteria.list();
		
		return result.size() > 0 ? (List<T>) result : null;
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
	
	@Transactional
	@SuppressWarnings("unchecked")
	public List<TargetCommontDTO> getAllUser(Set<Integer> roleIds, String branchIds) {
		String prefix = "";
		StringBuffer sb = new StringBuffer();
		for (Integer roleId : roleIds) {
			sb.append(prefix);
			prefix = ",";
			sb.append(roleId);
			
		}
		String roles = "'{" + sb + "}'";
		Session session = getSessionFactory();
		List<TargetCommontDTO> result = new ArrayList<>();
		
		String hql = "select user_id userId, branch_id branchId from core.get_userid_for_web_notification(" + roles + ",'{"
		        + branchIds + "}');";
		Query query = session.createSQLQuery(hql).addScalar("userId", StandardBasicTypes.INTEGER)
		        .addScalar("branchId", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	/*****
	 * @param Ids is a comma separated string
	 * @param Ids
	 * @return
	 */
	@Transactional
	@SuppressWarnings("unchecked")
	public List<UserDTO> getUserByRoles(String Ids) {
		Session session = getSessionFactory();
		List<UserDTO> result = new ArrayList<>();
		String hql = "select id,u.first_name firstName,case when u.last_name ='.' then '' else u.last_name  end lastName "
		        + "from core.users as u join core.user_role ur on u.id=ur.user_id where ur.role_id = any('{" + Ids + "}')";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	/*****
	 * @param Ids is a comma separated string
	 * @param Ids
	 * @return
	 */
	@Transactional
	@SuppressWarnings("unchecked")
	public List<UserDTO> getUserByUserIds(String Ids, int roleId) {
		Session session = getSessionFactory();
		List<UserDTO> result = new ArrayList<>();
		String hql = "select id,u.first_name firstName,case when u.last_name ='.' then '' else u.last_name end lastName"
		        + " from core.users as u join core.user_role ur on u.id=ur.user_id "
		        + " join core.user_branch ub on u.id=ub.user_id  "
		        + " where ur.role_id=:roleId and ub.branch_id=any(select branch_id from core.user_branch as ub where ub.user_id= any('{"
		        + Ids + "}')) " + "group by id,u.first_name,u.last_name";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	/*****
	 * @param Ids is a comma separated string
	 * @param Ids
	 * @return
	 */
	@Transactional
	@SuppressWarnings("unchecked")
	public List<BranchDTO> getBranchListByUserIds(String Ids) {
		Session session = getSessionFactory();
		List<BranchDTO> result = new ArrayList<>();
		String hql = "select b.id,b.name,b.code from core.branch as b join core.user_branch ub "
		        + "on b.id=ub.branch_id where ub.user_id= any('{" + Ids + "}')";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("code", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(BranchDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@Transactional
	public int getUserRole(int id) {
		Session session = getSessionFactory();
		UserDTO result = new UserDTO();
		String hql = "select  role_id roleId from core.user_role as ur where ur.user_id=:id";
		Query query = session.createSQLQuery(hql).addScalar("roleId", StandardBasicTypes.INTEGER).setInteger("id", id)
		        .setResultTransformer(new AliasToBeanResultTransformer(UserDTO.class));
		
		result = (UserDTO) query.uniqueResult();
		
		return result.getRoleId();
	}
}
