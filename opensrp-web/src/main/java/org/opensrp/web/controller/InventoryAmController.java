package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.opensrp.common.dto.StockReportDTO;
import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.dto.RequisitionQueryDto;
import org.opensrp.common.util.Roles;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.dto.StockAdjustDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.ProductService;
import org.opensrp.core.service.RequisitionService;
import org.opensrp.core.service.StockService;
import org.opensrp.core.service.TargetService;
import org.opensrp.core.service.UserService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.BranchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class InventoryAmController {
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private RequisitionService requisitionService;
	
	@Autowired
	private StockService stockService;
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	public BranchUtil branchUtil;

	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "inventoryam/myinventory.html", method = RequestMethod.GET)
	public String myInventory(Model model, Locale locale) {
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
		List<ProductDTO> productInfo = productService
		        .productListByBranchWithCurrentStockWithoutRole(Integer.parseInt(id), 0);
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
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-list-am";
	}
	
	@RequestMapping(value = "inventory/requisition-details/{id}.html", method = RequestMethod.GET)
	public String requisitionDetails(Model model, Locale locale, @PathVariable("id") String id,
	                                 @RequestParam(value = "branch") String branch,
	                                 @RequestParam(value = "branchid") String branchid) {
		//User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		//List<Object[]> branchInfo = branchService.getBranchByUser(branchId, loggedInUser);
		List<RequisitionQueryDto> requisitionList = requisitionService.getRequistionDetailsById(Integer.parseInt(id));
		model.addAttribute("branchInfo", branch);
		model.addAttribute("branchid", branchid);
		model.addAttribute("requisitionList", requisitionList);
		model.addAttribute("requisitionId", requisitionList.get(0).getRequisition_id());
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-details";
	}
	
	@RequestMapping(value = "inventoryam/requisition-add/{id}.html", method = RequestMethod.GET)
	public String addRequisitionAreaManager(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		List<ProductDTO> productListForRequisition = requisitionService.productListFortRequisition(Integer.parseInt(id), 0);
		model.addAttribute("productList", productListForRequisition);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-add-am";
	}
	
	@RequestMapping(value = "inventoryam/stock-in.html", method = RequestMethod.GET)
	public String stockInAreaManager(Model model, Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-in";
	}
	
	@RequestMapping(value = "inventoryam/stock-list/{id}.html", method = RequestMethod.GET)
	public String stockListForAreaManager(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-list";
	}
	
	@RequestMapping(value = "inventoryam/stock-add/{id}.html", method = RequestMethod.GET)
	public String stockAddForAreaManager(Model model, Locale locale, @PathVariable("id") String id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(id, loggedInUser);
		List<ProductDTO> productListOfStock = stockService.getAllProductListForStock();
		model.addAttribute("productList", productListOfStock);
		
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("locale", locale);
		return "inventoryAm/stock-add";
	}
	
	@RequestMapping(value = "inventoryam/product-by-id/{branchid}/{productid}", method = RequestMethod.GET)
	@ResponseBody
	public String userByBranch(Model model, @PathVariable("branchid") String branchid,
	                           @PathVariable("productid") String productid) {
		ProductDTO productStock = stockService
		        .getProductDetailsById(Integer.parseInt(branchid), Integer.parseInt(productid));
		String stockAvailable = String.valueOf(productStock.getStock());
		return stockAvailable;
	}
	
	@RequestMapping(value = "inventoryam/pass-stock.html", method = RequestMethod.GET)
	public String passStock(Model model, Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock";
	}
	
	@RequestMapping(value = "inventoryam/pass-stock-inventory/{id}.html", method = RequestMethod.GET)
	public String passStockInventoryList(Model model, Locale locale, @PathVariable("id") int id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(String.valueOf(id), loggedInUser);
		List<Role> roles = productService.getRoleForProduct();
		model.addAttribute("roles", roles);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/individual-stock/{id}/{skid}.html", method = RequestMethod.GET)
	public String passStockInventoryIndividual(Model model, Locale locale, @PathVariable("id") int id,
	                                           @PathVariable("skid") int skid) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(String.valueOf(id), loggedInUser);
		InventoryDTO userdetails = stockService.getUserAndBrachByuserId(skid);
		List<InventoryDTO> passStockList = stockService.getIndividualStockList(userdetails.getUsername(), id,
		    userdetails.getRoleId());
		model.addAttribute("fullname", userdetails.getFullName());
		model.addAttribute("passIndividualStockList", passStockList);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("id", id);
		model.addAttribute("skid", skid);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock-individual-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss.html", method = RequestMethod.GET)
	public String sellToSsStock(Model model, Locale locale) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Branch> branches = branchService.getBranchByUser(loggedInUser.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss-list/{id}.html", method = RequestMethod.GET)
	public String sellToSsList(Model model, Locale locale, @PathVariable("id") int id) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(String.valueOf(id), loggedInUser);
		List<InventoryDTO> getSkList = stockService.getUserListByBranchWithRole(id, Roles.SK.getId());
		List<InventoryDTO> getProductList = stockService.getProductListByBranchWithRole(id, Roles.SS.getId(), 0);
		model.addAttribute("skList", getSkList);

		model.addAttribute("ssLists", stockService.getsellToSSList(0, id, 0, 0, 0, 0, 0, 0, 200, 0, "", ""));
		model.addAttribute("productList", getProductList);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		model.addAttribute("manager", loggedInUser.getId());
		return "inventoryAm/sell-to-ss-list";
	}
	
	@RequestMapping(value = "inventoryam/individual-ss-sell/{id}/{ssid}.html", method = RequestMethod.GET)
	public String sellToIndividualSs(Model model, Locale locale, @PathVariable("id") int id, @PathVariable("ssid") int ssid) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> branchInfo = branchService.getBranchByUser(String.valueOf(id), loggedInUser);
		InventoryDTO skInformation = stockService.getUserInfoWithSkByUserId(ssid);
		List<InventoryDTO> productStockDetails = stockService.getIndividualStockList(skInformation.getUsername(), id,
		    skInformation.getRoleId());
		model.addAttribute("productList", productStockDetails);
		model.addAttribute("branchInfo", branchInfo);
		model.addAttribute("skName", skInformation.getSKName());
		model.addAttribute("ssName", skInformation.getFullName());
		model.addAttribute("id", id);
		model.addAttribute("ssid", ssid);
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss-individual";
	}
	
	@RequestMapping(value = "inventoryam/stock-report.html", method = RequestMethod.GET)
	public String stockReport(Model model, Locale locale, HttpSession session) {
		model.addAttribute("locale", locale);
		User user = AuthenticationManagerUtil.getLoggedInUser();
		session.setAttribute("branchList", new ArrayList<>(user.getBranches()));
		return "inventoryAm/stock-report";
	}

	@RequestMapping(value = "inventoryam/stock-report-table", method = RequestMethod.GET)
	public String stockReportTable(
			@RequestParam(value="year") String year,
			@RequestParam(value="month") String month,
			@RequestParam(value="branchIds", required = false) String branchIds,
			HttpSession session) {
		String skIds;

		System.out.println("branchIds: "+ branchIds);
		if (StringUtils.isBlank(branchIds)) {
			String branches = branchService.commaSeparatedBranch(new ArrayList<>(AuthenticationManagerUtil.getLoggedInUser().getBranches()));
			skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
		} else {
			skIds = userService.findSKByBranchSeparatedByComma("'{" + branchIds + "}'");
		}
		List<StockReportDTO> report = stockService.getStockReportForAM(year, month, skIds);
		session.setAttribute("amStockReport", report);
		return "inventoryAm/stock-report-table";
	}
	
	@RequestMapping(value = "inventoryam/stock-list/view/{id}.html", method = RequestMethod.GET)
	public String stockInDetails(Model model, Locale locale, @PathVariable("id") long id,
	                             @RequestParam(value = "branch") String branch,
	                             @RequestParam(value = "branchid") String branchId) {
		
		List<InventoryDTO> stockDetails = stockService.getStockInByStockId(id);
		model.addAttribute("stocks", stockDetails);
		model.addAttribute("stockID", stockDetails.get(0).getStockInId());
		model.addAttribute("locale", locale);
		model.addAttribute("branchInfo", branch);
		model.addAttribute("branchId", branchId);
		return "inventoryAm/stock-in-details";
	}
	
	@RequestMapping(value = "inventoryam/pass-stock-inventory/view/{branch_id}/{id}.html", method = RequestMethod.GET)
	public String passStockDetails(Model model, Locale locale, @PathVariable("branch_id") int branchId,
	                               @PathVariable("id") int userId) {
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("type", "'PASS'");
		model.addAttribute("titleType", "Pass stock ");
		model.addAttribute("user", stockService.getUserAndBrachByuserId(userId));
		model.addAttribute("locale", locale);
		return "inventoryAm/user-wise-stock-pass-sell";
	}
	
	@RequestMapping(value = "inventoryam/ss-sales/view/{branch_id}/{id}.html", method = RequestMethod.GET)
	public String selltoSSDetails(Model model, Locale locale, @PathVariable("branch_id") int branchId,
	                              @PathVariable("id") int userId) {
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("titleType", "Sell");
		model.addAttribute("type", "'SELL'");
		model.addAttribute("user", stockService.getUserAndBrachByuserId(userId));
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		model.addAttribute("manager", loggedInUser.getId());
		return "inventoryAm/user-wise-stock-pass-sell";
	}
	
	@RequestMapping(value = "inventory/adjust-history-list.html", method = RequestMethod.GET)
	public String adjustHistoryList(Model model, Locale locale) {
		
		model.addAttribute("branches", branchUtil.getBranches());
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		Set<Role> roles = loggedInUser.getRoles();
		String roleName = "";
		for (Role role : roles) {
			roleName = role.getName();
		}
		model.addAttribute("roleName", roleName);
		model.addAttribute("locale", locale);
		return "inventoryAm/adjust-history-list";
	}
	
	@RequestMapping(value = "inventory/adjust-history/{id}.html", method = RequestMethod.GET)
	public String adjustHistoryDetailsById(Model model, Locale locale, @PathVariable("id") int id) {
		
		List<StockAdjustDTO> stockAdjustList = stockService.getAdjustHistoryList(id, "", "", "", 0, 10);
		model.addAttribute("stockAdjustObj", stockAdjustList.get(0));
		model.addAttribute("locale", locale);
		return "inventoryAm/adjust-history-details";
	}
	
}
