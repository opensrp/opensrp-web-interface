package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.ReferenceType;
import org.opensrp.common.util.Status;
import org.opensrp.core.dto.StockDTO;
import org.opensrp.core.dto.StockDetailsDTO;
import org.opensrp.core.entity.Stock;
import org.opensrp.core.entity.StockDetails;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class StockMapper {
	
	@Autowired
	private StockService stockService;
	
	public Stock map(StockDTO dto, Stock stock) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		
		Set<StockDetailsDTO> stockDetailsDTOs = dto.getStockDetailsDTOs();
		
		Set<StockDetails> _stockDetails = new HashSet<>();
		
		if (stock.getId() != null) {
			stock.setStockDetails(null);
			stock.setUpdatedBy(user);
			boolean isDelete = stockService.deleteAllByPrimaryKey(stock.getId(), "_stock_details", "stock_id");
			if (!isDelete) {
				return null;
			}
		} else {
			stock.setCreator(user);
			stock.setUuid(UUID.randomUUID().toString());
		}
		Set<Integer> sellTos = dto.getSellTo();
		for (Integer sellTo : sellTos) {
			
			for (StockDetailsDTO stockDetailsDTO : stockDetailsDTOs) {
				StockDetails stockDetails = new StockDetails();
				stockDetails.setBranchId(stockDetailsDTO.getBranchId());
				stockDetails.setCredit(stockDetailsDTO.getCredit());
				stockDetails.setDebit(stockDetailsDTO.getDebit());
				stockDetails.setExpireyDate(stockDetailsDTO.getExpireyDate());
				stockDetails.setReceiveDate(stockDetailsDTO.getReceiveDate());
				stockDetails.setProductId(stockDetailsDTO.getProductId());
				stockDetails.setReferenceType(ReferenceType.valueOf(stockDetailsDTO.getReferenceType()).name());
				stockDetails.setSellOrPassTo(sellTo);
				stockDetails.setTimestamp(System.currentTimeMillis());
				stockDetails.setStatus(Status.valueOf(stockDetailsDTO.getStatus()).name());
				stockDetails.setInvoiceNumber(stockDetailsDTO.getInvoiceNumber());
				stockDetails.setStock(stock);
				stockDetails.setMonth(stockDetailsDTO.getMonth());
				stockDetails.setYear(stockDetailsDTO.getYear());
				stockDetails.setStartDate(stockDetailsDTO.getStartDate());
				_stockDetails.add(stockDetails);
			}
			stock.setStockDetails(_stockDetails);
			
		}
		return stock;
		
	}
	
}
