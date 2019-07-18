package org.opensrp.web.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.opensrp.acl.permission.CustomPermissionEvaluator;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class AuthenticationManagerUtil {
	
	private static final Logger logger = Logger.getLogger(AuthenticationManagerUtil.class);

	public static boolean isPermitted(String permissionName){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomPermissionEvaluator customPermissionEvaluator = new CustomPermissionEvaluator();		
		return customPermissionEvaluator.hasPermission(auth, "returnObject", permissionName);		
	}
	// static method to return logged in user
	//april_17_2019
	public static User getLoggedInUser(){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)auth.getPrincipal();
		logger.info("\nLogger-in User :"+user.toString()+"\n");
		return user;
	}
	
	// static method to return logged in user roles
	public static List<String> getLoggedInUserRoles(){
		User user = getLoggedInUser();
		List<String> roleList = new ArrayList<String>();
		Set<Role> roles =user.getRoles();
		for(Role role : roles){
			logger.info("\nLogger-in User role :"+role.toString()+"\n");
			String roleName = role.getName();
			if(roleName!= null && !roleName.isEmpty()){
				roleList.add(roleName);
			}
		}
		logger.info("\nLogger-in User roleList :"+roleList.toString()+"\n");
		return roleList;
	}
	
	// static method to return if logged in user is Admin or not
	public static boolean isAdmin(){
		List<String> roleList = getLoggedInUserRoles();
		if(roleList.contains("Admin")){
			logger.info("\nIsAdmin :"+"True\n");
			return true;
		}
		logger.info("\nIsAdmin :"+"False\n");
		return false;
	}
	
	// static method to return if logged in user is CHCP or not
		public static boolean isProvider(){
			List<String> roleList = getLoggedInUserRoles();
			if(roleList.contains("Provider")){
				logger.info("\nIsProvider :"+"True\n");
				return true;
			}
			logger.info("\nIsProvider :"+"False\n");
			return false;
		}
		
	// static method to return if logged in user is CHCP or not
	public static boolean isCHCP(){
		List<String> roleList = getLoggedInUserRoles();
		if(roleList.contains("CHCP")){
			logger.info("\nIsCHCP :"+"True\n");
			return true;
		}
		logger.info("\nIsCHCP :"+"False\n");
		return false;
	}
	
	public static void showRoleAndstatus(){
		logger.info("\nIsAdmin : "+isAdmin()
				+"\nIsCHCP : "+isCHCP()
				+"\nIsProvider : "+isProvider()
				+"\n");
	}

	public static boolean isUHFPO() {
		List<String> roleList = getLoggedInUserRoles();
		if (roleList.contains("UHFPO")) {
			logger.info("\nIsUHFPO:"+"True\n");
			return  true;
		}
		logger.info("\nIsUHFPO :"+"False\n");
		return false;
	}
}
