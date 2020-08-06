package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import org.opensrp.core.entity.Role;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class InventoryAMController {
	@RequestMapping(value = "inventoryam/myinventory.html", method = RequestMethod.GET)
	public String myInventory(Model model,Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/my-inventory";
	}
	
	
	@RequestMapping(value = "inventoryam/myinventory-list/{id}.html", method = RequestMethod.GET)
	public String myInventoryList(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/my-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/requisition.html", method = RequestMethod.GET)
	public String requisitionAreaManager(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-am";
	}
	
	@RequestMapping(value = "inventoryam/requisition-list/{id}.html", method = RequestMethod.GET)
	public String requisitionListForAreaManager(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/requisition-list-am";
	}
	
	@RequestMapping(value = "inventoryam/requisition-add/{id}.html", method = RequestMethod.GET)
	public String addRequisitionAreaManager(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
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
	
	@RequestMapping(value = "inventoryam/individual-stock/{id}.html", method = RequestMethod.GET)
	public String passStockInventoryIndividual(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/pass-stock-individual-inventory-list";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss.html", method = RequestMethod.GET)
	public String sellToSsStock(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss";
	}
	
	@RequestMapping(value = "inventoryam/sell-to-ss/{id}.html", method = RequestMethod.GET)
	public String sellToSsList(Model model, Locale locale, @PathVariable("id") int id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		return "inventoryAm/sell-to-ss-list";
	}
}
