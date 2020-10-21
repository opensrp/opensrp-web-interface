package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BranchService {
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	public <T> int update(T t) throws Exception {
		return repository.update(t);
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		return repository.delete(t);
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> T findOneByKeys(Map<String, Object> fieldValues, Class<?> className) {
		return repository.findByKeys(fieldValues, className);
	}
	
	@Transactional
	public <T> List<T> findAllByKeys(Map<String, Object> fieldValues, Class<?> className) {
		return repository.findAllByKeys(fieldValues, className);
	}
	
	@Transactional
	public <T> T findLastByKeys(Map<String, Object> fieldValues, String orderByFieldName, Class<?> className) {
		return repository.findLastByKey(fieldValues, orderByFieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}
	
	@Transactional
	public <T> T findByForeignKey(int id, String fieldName, String className) {
		return repository.findByForeignKey(id, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Branch> getBranchByUser(Integer user_id) {
		List<Branch> lists = new ArrayList<Branch>();
		Session session = sessionFactory.getCurrentSession();
		String hql = "select b.id,b.name,b.code from core.branch as b join core.user_branch as ub on b.id = ub.branch_id where user_id =:user_id";
		
		Query query = session.createSQLQuery(hql)
		
		.addScalar("id", StandardBasicTypes.INTEGER).addScalar("name", StandardBasicTypes.STRING)
		        .addScalar("code", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(Branch.class));
		lists = query.setInteger("user_id", user_id).list();
		
		return lists;
	}
	
	public String commaSeparatedBranch(List<Branch> branches) {
		String branchIds = "";
		int size = branches.size(), iterate = 0;
		for (Branch branch : branches) {
			iterate++;
			branchIds += branch.getId();
			if (size != iterate)
				branchIds += ", ";
		}
		return branchIds;
	}
	
	public List<Object[]> getBranchByUser(String branchId, User user) {
		List<Object[]> branches = new ArrayList<>();
		if (!branchId.isEmpty()) {
			Branch branch = findById(Integer.parseInt(branchId), "id", Branch.class);
			Object[] obj = new Object[10];
			obj[0] = branch.getId();
			obj[1] = branch.getName();
			obj[2] = branch.getCode();
			branches.add(obj);
		} else {
			for (Branch branch : user.getBranches()) {
				Object[] obj = new Object[10];
				obj[0] = branch.getId();
				obj[1] = branch.getName();
				obj[2] = branch.getCode();
				branches.add(obj);
			}
		}
		return branches;
	}
	
	@Transactional
	public List<Object[]> getUserByBranch(String branchIds, int roleId) {
		Session session = sessionFactory.getCurrentSession();
		List<Object[]> skList = null;
		
		String hql = "select u.id, u.username, concat(u.first_name, ' ', u.last_name), ub.branch_id from core.users u join core.user_role ur on u.id = ur.user_id"
		        + " join core.user_branch ub on u.id = ub.user_id where ur.role_id = :skId and ub.branch_id = any(array["
		        + branchIds + "])";
		skList = session.createSQLQuery(hql).setInteger("skId", roleId).list();
		
		return skList;
	}
}
