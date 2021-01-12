/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.math.BigInteger;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.dto.PAStockReportDTO;
import org.opensrp.common.dto.StockReportDTO;
import org.opensrp.common.util.ReferenceType;
import org.opensrp.common.util.Status;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.dto.StockAdjustDTO;
import org.opensrp.core.dto.StockDTO;
import org.opensrp.core.dto.StockDetailsDTO;
import org.opensrp.core.entity.Product;
import org.opensrp.core.entity.Stock;
import org.opensrp.core.entity.StockAdjust;
import org.opensrp.core.entity.StockDetails;
import org.opensrp.core.entity.User;
import org.opensrp.core.entity.WebNotification;
import org.opensrp.core.entity.WebNotificationBranch;
import org.opensrp.core.entity.WebNotificationRole;
import org.opensrp.core.entity.WebNotificationUser;
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
		Session session = getSessionFactory();
		
		Integer returnValue = null;
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		Set<StockDetailsDTO> stockDetailsDTOs = dto.getStockDetailsDTOs();
		Set<Integer> sellTos = dto.getSellTo();
		int number = new Random().nextInt(999999);
		String stockId = dto.getStockId() + String.format("%06d", number);
		int branchId = 0;
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
			String refType = "";
			String msg = "";
			for (StockDetailsDTO stockDetailsDTO : stockDetailsDTOs) {
				StockDetails stockDetails = new StockDetails();
				stockDetails.setBranchId(stockDetailsDTO.getBranchId());
				branchId = stockDetailsDTO.getBranchId();
				stockDetails.setCredit(stockDetailsDTO.getCredit());
				stockDetails.setDebit(stockDetailsDTO.getDebit());
				stockDetails.setExpireyDate(stockDetailsDTO.getExpireyDate());
				stockDetails.setReceiveDate(stockDetailsDTO.getReceiveDate());
				
				stockDetails.setProductId(stockDetailsDTO.getProductId());
				stockDetails.setReferenceType(ReferenceType.valueOf(stockDetailsDTO.getReferenceType()).name());
				
				refType = ReferenceType.valueOf(stockDetailsDTO.getReferenceType()).name();
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
				stockDetails.setChallan(dto.getChallan());
				_stockDetails.add(stockDetails);
				if (refType.equalsIgnoreCase("PASS")) {
					Product product = findById(stockDetailsDTO.getProductId(), "id", Product.class);
					msg += " " + product.getName() + ":" + stockDetailsDTO.getDebit() + "\n";
				}
				
			}
			stock.setStockDetails(_stockDetails);
			stock.setChallan(dto.getChallan());
			session.saveOrUpdate(stock);
			if (refType.equalsIgnoreCase("PASS") && !stockDetailsDTOs.isEmpty()) {
				WebNotification webNotification = new WebNotification();
				webNotification.setNotificationTitle("আপনার কাছে নতুন প্রোডাক্ট এসেছে.");
				webNotification.setNotificationType("STOCK");
				webNotification.setStockDetailsId(stock.getId());
				webNotification.setNotification(msg);
				LocalDateTime now = LocalDateTime.now();
				webNotification.setSendDate(new Date());
				webNotification.setSendTimeHour(now.getHour());
				webNotification.setSendTimeMinute(now.getMinute());
				webNotification.setType("STOCK");
				Set<WebNotificationRole> _webNotificationRoles = new HashSet<>();
				WebNotificationRole _webNotificationRole = new WebNotificationRole();
				webNotification.setTimestamp(System.currentTimeMillis());
				_webNotificationRole.setWebNotification(webNotification);
				_webNotificationRoles.add(_webNotificationRole);
				webNotification.setWebNotificationRoles(_webNotificationRoles);
				Set<WebNotificationBranch> _webNotificationBranchs = new HashSet<>();
				
				WebNotificationBranch webNotificationBranch = new WebNotificationBranch();
				webNotificationBranch.setBranch(branchId);
				webNotificationBranch.setWebNotification(webNotification);
				_webNotificationBranchs.add(webNotificationBranch);
				webNotification.setWebNotificationBranchs(_webNotificationBranchs);
				
				Set<WebNotificationUser> _webNotificationUsers = new HashSet<>();
				for (Integer userId : sellTos) {
					WebNotificationUser _webNotificationUser = new WebNotificationUser();
					_webNotificationUser.setUserId(userId);
					_webNotificationUser.setWebNotification(webNotification);
					_webNotificationUsers.add(_webNotificationUser);
					_webNotificationRole.setRole(getUserRole(userId));
				}
				webNotification.setWebNotifications(_webNotificationUsers);
				session.saveOrUpdate(webNotification);
				
			}
			
		}
		
		returnValue = 1;
		
		return returnValue;
	}
	
	@Transactional
	public <T> Integer saveAdjustDetails(StockAdjustDTO dto) throws Exception {
		Session session = getSessionFactory();
		
		Integer returnValue = null;
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		StockAdjust stock = findById(dto.getId(), "id", StockAdjust.class);
		if (stock == null) {
			stock = new StockAdjust();
		}
		stock.setProductId(dto.getProductId());
		stock.setMonth(dto.getMonth());
		stock.setYear(dto.getYear());
		stock.setBranchId(dto.getBranchId());
		stock.setAdjustDate(dto.getAdjustDate());
		stock.setCurrentStock(dto.getCurrentStock());
		stock.setChangedStock(dto.getChangedStock());
		stock.setAdjustReason(dto.getAdjustReason());
		stock.setCreator(user.getId());
		session.saveOrUpdate(stock);
		
		returnValue = 1;
		
		return returnValue;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getStockInList(int branchId, String startDate, String endDate, String invoiceNumber,
	                                         String stockInId, int division, int district, int upazila, int userId,
	                                         Integer length, Integer start, String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		
		String hql = "select id,invoice_number invoiceNumber,stock_in_id stockInId,receive_date receiveDate,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName from  core.stock_in_list(:branchId,:startDate,:endDate,:invoiceNumber,:stockInId,:division,:district,:upazila,:userId,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("invoiceNumber", StandardBasicTypes.STRING).addScalar("stockInId", StandardBasicTypes.STRING)
		        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).setInteger("branchId", branchId)
		        .setString("startDate", startDate).setString("endDate", endDate).setString("invoiceNumber", invoiceNumber)
		        .setString("stockInId", stockInId).setInteger("division", division).setInteger("district", district)
		        .setInteger("upazila", upazila).setInteger("userId", userId).setInteger("length", length)
		        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int getStockInListCount(int branchId, String startDate, String endDate, String invoiceNumber, String stockInId,
	                               int division, int district, int upazila, int userId) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select  * from core.stock_in_count(:branchId,:startDate,:endDate,:invoiceNumber,:stockInId,:division,:district,:upazila,:userId)";
		Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setString("startDate", startDate)
		        .setString("endDate", endDate).setString("invoiceNumber", invoiceNumber).setString("stockInId", stockInId)
		        .setInteger("division", division).setInteger("district", district).setInteger("upazila", upazila)
		        .setInteger("userId", userId);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getPassStockUserList(int branchId, String name, int roleId, Integer length, Integer start,
	                                               String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		
		String hql = "select id,role_name roleName,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,username  from core.pass_stock_user_list_by_role_branch(:branchId,:roleId,:name,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("roleName", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("username", StandardBasicTypes.STRING)
		        .setInteger("branchId", branchId).setInteger("roleId", roleId).setString("name", name)
		        .setInteger("length", length).setInteger("start", start)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int getPassStockUserListCount(int branchId, int roleId, String name) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select  * from core.pass_stock_user_list_by_role_branch_count(:branchId,:roleId,:name)";
		Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setInteger("roleId", roleId)
		        .setString("name", name);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject getStockInListDataOfDataTable(Integer draw, int patientCount, List<InventoryDTO> dtos, int start)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", patientCount);
		response.put("recordsFiltered", patientCount);
		JSONArray array = new JSONArray();
		int i = 1;
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(start + i);
			patient.put(dto.getReceiveDate());
			patient.put(dto.getInvoiceNumber());
			patient.put(dto.getStockInId());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			patient.put("" + dto.getFullName());
			String view = "<div class='col-sm-12 form-group'><a class=\"text-primary\" href=\"javascript:;\" onclick='navigateTodetails("
			        + dto.getId()
			        + ",\""
			        + dto.getBranchName()
			        + "\",\""
			        + dto.getBranchCode()
			        + "\")'><strong>View details</strong></a> </div>";
			patient.put(view);
			array.put(patient);
			i++;
		}
		response.put("data", array);
		return response;
	}
	
	public JSONObject getPassStockUserListDataOfDataTable(Integer draw, int passStockUserCount, List<InventoryDTO> dtos,
	                                                      int branchId, int start) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", passStockUserCount);
		response.put("recordsFiltered", passStockUserCount);
		JSONArray array = new JSONArray();
		int i = 1;
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(start + i);
			patient.put(dto.getFullName());
			patient.put(dto.getUsername());
			patient.put(dto.getRoleName());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			
			String view = "<div class='col-sm-12 form-group'><a class=\"text-primary\" href=\"javascript:;\" onclick='navigateToPassStock("
			        + dto.getId() + ")'><strong>Pass stock</strong></a> </div>";
			/*String view = "<div class='col-sm-12 form-group'><a class=\"bt btn btn-success col-sm-12 form-group sm\" href=\"view/"
			        + dto.getId() + "/details.html\">Pass stock</a> </div>";
			*/
			
			patient.put(view);
			array.put(patient);
			i++;
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getsellToSSList(int managerId, int branchId, int skId, int division, int district,
	                                          int upazila, int year, int month, Integer length, Integer start,
	                                          String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		
		String hql = "select branch_id branchId, ss_id id,sell_amount salesPrice, purchase_amount purchasePrice, sk_name SKName,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName from core.sell_report(:manager,:branchId,:skId,:division,:district,:upazila,:year,:month,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("salesPrice", StandardBasicTypes.FLOAT)
		        .addScalar("purchasePrice", StandardBasicTypes.FLOAT).addScalar("SKName", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .setInteger("manager", managerId).setInteger("branchId", branchId).setInteger("skId", skId)
		        .setInteger("division", division).setInteger("district", district).setInteger("upazila", upazila)
		        .setInteger("year", year).setInteger("month", month).setInteger("length", length).setInteger("start", start)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getsellToSSListCount(int managerId, int branchId, int skId, int division, int district, int upazila,
	                                int year, int month) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.sell_report_count(:manager,:branchId,:skId,:division,:district,:upazila,:year,:month)";
		Query query = session.createSQLQuery(hql).setInteger("manager", managerId).setInteger("branchId", branchId)
		        .setInteger("skId", skId).setInteger("division", division).setInteger("district", district)
		        .setInteger("upazila", upazila).setInteger("year", year).setInteger("month", month);
		
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject getSellToSSListDataOfDataTable(Integer draw, int sellToSSCount, List<InventoryDTO> dtos, int roleId,
	                                                 int branchId, int start) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", sellToSSCount);
		response.put("recordsFiltered", sellToSSCount);
		JSONArray array = new JSONArray();
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		int i = 1;
		for (InventoryDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			if (roleId == 32) {
				String checkBox = "<input type=\"checkbox\" class=\"select-checkbox\" id=\"ss" + dto.getId() + "\" value="
				        + dto.getId() + ">";
				//patient.put("");
			}
			patient.put(start + i);
			patient.put(dto.getFullName());
			if (roleId == 32) {
				//patient.put("SS"); // for am
			}
			patient.put(dto.getSKName());
			patient.put(dto.getBranchName() + "(" + dto.getBranchCode() + ")");
			/*if (roleId != 32) {
				patient.put("0"); // target amount for DIvM
			}*/
			patient.put(df.format(dto.getSalesPrice()));
			/*if (roleId != 32) {*/
			patient.put(df.format(dto.getPurchasePrice())); // for DIvM
			//}
			if (roleId == 32) {
				String view = "<div class='col-sm-12 form-group'><a \" href=\"/opensrp-dashboard/inventoryam/individual-ss-sell/"
				        + dto.getBranchId()
				        + "/"
				        + dto.getId()
				        + ".html\"><strong>Sell Products </strong></a>  | "
				        + "<a \" href=\"/opensrp-dashboard/inventoryam/ss-sales/view/"
				        + dto.getBranchId()
				        + "/"
				        + dto.getId() + ".html\"><strong>View Details </strong></a> " + "</div>";
				
				patient.put(view);
			} else {
				String view = "<div class='col-sm-12 form-group'><a \" href=\"view-sales-report/" + dto.getBranchId() + "/"
				        + dto.getId() + ".html\"><strong>View details </strong></a> </div>";
				patient.put(view);
			}
			array.put(patient);
			i++;
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getStockInByStockId(long stockId) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		
		String hql = "select product_name productName,invoice_number invoiceNumber,stock_in_id stockInId ,receive_date receiveDate,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,qty quantity  from core.stock_in_by_stock_id(:stockId)";
		Query query = session.createSQLQuery(hql).addScalar("productName", StandardBasicTypes.STRING)
		        .addScalar("invoiceNumber", StandardBasicTypes.STRING).addScalar("stockInId", StandardBasicTypes.STRING)
		        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("quantity", StandardBasicTypes.INTEGER)
		        .setLong("stockId", stockId).setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getStockPassOrSellToSSByUserId(int branchId, int userId, String type, String productName,
	                                                         String startDate, String endDate, Integer length, Integer start) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		
		String hql = "select product_name productName,receive_date receiveDate,qty quantity  from core.stock_pass_or_sell_by_user_id(:branchId,:userId,:type,:productName,:startDate,:endDate,:start,:length )";
		Query query = session.createSQLQuery(hql).addScalar("productName", StandardBasicTypes.STRING)
		        .addScalar("receiveDate", StandardBasicTypes.DATE).addScalar("quantity", StandardBasicTypes.INTEGER)
		        .setInteger("userId", userId).setString("type", type).setString("productName", productName)
		        .setInteger("length", length).setInteger("start", start).setInteger("branchId", branchId)
		        .setString("startDate", startDate).setString("endDate", endDate)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int getStockPassOrSellToSSByUserIdCount(int branchId, int userId, String type, String productName,
	                                               String startDate, String endDate) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select *  from core.stock_pass_or_sell_by_user_id_count(:branchId,:userId,:type,:productName,:startDate,:endDate)";
		Query query = session.createSQLQuery(hql).setInteger("userId", userId).setString("type", type)
		        .setString("startDate", startDate).setString("endDate", endDate).setString("productName", productName)
		        .setInteger("branchId", branchId);
		total = (BigInteger) query.uniqueResult();
		
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
	@Transactional
	public List<ProductDTO> getAllProductListForStock() {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String productSql = "" + "SELECT p.NAME, " + "       p.id "
		        + "FROM   core.product AS p  where p.type='PRODUCT' GROUP  BY p.id " + "ORDER  BY p.id ASC";
		Query query = session.createSQLQuery(productSql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getIndividualStockList(String userName, Integer branchId, Integer roleId) {
		Session session = getSessionFactory();
		List<InventoryDTO> result = null;
		
		String rawSql = "select * from core.product_list_for_sk_pk_pa_with_current_stock('" + userName + "'," + branchId
		        + "," + roleId + ")";
		Query query = session.createSQLQuery(rawSql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("stock", StandardBasicTypes.INTEGER)
		        .addScalar("available", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		result = query.list();
		
		return result;
	}
	
	@Transactional
	public List<StockReportDTO> getStockReportForSK(String year, String month, String skList) {
		Session session = getSessionFactory();
		List<StockReportDTO> result = null;
		
		String rawSql = "select * from report.get_stock_report('" + month + "', '" + year + "', '{" + skList + "}')";
		Query query = session.createSQLQuery(rawSql).addScalar("skusername", StandardBasicTypes.STRING)
		        .addScalar("skname", StandardBasicTypes.STRING).addScalar("iycfStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("iycfMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("iycfMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("iycfEndingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("womenPackageStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("womenPackageMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("womenPackageMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("womenPackageEndingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentPackageStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentPackageMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentPackageMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentPackageEndingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("ncdPackageStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("ncdPackageMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("ncdPackageMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("ncdPackageEndingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("ancPackageStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("ancPackageMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("ancPackageMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("ancPackageEndingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("pncPackageStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("pncPackageMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("pncPackageMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("pncPackageEndingBalance", StandardBasicTypes.INTEGER)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(StockReportDTO.class));
		result = query.list();
		return result;
	}
	
	@Transactional
	public List<PAStockReportDTO> getStockReportForPA(String year, String month, String paList) {
		Session session = getSessionFactory();
		List<PAStockReportDTO> result = null;
		
		String rawSql = "select * from report.get_pa_stock_report('" + month + "', '" + year + "', '{" + paList + "}')";
		Query query = session.createSQLQuery(rawSql).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("ncdStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("ncdMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("ncdMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("ncdEndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sgStartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sgMonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sgMonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sgEndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sv1StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sv1MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sv1MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sv1EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sv15StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sv15MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sv15MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sv15EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sv2StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sv2MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sv2MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sv2EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sv25StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sv25MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sv25MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sv25EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("sv3StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("sv3MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("sv3MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("sv3EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("bf1StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("bf1MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("bf1MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("bf1EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("bf15StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("bf15MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("bf15MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("bf15EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("bf2StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("bf2MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("bf2MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("bf2EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("bf25StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("bf25MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("bf25MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("bf25EndingBalance", StandardBasicTypes.INTEGER)
		        
		        .addScalar("bf3StartingBalance", StandardBasicTypes.INTEGER)
		        .addScalar("bf3MonthlySupply", StandardBasicTypes.INTEGER)
		        .addScalar("bf3MonthlySell", StandardBasicTypes.INTEGER)
		        .addScalar("bf3EndingBalance", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(PAStockReportDTO.class));
		result = query.list();
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public ProductDTO getProductDetailsById(Integer branchId, Integer productId) {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String productSql = "select * from core.product_list_by_branch_with_current_stock_without_role(" + branchId + ","
		        + productId + ");";
		Query query = session.createSQLQuery(productSql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("stock", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		result = query.list();
		
		if (result.size() < 1) {
			return null;
		} else {
			return result.get(0);
		}
	}
	
	@Transactional
	public InventoryDTO getUserAndBrachByuserId(int userId) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = null;
		
		String hql = "select u.username, u.first_name firstName,u.last_name lastName ,r.role_id  roleId,b.name branchName,b.code branchCode from core.users as u join core.user_branch ub on u.id = ub.user_id join core.branch b on b.id=ub.branch_id join core.user_role r on r.user_id = u.id where u.id =:userId";
		Query query = session.createSQLQuery(hql).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).setInteger("userId", userId)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos.get(0);
		
	}
	
	@Transactional
	public InventoryDTO getUserInfoWithSkByUserId(int userId) {
		
		Session session = getSessionFactory();
		InventoryDTO dtos = null;
		
		String hql = "" + "SELECT Concat(sk.first_name, ' ', sk.last_name) SKName, " + "       u.first_name firstName, "
		        + "       u.last_name lastName, " + "       u.username, "
		        + "       r.role_id                                AS roleId " + "FROM   core.users AS u "
		        + "       JOIN core.users sk " + "         ON u.parent_user_id = sk.id " + "       JOIN core.user_role r "
		        + "         ON r.user_id = u.id " + "WHERE  u.id = " + userId + "";
		Query query = session.createSQLQuery(hql).addScalar("SKName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).addScalar("username", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = (InventoryDTO) query.uniqueResult();
		
		return dtos;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getProductListByBranchWithRole(Integer branchId, Integer roleId, int productId) {
		Session session = getSessionFactory();
		List<InventoryDTO> result = null;
		
		String rawSql = "select name,id,stock,unitprice as salesPrice from core.product_list_by_branch_with_current_stock_with_role("
		        + branchId + "," + roleId + "," + productId + ")";
		Query query = session.createSQLQuery(rawSql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("stock", StandardBasicTypes.INTEGER)
		        .addScalar("salesPrice", StandardBasicTypes.FLOAT)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getUserListByBranchWithRole(String branchIds, Integer roleId) {
		Session session = getSessionFactory();
		List<InventoryDTO> result = null;
		
		String rawSql = "select id id,username,name from core.get_user_by_branches(:roleId,'{" + branchIds + "}')";
		Query query = session.createSQLQuery(rawSql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("username", StandardBasicTypes.STRING)
		        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<StockAdjustDTO> getAdjustHistoryList(long adjustId, String branchIds, String fromDate, String toDate,
	                                                 Integer start, Integer length) {
		
		Session session = getSessionFactory();
		List<StockAdjustDTO> dtos = new ArrayList<>();
		
		String hql = "select id,product_name productName,branch_name branchName,product_id productId,current_stock currentStock,changed_stock changedStock,adjust_date adjustDate,adjust_reason adjustReason from core.stock_adjust_list(:adjustId,'{"
		        + branchIds + "}',:fromDate,:toDate,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("productName", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("productId", StandardBasicTypes.LONG).addScalar("currentStock", StandardBasicTypes.INTEGER)
		        .addScalar("changedStock", StandardBasicTypes.INTEGER).addScalar("adjustDate", StandardBasicTypes.DATE)
		        .addScalar("adjustReason", StandardBasicTypes.STRING).setLong("adjustId", adjustId)
		        .setString("fromDate", fromDate).setString("toDate", toDate).setInteger("start", start)
		        .setInteger("length", length).setResultTransformer(new AliasToBeanResultTransformer(StockAdjustDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getAdjustStockListCount(String branchIds, String fromDate, String toDate) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select *  from core.stock_adjust_list_count('{" + branchIds + "}',:fromDate,:toDate)";
		Query query = session.createSQLQuery(hql).setString("fromDate", fromDate).setString("toDate", toDate);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public void getStockReport() {
		
	}
	
	public JSONObject getAdjustStockListDataOfDataTable(Integer draw, int adjustStockCount, List<StockAdjustDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", adjustStockCount);
		response.put("recordsFiltered", adjustStockCount);
		JSONArray array = new JSONArray();
		for (StockAdjustDTO dto : dtos) {
			JSONArray stockAdjust = new JSONArray();
			stockAdjust.put(dto.getAdjustDate());
			stockAdjust.put(dto.getProductName());
			stockAdjust.put(dto.getProductId());
			stockAdjust.put(dto.getBranchName());
			stockAdjust.put(dto.getCurrentStock());
			stockAdjust.put(dto.getChangedStock());
			stockAdjust.put(dto.getCurrentStock() - dto.getChangedStock());
			stockAdjust.put(dto.getAdjustReason());
			
			String view = "<div class='col-sm-12 form-group'><a class='text-primary'  href=\"/opensrp-dashboard/inventory/adjust-history/"
			        + dto.getId() + ".html\"><strong>View details </strong></a> </div>";
			stockAdjust.put(view);
			
			array.put(stockAdjust);
		}
		response.put("data", array);
		return response;
	}
	
}
