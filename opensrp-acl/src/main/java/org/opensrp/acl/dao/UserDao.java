/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.acl.dao;

import org.opensrp.acl.entity.User;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface UserDao extends Dao<User>, UserDetailsService {
	
	User getByUsername(String username);
}
