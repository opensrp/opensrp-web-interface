package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.util.LocationTags;
import org.opensrp.common.util.Roles;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RequisitionService;
import org.opensrp.core.service.StockService;
import org.opensrp.core.service.TargetService;
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
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("locale", locale);
		return "inventoryDm/requisition-list";
	}
	

	@RequestMapping(value = "inventorydm/user-by-branch/{id}", method = RequestMethod.GET)
	public String userByBranch(Model model,@PathVariable("id") int id) {
		//List<UserDTO> userListByBranch= requisitionService.getUserListByBranch(id);
		List<InventoryDTO> userListByBranch= stockService.getUserListByBranchWithRole(id,Roles.AM.getId());
		model.addAttribute("userList", userListByBranch);
		return "inventoryDm/user-list";
	}
	
	@RequestMapping(value = "inventorydm/sk-by-branch/{id}", method = RequestMethod.GET)
	public String skByBranch(Model model,@PathVariable("id") int id) {
		List<InventoryDTO> skListByBranch= stockService.getUserListByBranchWithRole(id,Roles.SK.getId());
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
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		return "inventoryDm/ss-sales-report";
	}
	
}
