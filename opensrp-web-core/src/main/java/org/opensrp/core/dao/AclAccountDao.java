/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.dao;

import java.io.Serializable;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.UserService;
import org.opensrp.core.util.FacilityHelperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("accountDao")
public class AclAccountDao extends AbstractAclDao<User> implements AccountDao {
	
	private static final Logger logger = Logger.getLogger(AclAccountDao.class);
	
	
	@Autowired
	private SessionFactory sessionFactory;
	@Override
	public User getByUsername(String username) {
		Session session = sessionFactory.openSession();
		try{
		return (User) session.getNamedQuery("account.byUsername").setParameter("username", username).uniqueResult();
		}catch(Exception e){
			e.printStackTrace();
			
		}finally{
			session.close();
		}
		return null;
	}
	
	@Override
	@Transactional
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		User account = null;
		try {
			logger.info("usernameAndPassword:" + username);
			
			System.err.println("login start:"+username+"-"+ System.currentTimeMillis());
			account = getByUsername(username);
			System.err.println("login end:"+username+"-"+ System.currentTimeMillis());
		}
		catch (Exception e) {
			logger.error("account null: " + e);
		}
		return account;
	}
	
	public JSONObject convertStringToJSONObject(String inputString) throws JSONException{
		JSONObject outputJSONObject = null;
		outputJSONObject = new JSONObject(inputString);
		return outputJSONObject;
	}
	
	public JSONArray convertStringToJSONArray(String inputString) throws JSONException{
		JSONArray outputJSONArray = null;
		outputJSONArray = new JSONArray(inputString);
		return outputJSONArray;
	}
	
	private static String xAuthToken = "13f983a019cb9fe661a77d251daa63f70b894bd2843bd76b7cef4f732bd7739e";
	private static String clientId = "151880";
	
	
	@Override
	public void create(User t) {
	}
	
	@Override
	public User get(Serializable id) {
		return null;
	}
	
	@Override
	public User load(Serializable id) {
		return null;
	}
	
	@Override
	public List<User> getAll() {
		return null;
	}
	
	@Override
	public void update(User t) {
	}
	
	@Override
	public void delete(User t) {
	}
	
	@Override
	public void deleteById(Serializable id) {
	}
	
	@Override
	public void deleteAll() {
	}
	
	@Override
	public long count() {
		return 0;
	}
	
	@Override
	public boolean exists(Serializable id) {
		return false;
	}
}
