package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RequisitionService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryAmController {
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private RequisitionService requisitionService;
	
	@RequestMapping(value = "inventoryam/myinventory.html", method = RequestMethod.GET)
	public String myInventory(Model model,Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "inventoryAm/my-inventory";
	}
	
	
	@RequestMapping(value = "inventoryam/myinventory-list/{id}.html", method = RequestMethod.GET)
	public String myInventoryList(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		List<ProductDTO> productInfo = productService.productListByBranchWithCurrentStock(Integer.parseInt(id), 0);
//		for (ProductDTO productDTO : productInfo) {
//			System.out.println(productDTO.getName());
//			System.out.println(productDTO.getDescription());
//			System.out.println(productDTO.getId());
//		}
		model.addAttribute("productList", productInfo);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/my-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/requisition.html", method = RequestMethod.GET)
	public String requisitionAreaManager(Model model, Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-am";
	}
	
	@RequestMapping(value = "inventoryam/requisition-list/{id}.html", method = RequestMethod.GET)
	public String requisitionListForAreaManager(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		int roleId = 0;
		for (Role role : loggedInUser.getRoles()) {
			roleId = role.getId();
		}
		List<ProductDTO> requisitionList = requisitionService.productListFortRequisition(Integer.parseInt(id), roleId);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-list-am";
	}
	
	@RequestMapping(value = "inventoryam/requisition-add/{id}.html", method = RequestMethod.GET)
	public String addRequisitionAreaManager(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-add-am";
	}
	
	@RequestMapping(value = "inventoryam/stock-in.html", method = RequestMethod.GET)
	public String stockInAreaManager(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-in";
	}
	
	@RequestMapping(value = "inventoryam/stock-list/{id}.html", method = RequestMethod.GET)
	public String stockListForAreaManager(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-list";
	}
	
	@RequestMapping(value = "inventoryam/stock-add/{id}.html", method = RequestMethod.GET)
	public String stockAddForAreaManager(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-add";
	}
	
	@RequestMapping(value = "inventoryam/pass-stock.html", method = RequestMethod.GET)
	public String passStock(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock";
	}
	
	@RequestMapping(value = "inventoryam/pass-stock-inventory/{id}.html", method = RequestMethod.GET)
	public String passStockInventoryList(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/individual-stock/{id}/{skid}.html", method = RequestMethod.GET)
	public String passStockInventoryIndividual(Model model, Locale locale, @PathVariable("id") int id, @PathVariable("skid") int skid) {
		model.addAttribute("id", id);
		model.addAttribute("skid", skid);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock-individual-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss.html", method = RequestMethod.GET)
	public String sellToSsStock(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss-list/{id}.html", method = RequestMethod.GET)
	public String sellToSsList(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss-list";
	}
	
	@RequestMapping(value = "inventoryam/individual-ss-sell/{id}/{ssid}.html", method = RequestMethod.GET)
	public String sellToIndividualSs(Model model, Locale locale, @PathVariable("id") int id, @PathVariable("ssid") int ssid) {
		model.addAttribute("id", id);
		model.addAttribute("ssid", ssid);
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss-individual";
	}
	
	@RequestMapping(value = "inventoryam/stock-report.html", method = RequestMethod.GET)
	public String stockReport(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-report";
	}
}
