package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.util.LocationTags;
import org.opensrp.common.util.ProductType;
import org.opensrp.common.util.Roles;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Product;
import org.opensrp.core.entity.ProductRole;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RequisitionService;
import org.opensrp.core.service.StockService;
import org.opensrp.core.service.TargetService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.BranchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryDmController {
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private RequisitionService requisitionService;
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	private StockService stockService;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	public BranchUtil branchUtil;
	
	@RequestMapping(value = "inventorydm/products-list.html", method = RequestMethod.GET)
	public String productsList(Model model, Locale locale) {
		List<ProductDTO> productList = productService.getAllProductListDetails(ProductType.PRODUCT.name());
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
	
	@RequestMapping(value = "inventorydm/{id}/edit-product.html", method = RequestMethod.GET)
	public String EditProduct(Model model, Locale locale, @PathVariable("id") long id, HttpSession session) {
		List<Role> roles = productService.getRoleForProduct();
		Product product = productService.findById(id, "id", Product.class);
		
		int i = 0;
		int[] selectRoles = new int[10];
		for (ProductRole pRole : product.getProductRole()) {
			selectRoles[i] = pRole.getRole();
			i++;
		}
		
		session.setAttribute("selectRoles", selectRoles);
		session.setAttribute("roles", roles);
		model.addAttribute("roles", roles);
		model.addAttribute("product", product);
		model.addAttribute("locale", locale);
		return "inventoryDm/edit-product";
	}
	
	@RequestMapping(value = "inventorydm/target-list.html", method = RequestMethod.GET)
	public String targetList(Model model, Locale locale) {
		List<ProductDTO> productList = productService.getAllProductListDetails(ProductType.TARGET.name());
		model.addAttribute("productList", productList);
		model.addAttribute("locale", locale);
		return "inventoryDm/target-list";
	}
	
	@RequestMapping(value = "inventorydm/add-target.html", method = RequestMethod.GET)
	public String addTarget(Model model, Locale locale) {
		List<Role> roles = productService.getRoleForProduct();
		model.addAttribute("roles", roles);
		model.addAttribute("locale", locale);
		return "inventoryDm/add-target";
	}
	
	@RequestMapping(value = "inventorydm/{id}/edit-target.html", method = RequestMethod.GET)
	public String EditTarget(Model model, Locale locale, @PathVariable("id") long id, HttpSession session) {
		List<Role> roles = productService.getRoleForProduct();
		Product product = productService.findById(id, "id", Product.class);
		
		int i = 0;
		int[] selectRoles = new int[10];
		for (ProductRole pRole : product.getProductRole()) {
			selectRoles[i] = pRole.getRole();
			i++;
		}
		
		session.setAttribute("selectRoles", selectRoles);
		session.setAttribute("roles", roles);
		model.addAttribute("roles", roles);
		model.addAttribute("product", product);
		model.addAttribute("locale", locale);
		return "inventoryDm/edit-target";
	}
	
	@RequestMapping(value = "inventorydm/requisition-list.html", method = RequestMethod.GET)
	public String requisitonListForDm(Model model, Locale locale, HttpSession session) {
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("branches", branchUtil.getBranches());
		model.addAttribute("locale", locale);
		return "inventoryDm/requisition-list";
	}
	
	@RequestMapping(value = "inventorydm/user-by-branch/{id}", method = RequestMethod.GET)
	public String userByBranch(Model model, @PathVariable("id") int id) {
		//List<UserDTO> userListByBranch= requisitionService.getUserListByBranch(id);
		List<InventoryDTO> userListByBranch = stockService.getUserListByBranchWithRole(id, Roles.AM.getId());
		model.addAttribute("userList", userListByBranch);
		return "inventoryDm/user-list";
	}
	
	@RequestMapping(value = "inventorydm/sk-by-branch/{id}", method = RequestMethod.GET)
	public String skByBranch(Model model, @PathVariable("id") int id) {
		List<InventoryDTO> skListByBranch = stockService.getUserListByBranchWithRole(id, Roles.SK.getId());
		model.addAttribute("skList", skListByBranch);
		return "inventoryDm/sk-list";
	}
	
	@RequestMapping(value = "inventorydm/stock-report.html", method = RequestMethod.GET)
	public String stockReportForDm(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/stock-reports";
	}
	
	@RequestMapping(value = "inventorydm/ss-sales-report.html", method = RequestMethod.GET)
	public String ssSellReportForDm(Model model, HttpSession session, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		
		Set<Role> roles = loggedInUser.getRoles();
		String roleName = "";
		for (Role role : roles) {
			roleName = role.getName();
		}
		
		model.addAttribute("branches", branchUtil.getBranches());
		
		model.addAttribute("roleName", roleName);
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("manager", loggedInUser.getId());
		
		return "inventoryDm/ss-sales-report";
	}
	
	@RequestMapping(value = "inventorydm/view-sales-report/{branch_id}/{id}.html", method = RequestMethod.GET)
	public String selltoSSDetails(Model model, Locale locale, @PathVariable("branch_id") int branchId,
	                              @PathVariable("id") int userId) {
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("titleType", "Sell");
		model.addAttribute("type", "'SELL'");
		model.addAttribute("user", stockService.getUserAndBrachByuserId(userId));
		model.addAttribute("locale", locale);
		return "inventoryDm/user-wise-stock-pass-sell";
	}
	
}
