package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.opensrp.common.dto.UserDTO;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RequisitionService;
import org.opensrp.core.service.RoleService;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryDmController {
	
	@Autowired
	private RoleService roleServiceImpl;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private SearchUtil searchUtil;
	
	@Autowired
	private RequisitionService requisitionService;
	
	@RequestMapping(value = "inventorydm/products-list.html", method = RequestMethod.GET)
	public String productsList(Model model, Locale locale) {
		List<ProductDTO> productList = productService.getAllProductListDetails();
		model.addAttribute("productList", productList);
		model.addAttribute("locale", locale);
		return "inventoryDm/products-list";
	}
	
	@RequestMapping(value = "inventorydm/add-product.html", method = RequestMethod.GET)
	public String addProduct(Model model, Locale locale) {
		List<Role> roles = productService.getRoleForProduct();
		model.addAttribute("roles", roles);
		model.addAttribute("locale", locale);
		return "inventoryDm/add-product";
	}
	
	@RequestMapping(value = "inventorydm/requisition-list.html", method = RequestMethod.GET)
	public String requisitonListForDm(Model model, Locale locale, HttpSession session) {
		List<Branch> branches = branchService.findAll("Branch");
		List<Role> roles = roleServiceImpl.findAll("Role");
		searchUtil.setDivisionAttribute(session);
		model.addAttribute("locale", locale);
		model.addAttribute("roles", roles);
		model.addAttribute("branches", branches);
		return "inventoryDm/requisition-list";
	}
	
	@RequestMapping(value = "inventoryam/user-by-branch/{id}", method = RequestMethod.GET)
	public String userByBranch(Model model, @PathVariable("id") int id) {
		List<UserDTO> userListByBranch = requisitionService.getUserListByBranch(id);
		model.addAttribute("userList", userListByBranch);
		return "inventoryDm/user-list";
	}
	
	@RequestMapping(value = "inventorydm/stock-report.html", method = RequestMethod.GET)
	public String stockReportForDm(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/stock-reports";
	}
	
	@RequestMapping(value = "inventorydm/ss-sales-report.html", method = RequestMethod.GET)
	public String ssSellReportForDm(Model model, HttpSession session, Locale locale) {
		model.addAttribute("locale", locale);
		
		return "inventoryDm/ss-sales-report";
	}
	
}
