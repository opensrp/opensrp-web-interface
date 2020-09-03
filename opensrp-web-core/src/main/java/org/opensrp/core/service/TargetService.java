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
import org.hibernate.Query;
import org.hibernate.Session;
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
		Session session = getSessionFactory();
		
		Integer returnValue = null;
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		
		Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
		
		List<TargetCommontDTO> targetTos = allTargetUser(dto.getRole(), TaregtSettingsType.valueOf(dto.getType()).name(),
		    dto.getTargetTo());
		
		for (TargetCommontDTO targetTo : targetTos) {
			
			for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
				Map<String, Object> fieldValues = new HashMap<>();
				fieldValues.put("year", targetDetailsDTO.getYear());
				fieldValues.put("month", targetDetailsDTO.getMonth());
				fieldValues.put("userId", targetTo.getUserId());
				fieldValues.put("productId", targetDetailsDTO.getProductId());
				TargetDetails targetDetails = findByKeys(fieldValues, TargetDetails.class);
				System.err.println("targetDetails::" + targetTo.getUserId());
				if (targetDetails == null) {
					targetDetails = new TargetDetails();
					targetDetails.setUuid(UUID.randomUUID().toString());
					targetDetails.setCreator(user.getId());
				} else {
					
					targetDetails.setUpdatedBy(user.getId());
				}
				
				targetDetails = targetMapper.map(targetDetailsDTO, targetDetails);
				targetDetails.setUserId(targetTo.getUserId());
				targetDetails.setBranchId(targetTo.getBranchId());
				
				session.saveOrUpdate(targetDetails);
				
			}
			
		}
		
		returnValue = 1;
		
		return returnValue;
	}
	
	@Transactional
	@SuppressWarnings("unchecked")
	public List<ProductDTO> allActiveTarget(int roleId) {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String hql = "select name,p.id from core.product p join core.product_role pr on p.id=pr.product_id  where status=:status and pr.role_id=:roleId ";
		
		Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.LONG).setString("status", Status.ACTIVE.name())
		        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@Transactional
	@SuppressWarnings("unchecked")
	public List<TargetCommontDTO> allTargetUser(int roleId, String type, int id) {
		Session session = getSessionFactory();
		List<TargetCommontDTO> result = null;
		
		String hql = "select user_id userId, branch_id branchId from core.get_userid_by_branch_or_location(:roleId,:id,:type);";
		Query query = session.createSQLQuery(hql).addScalar("userId", StandardBasicTypes.INTEGER)
		        .addScalar("branchId", StandardBasicTypes.INTEGER).setInteger("roleId", roleId).setString("type", type)
		        .setInteger("id", id).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getUserListForTargetSet(int locationId, int branchId, String roleName, Integer length,
	                                                      Integer start, String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select username,user_id userId,branch_id branchId,role_id roleId,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,role_name roleName,location_name locationName from core.user_list_for_target_set(:locationId,:branchId,:roleName,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("userId", StandardBasicTypes.INTEGER).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("locationName", StandardBasicTypes.STRING).setInteger("locationId", locationId)
		        .setInteger("branchId", branchId).setString("roleName", roleName).setInteger("length", length)
		        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getUserListForTargetSetCount(int locationId, int branchId, String roleName) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.user_list_for_target_set_count(:locationId,:branchId,:roleName)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
		        .setString("roleName", roleName);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject getUserListForTargetSetOfDataTable(Integer draw, int userCount, List<TargetCommontDTO> dtos)
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
			patient.put(dto.getUsername());
			patient.put(dto.getBranch());
			patient.put(dto.getLocationName());
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
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,:branchId,:roleName,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
		        .setInteger("locationId", locationId).setInteger("branchId", branchId).setString("roleName", roleName)
		        .setInteger("length", length).setInteger("start", start)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getBranchListForPositionalTargetCount(int locationId, int branchId, String roleName) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.branch_list_by_location_with_user_list_count(:locationId,:branchId,:roleName)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
		        .setString("roleName", roleName);
		total = (BigInteger) query.uniqueResult();
		
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
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getTargetInfoByBranchOrLocationOrUserByRoleByMonth(int roleId,
	                                                                                 int locationOrBranchOrUserId,
	                                                                                 String typeName, String locationTag,
	                                                                                 int month, int year) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select percentage, id Id, product_id productId ,product_name productName,quantity from core.get_target_info_by_branch_or_location_or_user_by_role_by_month(:roleId,:locationOrBranchOrUserId,:typeName,:locationTag,:month,:year)";
		Query query = session.createSQLQuery(hql).addScalar("percentage", StandardBasicTypes.STRING)
		        .addScalar("Id", StandardBasicTypes.LONG).addScalar("productId", StandardBasicTypes.INTEGER)
		        .addScalar("productName", StandardBasicTypes.STRING).addScalar("quantity", StandardBasicTypes.INTEGER)
		        .setInteger("roleId", roleId).setInteger("locationOrBranchOrUserId", locationOrBranchOrUserId)
		        .setString("typeName", typeName).setString("locationTag", locationTag).setInteger("month", month)
		        .setInteger("year", year).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
}
