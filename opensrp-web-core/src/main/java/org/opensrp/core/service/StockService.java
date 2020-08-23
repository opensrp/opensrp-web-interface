/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.InventoryDTO;
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
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getStockInList(int branchId, String startDate, String endDate, String invoiceNumber,
	                                         String stockInId, int division, int district, int upazila, int userId,
	                                         Integer length, Integer start, String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> dtos = new ArrayList<>();
		try {
			String hql = "select id,invoice_number invoiceNumber,stock_in_id stockInId,receive_date receiveDate,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName from  core.stock_in_list(:branchId,:startDate,:endDate,:invoiceNumber,:stockInId,:division,:district,:upazila,:userId,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
			        .addScalar("invoiceNumber", StandardBasicTypes.STRING).addScalar("stockInId", StandardBasicTypes.STRING)
			        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).setInteger("branchId", branchId)
			        .setString("startDate", startDate).setString("endDate", endDate)
			        .setString("invoiceNumber", invoiceNumber).setString("stockInId", stockInId)
			        .setInteger("division", division).setInteger("district", district).setInteger("upazila", upazila)
			        .setInteger("userId", userId).setInteger("length", length).setInteger("start", start)
			        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			dtos = query.list();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int getStockInListCount(int branchId, String startDate, String endDate, String invoiceNumber, String stockInId,
	                               int division, int district, int upazila, int userId) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select  * from core.stock_in_count(:branchId,:startDate,:endDate,:invoiceNumber,:stockInId,:division,:district,:upazila,:userId)";
			Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setString("startDate", startDate)
			        .setString("endDate", endDate).setString("invoiceNumber", invoiceNumber)
			        .setString("stockInId", stockInId).setInteger("division", division).setInteger("district", district)
			        .setInteger("upazila", upazila).setInteger("userId", userId);
			total = (BigInteger) query.uniqueResult();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return total.intValue();
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getPassStockUserList(int branchId, String name, int roleId, Integer length, Integer start,
	                                               String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> dtos = new ArrayList<>();
		try {
			String hql = "select id,role_name roleName,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName  from core.pass_stock_user_list_by_role_branch(:branchId,:roleId,:name,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
			        .addScalar("roleName", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).setInteger("branchId", branchId)
			        .setInteger("roleId", roleId).setString("name", name).setInteger("length", length)
			        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			dtos = query.list();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int getPassStockUserListCount(int branchId, int roleId, String name) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select  * from core.pass_stock_user_list_by_role_branch_count(:branchId,:roleId,:name)";
			Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setInteger("roleId", roleId)
			        .setString("name", name);
			total = (BigInteger) query.uniqueResult();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return total.intValue();
	}
	
	public JSONObject getStockInListDataOfDataTable(Integer draw, int patientCount, List<InventoryDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", patientCount);
		response.put("recordsFiltered", patientCount);
		JSONArray array = new JSONArray();
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(dto.getId());
			patient.put(dto.getReceiveDate());
			patient.put(dto.getInvoiceNumber());
			patient.put(dto.getStockInId());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			patient.put("" + dto.getFullName());
			String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"view/"
			        + dto.getId() + "/details.html\">View details</a> </div>";
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	public JSONObject getPassStockUserListDataOfDataTable(Integer draw, int passStockUserCount, List<InventoryDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", passStockUserCount);
		response.put("recordsFiltered", passStockUserCount);
		JSONArray array = new JSONArray();
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(dto.getFullName());
			patient.put(dto.getRoleName());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			
			String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"view/"
			        + dto.getId() + "/details.html\">Pass stock</a> </div>";
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getsellToSSList(int branchId, int skId, int division, int district, int upazila, int year,
	                                          int month, Integer length, Integer start, String orderColumn,
	                                          String orderDirection) {
		
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> dtos = new ArrayList<>();
		try {
			String hql = "select ss_id id,sell_amount salesPrice, purchase_amount purchasePrice, sk_name SKName,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName from core.sell_report(:branchId,:skId,:division,:district,:upazila,:year,:month,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
			        .addScalar("salesPrice", StandardBasicTypes.FLOAT).addScalar("purchasePrice", StandardBasicTypes.FLOAT)
			        .addScalar("SKName", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).setInteger("branchId", branchId)
			        .setInteger("skId", skId).setInteger("division", division).setInteger("district", district)
			        .setInteger("upazila", upazila).setInteger("year", year).setInteger("month", month)
			        .setInteger("length", length).setInteger("start", start)
			        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			dtos = query.list();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return dtos;
	}
	
	@Transactional
	public int getsellToSSListCount(int branchId, int skId, int division, int district, int upazila, int year, int month) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select * from core.sell_report_count(:branchId,:skId,:division,:district,:upazila,:year,:month)";
			Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setInteger("skId", skId)
			        .setInteger("division", division).setInteger("district", district).setInteger("upazila", upazila)
			        .setInteger("year", year).setInteger("month", month);
			
			total = (BigInteger) query.uniqueResult();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return total.intValue();
	}
	
	public JSONObject getSellToSSListDataOfDataTable(Integer draw, int sellToSSCount, List<InventoryDTO> dtos, int roleId)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", sellToSSCount);
		response.put("recordsFiltered", sellToSSCount);
		JSONArray array = new JSONArray();
		
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			
			patient.put(dto.getFullName());
			if (roleId == 28) {
				patient.put("SS"); // for am
			}
			patient.put(dto.getSKName());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			if (roleId != 28) {
				patient.put("0"); // target amount for DIvM
			}
			patient.put(dto.getSalesPrice());
			if (roleId != 28) {
				patient.put(dto.getPurchasePrice()); // for DIvM
			}
			if (roleId == 28) {
				String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"individual-ss-sell/"
				        + dto.getId() + "/" + dto.getId() + ".html\"><strong>Sell Products </strong></a> </div>";
				
				patient.put(view);
			} else {
				String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"individual-ss-sell/"
				        + dto.getId() + "/" + dto.getId() + ".html\"><strong>View details </strong></a> </div>";
				patient.put(view);
			}
			array.put(patient);
			
		}
		response.put("data", array);
		return response;
	}
	
}
