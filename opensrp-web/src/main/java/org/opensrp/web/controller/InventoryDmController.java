package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RoleService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryDmController {

	@Autowired
	private RoleService roleServiceImpl;
	
	@Autowired
	private ProductService productService;

	
	@RequestMapping(value = "inventorydm/products-list.html", method = RequestMethod.GET)
	public String productsList(Model model,Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		int roleId = 0;
		for (Role role : loggedInUser.getRoles()) {
			roleId = role.getId();
		}
		model.addAttribute("user", loggedInUser.getRoles());
		model.addAttribute("locale", locale);
		return "inventoryDm/products-list";
	}
	
	@RequestMapping(value = "inventorydm/add-product.html", method = RequestMethod.GET)
	public String addProduct(Model model,Locale locale) {
		List<Role> roles = roleServiceImpl.findAll("Role");
		List<Role> filteredRole = new ArrayList<Role>();
		HashMap<String,String> rolesMap = new HashMap<String,String>();
		rolesMap.put("SK", "SK");
		rolesMap.put("PK", "SK");
		rolesMap.put("SS", "SK");
		rolesMap.put("PA", "PA");
		
		for (Role role : roles) {
			if (rolesMap.containsKey(role.getName())) {
				filteredRole.add(role);
			}
		}
		model.addAttribute("roles", filteredRole);
		model.addAttribute("locale", locale);
		return "inventoryDm/add-product";
	}
	
	@RequestMapping(value = "inventorydm/requisition-list.html", method = RequestMethod.GET)
	public String requisitonListForDm(Model model,Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/requisition-list";
	}
	
	@RequestMapping(value = "inventorydm/stock-report.html", method = RequestMethod.GET)
	public String stockReportForDm(Model model,Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/stock-reports";
	}
	
	@RequestMapping(value = "inventorydm/ss-sales-report.html", method = RequestMethod.GET)
	public String ssSellReportForDm(Model model,Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/ss-sales-report";
	}
	
	
}
