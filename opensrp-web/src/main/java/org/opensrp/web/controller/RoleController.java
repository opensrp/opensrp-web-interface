package org.opensrp.web.controller;

import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.opensrp.acl.entity.Permission;
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.service.impl.PermissionServiceImpl;
import org.opensrp.acl.service.impl.RoleServiceImpl;
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

@Controller
public class RoleController {
	
	@Autowired
	private Permission permission;
	
	@Autowired
	private PermissionServiceImpl permissionService;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	@Autowired
	private Role role;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_ROLE')")
	@RequestMapping(value = "role.html", method = RequestMethod.GET)
	public String roleList(Model model) {
		List<Role> roles = roleServiceImpl.findAll("Role");
		model.addAttribute("roles", roles);
		return "role/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_ROLE')")
	@RequestMapping(value = "role/add.html", method = RequestMethod.GET)
	public ModelAndView saveRole(ModelMap model, HttpSession session) {
		
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
	                             HttpSession session) throws Exception {
		
		if (permissions != null) {
			role.setPermissions(roleServiceImpl.setPermissions(permissions));
			roleServiceImpl.save(role);
			return new ModelAndView("redirect:/role.html");
		} else {
			session.setAttribute("permissions", permissionService.findAll("Permission"));
			session.setAttribute("selectedPermissions", permissions);
			model.addAttribute("errorPermission", "Please Select Permission");
			return new ModelAndView("/role/add");
		}
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_ROLE')")
	@RequestMapping(value = "role/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editRole(ModelMap model, HttpSession session, @PathVariable("id") int id) {
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
	                             HttpSession session, @PathVariable("id") int id) {
		
		if (permissions != null) {
			role.setPermissions(roleServiceImpl.setPermissions(permissions));
			role.setId(id);
			roleServiceImpl.update(role);
			return new ModelAndView("redirect:/role.html");
		} else {
			session.setAttribute("permissions", permissionService.findAll("Permission"));
			session.setAttribute("selectedPermissions", permissions);
			model.addAttribute("id", id);
			model.addAttribute("errorPermission", "Please Select Permission");
			return new ModelAndView("role/edit", "command", role);
		}
		
	}
	
}
