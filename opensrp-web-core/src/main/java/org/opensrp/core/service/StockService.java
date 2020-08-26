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
import org.opensrp.core.dto.ProductDTO;
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
					stockDetails.setCreator(user);
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
			String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"javascript:;\" onclick='navigateTodetails("+dto.getId()+",\""+dto.getBranchName()+"\",\""+dto.getBranchCode()+"\")'>View details</a> </div>";
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	public JSONObject getPassStockUserListDataOfDataTable(Integer draw, int passStockUserCount, List<InventoryDTO> dtos,
	                                                      int branchId) throws JSONException {
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
			

			String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"javascript:;\" onclick='navigateToPassStock("+dto.getId()+")'>Pass stock</a> </div>";
			/*String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"view/"
			        + dto.getId() + "/details.html\">Pass stock</a> </div>";
			*/

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
	
	public JSONObject getSellToSSListDataOfDataTable(Integer draw, int sellToSSCount, List<InventoryDTO> dtos, int roleId,
	                                                 int branchId) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", sellToSSCount);
		response.put("recordsFiltered", sellToSSCount);
		JSONArray array = new JSONArray();
		
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			if (roleId == 32) {
				String checkBox = "<input type=\"checkbox\" class=\"select-checkbox\" id=\"ss" + dto.getId()+"\" value="+ dto.getId()+">";
				patient.put(checkBox);
			}
			patient.put(dto.getFullName());
			if (roleId == 32) {
				patient.put("SS"); // for am
			}
			patient.put(dto.getSKName());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			if (roleId != 32) {
				patient.put("0"); // target amount for DIvM
			}
			patient.put(dto.getSalesPrice());
			if (roleId != 32) {
				patient.put(dto.getPurchasePrice()); // for DIvM
			}
			if (roleId == 32) {
				String view = "<div class='col-sm-12 form-group'><a \" href=\"/opensrp-dashboard/inventoryam/individual-ss-sell/" + branchId + "/"
				        + dto.getId() + ".html\"><strong>Sell Products </strong></a>  | " + "<a \" href=\"view/" + branchId
				        + "/" + dto.getId() + ".html\"><strong>View Details </strong></a> " + "</div>";
				
				patient.put(view);
			} else {
				String view = "<div class='col-sm-12 form-group'><a \" href=\"view/" + branchId + "/" + dto.getId()
				        + ".html\"><strong>View details </strong></a> </div>";
				patient.put(view);
			}
			array.put(patient);
			
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getStockInByStockId(long stockId) {
		
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> dtos = new ArrayList<>();
		try {
			String hql = "select product_name productName,invoice_number invoiceNumber,stock_in_id stockInId ,receive_date receiveDate,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,qty quantity  from core.stock_in_by_stock_id(:stockId)";
			Query query = session.createSQLQuery(hql).addScalar("productName", StandardBasicTypes.STRING)
			        .addScalar("invoiceNumber", StandardBasicTypes.STRING).addScalar("stockInId", StandardBasicTypes.STRING)
			        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("quantity", StandardBasicTypes.INTEGER)
			        .setLong("stockId", stockId).setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
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
	public List<InventoryDTO> getStockPassOrSellToSSByUserId(int branchId, int userId, String type, String productName,
	                                                         String startDate, String endDate, Integer length, Integer start) {
		
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> dtos = new ArrayList<>();
		try {
			String hql = "select product_name productName,receive_date receiveDate,qty quantity  from core.stock_pass_or_sell_by_user_id(:branchId,:userId,:type,:productName,:startDate,:endDate,:start,:length )";
			Query query = session.createSQLQuery(hql).addScalar("productName", StandardBasicTypes.STRING)
			        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("quantity", StandardBasicTypes.INTEGER)
			        .setInteger("userId", userId).setString("type", type).setString("productName", productName)
			        .setInteger("length", length).setInteger("start", start).setInteger("branchId", branchId)
			        .setString("startDate", startDate).setString("endDate", endDate)
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
	public int getStockPassOrSellToSSByUserIdCount(int branchId, int userId, String type, String productName,
	                                               String startDate, String endDate) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select *  from core.stock_pass_or_sell_by_user_id_count(:branchId,:userId,:type,:productName,:startDate,:endDate)";
			Query query = session.createSQLQuery(hql).setInteger("userId", userId).setString("type", type)
			        .setString("startDate", startDate).setString("endDate", endDate).setString("productName", productName)
			        .setInteger("branchId", branchId);
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
	
	public JSONObject getStockPassorSellToSSListDataOfDataTable(Integer draw, int sellToSSCount, List<InventoryDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", sellToSSCount);
		response.put("recordsFiltered", sellToSSCount);
		JSONArray array = new JSONArray();
		
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(dto.getProductName());
			patient.put(dto.getReceiveDate());
			patient.put(dto.getQuantity());
			array.put(patient);
			
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	public List<ProductDTO> getAllProductListForStock() {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String productSql = ""
					+ "SELECT p.NAME, "
					+ "       p.id "
					+ "FROM   core.product AS p "
					+ "GROUP  BY p.id "
					+ "ORDER  BY p.id ASC";
			Query query = session.createSQLQuery(productSql).addScalar("id",StandardBasicTypes.LONG).addScalar("name", StandardBasicTypes.STRING)
						.setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
			result = query.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<InventoryDTO> getIndividualStockList(String userName,Integer branchId, Integer roleId) {
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> result = null;
		try {
			String rawSql = "select * from core.product_list_for_sk_pk_pa_with_current_stock('"+userName+"',"+branchId+","+roleId+")";
			Query query = session.createSQLQuery(rawSql).addScalar("id",StandardBasicTypes.LONG)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("stock", StandardBasicTypes.INTEGER).addScalar("available", StandardBasicTypes.INTEGER)
						.setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			result = query.list();

		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}		
		return result;
	}
	
	
	@SuppressWarnings("unchecked")
	public ProductDTO getProductDetailsById(Integer branchId, Integer productId) {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String productSql = "select * from core.product_list_by_branch_with_current_stock_without_role("+branchId+","+productId+");";
			Query query = session.createSQLQuery(productSql).addScalar("id",StandardBasicTypes.LONG)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("stock", StandardBasicTypes.INTEGER)
						.setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
			result = query.list();

		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}		
		if(result.size() < 1) {
			return null;
		}
		else {
			return result.get(0);
		}
	}
	@Transactional
	public InventoryDTO getUserAndBrachByuserId(int userId) {
		
		Session session = getSessionFactory().openSession();
		InventoryDTO dtos = null;
		try {
			String hql = "select u.username, u.first_name firstName,u.last_name lastName ,r.role_id  roleId,b.name branchName,b.code branchCode from core.users as u join core.user_branch ub on u.id = ub.user_id join core.branch b on b.id=ub.branch_id join core.user_role r on r.user_id = u.id where u.id =:userId";
			Query query = session.createSQLQuery(hql).addScalar("username", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("roleId", StandardBasicTypes.INTEGER).setInteger("userId", userId)
			        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			dtos = (InventoryDTO) query.uniqueResult();
		}
		catch (HibernateException he) {
			he.printStackTrace();
		}
		finally {
			session.close();
		}
		return dtos;

	}
	
	public InventoryDTO getUserInfoWithSkByUserId(int userId) {
		
		Session session = getSessionFactory().openSession();
		InventoryDTO dtos = null;
		try {
			String hql = ""
					+ "SELECT Concat(sk.first_name, ' ', sk.last_name) SKName, "
					+ "       u.first_name firstName, "
					+ "       u.last_name lastName, "
					+ "       u.username, "
					+ "       r.role_id                                AS roleId "
					+ "FROM   core.users AS u "
					+ "       JOIN core.users sk "
					+ "         ON u.parent_user_id = sk.id "
					+ "       JOIN core.user_role r "
					+ "         ON r.user_id = u.id "
					+ "WHERE  u.id = "+userId+"";
			Query query = session.createSQLQuery(hql)
					.addScalar("SKName", StandardBasicTypes.STRING)
					.addScalar("firstName", StandardBasicTypes.STRING)
			        .addScalar("lastName", StandardBasicTypes.STRING)
			        .addScalar("roleId", StandardBasicTypes.INTEGER)
			        .addScalar("username", StandardBasicTypes.STRING)
			        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			dtos = (InventoryDTO) query.uniqueResult();
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
	public List<InventoryDTO> getProductListByBranchWithRole(Integer branchId, Integer roleId, int productId) {
		Session session = getSessionFactory().openSession();
		List<InventoryDTO> result = null;
		try {
			String rawSql = "select name,id,stock,unitprice as salesPrice from core.product_list_by_branch_with_current_stock_with_role("+branchId+","+roleId+","+productId+")";
			Query query = session.createSQLQuery(rawSql).addScalar("id",StandardBasicTypes.LONG)
					.addScalar("name", StandardBasicTypes.STRING)
					.addScalar("stock", StandardBasicTypes.INTEGER)
					.addScalar("salesPrice", StandardBasicTypes.FLOAT)
						.setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
			result = query.list();

		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}		
		return result;
	}
	
}
