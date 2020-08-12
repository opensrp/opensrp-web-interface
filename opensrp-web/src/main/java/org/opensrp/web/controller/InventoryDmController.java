package org.opensrp.web.controller;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryDmController {

	@RequestMapping(value = "inventorydm/products-list.html", method = RequestMethod.GET)
	public String productsList(Model model,Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryDm/products-list";
	}
	
	@RequestMapping(value = "inventorydm/add-product.html", method = RequestMethod.GET)
	public String addProduct(Model model,Locale locale) {
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
