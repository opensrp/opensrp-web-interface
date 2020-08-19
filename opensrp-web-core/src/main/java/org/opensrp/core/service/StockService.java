/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.opensrp.common.util.ReferenceType;
import org.opensrp.common.util.Status;
import org.opensrp.core.dto.StockDTO;
import org.opensrp.core.dto.StockDetailsDTO;
import org.opensrp.core.entity.Stock;
import org.opensrp.core.entity.StockDetails;
import org.opensrp.core.entity.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class StockService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(StockService.class);
	
	public StockService() {
		
	}
	
	@Transactional
	public <T> Integer saveAll(StockDTO dto) throws Exception {
		Session session = getSessionFactory().openSession();
		Transaction tx = null;
		Integer returnValue = null;
		
		try {
			tx = session.beginTransaction();
			
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User user = (User) auth.getPrincipal();
			Set<StockDetailsDTO> stockDetailsDTOs = dto.getStockDetailsDTOs();
			Set<Integer> sellTos = dto.getSellTo();
			int number = new Random().nextInt(999999);
			String stockId = dto.getStockId() + String.format("%06d", number);
			for (Integer sellTo : sellTos) {
				Stock stock = findById(dto.getId(), "id", Stock.class);
				if (stock == null) {
					stock = new Stock();
				}
				if (stock.getId() != null) {
					stock.setStockDetails(null);
					stock.setUpdatedBy(user);
					boolean isDelete = deleteAllByPrimaryKey(stock.getId(), "_stock_details", "stock_id");
					if (!isDelete) {
						return null;
					}
				} else {
					stock.setCreator(user);
					stock.setUuid(UUID.randomUUID().toString());
				}
				Set<StockDetails> _stockDetails = new HashSet<>();
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
					stockDetails.setStockInId(stockId);
					stockDetails.setStartDate(stockDetailsDTO.getStartDate());
					_stockDetails.add(stockDetails);
					
				}
				stock.setStockDetails(_stockDetails);
				session.saveOrUpdate(stock);
				
			}
			
			if (!tx.wasCommitted())
				tx.commit();
			
			returnValue = 1;
		}
		catch (HibernateException e) {
			tx.rollback();
			logger.error(e);
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
		}
		return returnValue;
	}
}
