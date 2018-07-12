/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.dao;

import java.io.Serializable;
import java.util.List;

import org.apache.log4j.Logger;
import org.opensrp.acl.entity.User;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("accountDao")
public class AclAccountDao extends AbstractAclDao<User> implements UserDao {
	
	private static final Logger logger = Logger.getLogger(AclAccountDao.class);
	
	@Override
	public User getByUsername(String username) {
		return (User) getSession().getNamedQuery("account.byUsername").setParameter("username", username).uniqueResult();
	}
	
	@Override
	@Transactional
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		User account = null;
		try {
			account = getByUsername(username);
			logger.info("username:" + account.getAuthorities().toString());
		}
		catch (Exception e) {
			logger.error("account null: " + e);
		}
		return account;
	}
	
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
