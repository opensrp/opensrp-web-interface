/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.permission;

import java.io.Serializable;
import java.util.Collection;

import org.apache.log4j.Logger;
import org.springframework.security.access.PermissionEvaluator;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;

@Service
public class CustomPermissionEvaluator implements PermissionEvaluator {
	
	private static final Logger logger = Logger.getLogger(CustomPermissionEvaluator.class);
	
	@Override
	public boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission) {
		logger.debug("permission:" + permission.toString());
		logger.debug("targetDomainObject:" + targetDomainObject.toString());
		logger.debug("getAuthorities:" + authentication.getAuthorities());
		
		Collection<? extends GrantedAuthority> role = authentication.getAuthorities();
		for (GrantedAuthority grantedAuthority : role) {
			
			if (grantedAuthority.getAuthority().equalsIgnoreCase(permission.toString())) {
				logger.info("authorized by permission:" + grantedAuthority.getAuthority());
				return true;
			}
		}
		return false;
	}
	
	@Override
	public boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission) {
		return false;
	}
	
}
