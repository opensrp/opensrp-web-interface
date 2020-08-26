/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.util.Status;
import org.opensrp.common.util.TaregtSettingsType;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.dto.TargetDetailsDTO;
import org.opensrp.core.entity.TargetDetails;
import org.opensrp.core.entity.User;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class TargetService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(TargetService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public TargetService() {
		
	}
	
	@Transactional
	public <T> Integer saveAll(TargetDTO dto) throws Exception {
		Session session = getSessionFactory().openSession();
		Transaction tx = null;
		Integer returnValue = null;
		try {
			tx = session.beginTransaction();
			
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User user = (User) auth.getPrincipal();
			
			Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
			
			List<Integer> targetTos = allTargetUser(dto.getRole(), TaregtSettingsType.valueOf(dto.getType()).name(),
			    dto.getTargetTo());
			
			for (Integer targetTo : targetTos) {
				
				for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
					Map<String, Object> fieldValues = new HashMap<>();
					fieldValues.put("year", targetDetailsDTO.getYear());
					fieldValues.put("month", targetDetailsDTO.getMonth());
					fieldValues.put("userId", targetTo);
					fieldValues.put("productId", targetDetailsDTO.getProductId());
					TargetDetails targetDetails = findByKeys(fieldValues, TargetDetails.class);
					
					if (targetDetails == null) {
						targetDetails = new TargetDetails();
						targetDetails.setUuid(UUID.randomUUID().toString());
						targetDetails.setCreator(user.getId());
					} else {
						
						targetDetails.setUpdatedBy(user.getId());
					}
					
					targetDetails = targetMapper.map(targetDetailsDTO, targetDetails);
					targetDetails.setUserId(targetTo);
					
					session.saveOrUpdate(targetDetails);
					
				}
				
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
	public List<ProductDTO> allActiveTarget(int roleId) {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String hql = "select name,p.id from core.product p join core.product_role pr on p.id=pr.product_id  where status=:status and pr.role_id=:roleId ";
			
			Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
			        .addScalar("id", StandardBasicTypes.LONG).setString("status", Status.ACTIVE.name())
			        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
			
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
	public List<Integer> allTargetUser(int roleId, String type, int id) {
		Session session = getSessionFactory().openSession();
		List<Integer> result = null;
		try {
			String hql = "select * from core.get_userid_by_branch_or_location(:roleId,:id,:type);";
			Query query = session.createSQLQuery(hql).setInteger("roleId", roleId).setString("type", type)
			        .setInteger("id", id);
			
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
	@Transactional
	public List<TargetCommontDTO> getAllSKPAListForIndividualTargetSetting(int locationId, int branchId, String roleName,
	                                                                       Integer length, Integer start,
	                                                                       String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory().openSession();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		try {
			String hql = "select user_id userId,branch_id branchId,role_id roleId,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,role_name roleName from core.sk_pa_list_for_individual_target_setting(:locationId,:branchId,:roleName,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("userId", StandardBasicTypes.INTEGER)
			        .addScalar("branchId", StandardBasicTypes.INTEGER).addScalar("roleId", StandardBasicTypes.INTEGER)
			        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("branchCode", StandardBasicTypes.STRING)
			        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
			        .addScalar("roleName", StandardBasicTypes.STRING).setInteger("locationId", locationId)
			        .setInteger("branchId", branchId).setString("roleName", roleName).setInteger("length", length)
			        .setInteger("start", start)
			        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
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
	public int getAllSKPAListForIndividualTargetSettingCount(int locationId, int branchId, String roleName) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select * from core.sk_pa_list_for_individual_target_setting_count(:locationId,:branchId,:roleName)";
			Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
			        .setString("roleName", roleName);
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
	
	public JSONObject getSKPATargetSettingDataOfDataTable(Integer draw, int userCount, List<TargetCommontDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", userCount);
		response.put("recordsFiltered", userCount);
		JSONArray array = new JSONArray();
		for (TargetCommontDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(dto.getFullName());
			patient.put(dto.getRoleName());
			patient.put(dto.getBranch());
			
			String view = "<div class='col-sm-12 form-group'><a \" href=\"set-individual/" + dto.getBranchId() + "/"
			        + dto.getRoleId() + "/" + dto.getUserId() + ".html?name=" + dto.getFullName()
			        + "\">Set target</a> </div>";
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getBranchListForPositionalTarget(int locationId, int branchId, String roleName,
	                                                               Integer length, Integer start, String orderColumn,
	                                                               String orderDirection) {
		
		Session session = getSessionFactory().openSession();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		try {
			String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,:branchId,:roleName,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
			        .setInteger("locationId", locationId).setInteger("branchId", branchId).setString("roleName", roleName)
			        .setInteger("length", length).setInteger("start", start)
			        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
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
	public int getBranchListForPositionalTargetCount(int locationId, int branchId, String roleName) {
		
		Session session = getSessionFactory().openSession();
		BigInteger total = null;
		try {
			String hql = "select * from core.branch_list_by_location_with_user_list_count(:locationId,:branchId,:roleName)";
			Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
			        .setString("roleName", roleName);
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
	
	public JSONObject getPositionalTargetDataOfDataTable(Integer draw, int total, List<TargetCommontDTO> dtos)
	    throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", total);
		response.put("recordsFiltered", total);
		JSONArray array = new JSONArray();
		for (TargetCommontDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			patient.put(dto.getBranchName());
			patient.put(dto.getBranchCode());
			patient.put(dto.getUpazilaName());
			patient.put(dto.getUserCount());
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
}
