/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.dao;

import org.opensrp.core.entity.User;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface AccountDao extends Dao<User>, UserDetailsService {
	
	User getByUsername(String username);
}
