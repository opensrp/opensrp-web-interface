package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.opensrp.core.entity.Permission;
import org.opensrp.core.entity.Role;
import org.opensrp.core.service.PermissionService;
import org.opensrp.core.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * <p>
 * The RoleController program implements an application that simply contains the role related
 * information such as(show role list, add role, edit role but no delete operation ).
 * </p>
 * <br/>
 * <h1>Description:</h1> Default role in opensrp which is created at application startup is
 * Admin,Provider and CHCP.<br/>
 * <h1>Admin Role:</h1> Admin is a opensrp web dashboard fully accessible user role. This role is
 * not related to openMRS role. Admin users can do anything in Opensrp web dashboard but they are
 * not able to login from OpenSRP APP or BAHMNI UI. So Admin users are not OpenMRS User. <h1><br/>
 * Provider:</h1> Provider is a OpenMRS role and all users with this role goes to openMRS and can
 * login from openSRP APP. No default access is defined in openSRP dashboard.Provider also can login
 * to the Opensrp web dashboard but their access is depend on the permissions.So Provider users are
 * OpenSRP APP User.<br/>
 * <h1>CHCP:</h1> CHCP is also a OpenMRS Role and user with this role goes to OpenMRS and can login
 * to BAHMNI UI to server CHCP activity. CHCP also can login to the Opensrp web dashboard but their
 * access is depend on the system permissions. So CHCP users are BAHMNI User and can login as
 * OpenSRP APP if he/she is a team member. <br/>
 * <br/>
 * <h1>Customized Role:</h1>
 * <p>
 * All custimized role users acts as defined permission.
 * </p>
 * <br />
 * <b>*all roles default save to loal permanent storage" </b>
 * 
 * @author proshanto.
 * @version 0.1.0
 * @since 2018-03-30
 */
@Controller
public class RoleController {
	
	@Autowired
	private Permission permission;
	
	@Autowired
	private PermissionService permissionService;
	
	@Autowired
	private RoleService roleServiceImpl;
	
	@Autowired
	private Role role;
	
	/**
	 * <p>
	 * showing role list
	 * </p>
	 * 
	 * @param model defines a holder for model attributes.
	 * @param locale is an argument to holds locale.
	 * @return role index page
	 */
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_ROLE_LIST')")
	@RequestMapping(value = "role.html", method = RequestMethod.GET)
	public String roleList(Model model, Locale locale) {
		List<Role> roles = roleServiceImpl.findAll("Role");
		model.addAttribute("roles", roles);
		model.addAttribute("locale", locale);
		return "role/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_ROLE')")
	@RequestMapping(value = "role/add.html", method = RequestMethod.GET)
	public ModelAndView saveRole(ModelMap model, HttpSession session, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("role", new Role());
		int[] permissions = null;
		session.setAttribute("permissions", permissionService.findAll("Permission"));
		session.setAttribute("selectedPermissions", permissions);
		return new ModelAndView("role/add", "command", role);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_ROLE')")
	@RequestMapping(value = "/role/add.html", method = RequestMethod.POST)
	public ModelAndView saveRole(@RequestParam(value = "permissions", required = false) int[] permissions,
	                             @ModelAttribute("role") @Valid Role role, BindingResult binding, ModelMap model,
	                             HttpSession session, Locale locale) throws Exception {
		
		if (permissions != null) {
			role.setPermissions(roleServiceImpl.setPermissions(permissions));
			roleServiceImpl.save(role);
			return new ModelAndView("redirect:/role.html?lang=" + locale);
		} else {
			session.setAttribute("permissions", permissionService.findAll("Permission"));
			session.setAttribute("selectedPermissions", permissions);
			model.addAttribute("errorPermission", "Please Select Permission");
			return new ModelAndView("/role/add");
		}
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_ROLE')")
	@RequestMapping(value = "role/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editRole(ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		Role role = roleServiceImpl.findById(id, "id", Role.class);
		model.addAttribute("role", role);
		int[] permissions = new int[200];
		Set<Permission> getPermissions = role.getPermissions();
		
		int i = 0;
		for (Permission permission : getPermissions) {
			permissions[i] = permission.getId();
			i++;
		}
		session.setAttribute("permissions", permissionService.findAll("Permission"));
		session.setAttribute("selectedPermissions", permissions);
		model.addAttribute("id", id);
		
		return new ModelAndView("role/edit", "command", role);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_ROLE')")
	@RequestMapping(value = "/role/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editRole(@RequestParam(value = "permissions", required = false) int[] permissions,
	                             @ModelAttribute("role") @Valid Role role, BindingResult binding, ModelMap model,
	                             HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		
		if (permissions != null) {
			role.setPermissions(roleServiceImpl.setPermissions(permissions));
			role.setId(id);
			roleServiceImpl.update(role);
			return new ModelAndView("redirect:/role.html?lang=" + locale);
		} else {
			session.setAttribute("permissions", permissionService.findAll("Permission"));
			session.setAttribute("selectedPermissions", permissions);
			model.addAttribute("id", id);
			model.addAttribute("errorPermission", "Please Select Permission");
			return new ModelAndView("role/edit", "command", role);
		}
		
	}
	
}
