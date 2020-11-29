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

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.*;
import org.opensrp.common.util.LocationTags;
import org.opensrp.common.util.Roles;
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
	private SessionFactory sessionFactory;
	
	@Autowired
	private TargetMapper targetMapper;
	
	public TargetService() {
		
	}
	
	@Transactional
	public <T> Integer saveAll(TargetDTO dto) throws Exception {
		Session session = getSessionFactory();
		
		Integer returnValue = 0;
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		
		Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
		int roleId = dto.getRole();
		/*List<TargetCommontDTO> targetTos = allTargetUser(roleId, TaregtSettingsType.valueOf(dto.getType()).name(),
		    dto.getTargetTo());*/
		
		String typeName = TaregtSettingsType.valueOf(dto.getType()).name();
		boolean deleted = deleteAllByKeys(TaregtSettingsType.valueOf(dto.getType()).name(), dto.getTargetTo(), roleId,
		    dto.getYear(), dto.getMonth(), dto.getDay());
		if (deleted) {
			String sql = " with t as(";
			int size = targetDetailsDTOs.size();
			
			int i = 1;
			for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
				
				sql += " select TO_DATE('" + targetDetailsDTO.getEndDate() + "','YYYY-MM-DD') end_date, TO_DATE('"
				        + targetDetailsDTO.getStartDate() + "','YYYY-MM-DD')  start_date," + "" + targetDetailsDTO.getYear()
				        + " \"year\", " + targetDetailsDTO.getMonth() + " \"month\" , " + " " + targetDetailsDTO.getDay()
				        + " \"day\",'" + targetDetailsDTO.getPercentage() + "'  percentage, " + " "
				        + targetDetailsDTO.getProductId() + " product_id, " + targetDetailsDTO.getQuantity() + " quantity, "
				        + " 'ACTIVE' status," + System.currentTimeMillis() + " \"timestamp\"," + " 'quantity' unit,'"
				        + UUID.randomUUID() + "' uuid ,'" + dto.getType() + "' target_type , " + user.getId()
				        + " creator, current_timestamp	 created_date";
				if (i < size) {
					
					sql += " \n union";
				}
				i++;
			}
			if (typeName.equalsIgnoreCase("BRANCH")) {
				sql += "),t2 as( select ub.user_id id,ub.branch_id branchid,ur.role_id role_id from core.user_branch as ub join core.user_role ur "
				        + "on ub.user_id = ur.user_id join core.users u on u.id=ub.user_id where  u.enabled= true and ur.role_id = "
				        + roleId + "  and ub.branch_id= any('{" + dto.getTargetTo() + "}'))";
			} else if (typeName.equalsIgnoreCase("ROLE")) {
				sql += "),t2 as( select id,ub.branch_id branchid,ur.role_id from  core.users u join core.user_role ur on u.id=ur.user_id"
				        + "	join core.user_branch ub on u.id=ub.user_id where  u.enabled= true  and ur.role_id ="
				        + roleId
				        + ")";
			} else {
				sql += "),t2 as( select ub.user_id id,ub.branch_id branchid,ur.role_id from core.user_branch as ub join core.user_role ur"
				        + "  on ub.user_id = ur.user_id join core.users u on u.id=ub.user_id where u.enabled= true and ur.role_id = "
				        + roleId + " and ub.user_id= any('{" + dto.getTargetTo() + "}'))";
			}
			sql += "insert into core.target_details(user_id,branch_id,role_id,end_date,"
			        + " start_date,\"year\",\"month\",\"day\",percentage,product_id,quantity,status,\"timestamp\",unit,uuid"
			        + ",target_type,creator,created_date) select  t2.id,t2.branchid,t2.role_id,t.* from t, t2 order by t2.id";
			
			Query query = session.createSQLQuery(sql);
			Integer flag = query.executeUpdate();
			
			if (flag > 1) {
				returnValue = 1;
			} else {
				returnValue = 0;
			}
			
		} else {
			returnValue = 0;
		}
		
		return returnValue;
	}
	
	@Transactional
	public <T> boolean deleteAllByKeys(String type, String userOrBranchIds, Integer roleId, int year, int month, int day) {
		Session session = getSessionFactory();
		boolean returnValue = false;
		String hql = "";
		
		if (TaregtSettingsType.ROLE.name().equalsIgnoreCase(type)) {
			hql = "delete from core.target_details where role_id =" + roleId + "  and year =" + year + " and month=" + month
			        + " and day=" + day;
		} else if (TaregtSettingsType.BRANCH.name().equalsIgnoreCase(type)) {
			hql = "delete from core.target_details where role_id =" + roleId + "  and year =" + year + " and month=" + month
			        + " and day=" + day + " and branch_id = any('{" + userOrBranchIds + "}')";
		} else if (TaregtSettingsType.USER.name().equalsIgnoreCase(type)) {
			hql = "delete from core.target_details where  year =" + year + " and month=" + month + " and day=" + day
			        + " and user_id = any('{" + userOrBranchIds + "}')";
		}
		if (!StringUtils.isBlank(hql)) {
			Query query = session.createSQLQuery(hql);
			Integer flag = query.executeUpdate();
			if (flag >= 0) {
				returnValue = true;
			} else {
				returnValue = false;
			}
		}
		
		return returnValue;
	}
	
	@Transactional
	public Integer getTargetForIndividual(Integer userId, Integer year, Integer month, Integer day, Integer branchId) {
		Session session = getSessionFactory();
		String hql;
		
		if (day == 0)
			hql = "select * from core.target_details as td where td.user_id= :userId and td.year = :year and td.month = :month and td.branch_id= :branchId";
		else
			hql = "select * from core.target_details as td where td.user_id= :userId and td.year = :year and td.month = :month and td.branch_id= :branchId and td.day= :day";
		
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG).setInteger("userId", userId)
		        .setInteger("year", year).setInteger("month", month).setInteger("branchId", branchId);
		if (day != 0) {
			query.setInteger("day", day);
		}
		query.setResultTransformer(new AliasToBeanResultTransformer(TargetDetailsDTO.class));
		int targetCount = query.list().size();
		System.out.println("==================>");
		System.out.println(targetCount);
		
		return targetCount;
	}
	
	@Transactional
	public <T> Integer savePopulationWiseTargetAll(TargetDTO dto) throws Exception {
		Session session = getSessionFactory();
		
		Integer returnValue = null;
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		
		Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
		
		List<TargetCommontDTO> targetList = allTargetUserByUnionWithPopulation(Roles.PK.getId(),
		    LocationTags.UNION_WARD.getId());
		
		for (TargetCommontDTO target : targetList) {
			
			for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
				Map<String, Object> fieldValues = new HashMap<>();
				if (targetDetailsDTO.getDay() != 0) {
					fieldValues.put("day", targetDetailsDTO.getDay());
				}
				fieldValues.put("year", targetDetailsDTO.getYear());
				fieldValues.put("month", targetDetailsDTO.getMonth());
				fieldValues.put("userId", target.getUserId());
				fieldValues.put("productId", targetDetailsDTO.getProductId());
				TargetDetails targetDetails = findByKeys(fieldValues, TargetDetails.class);
				System.err.println("targetDetails::" + target.getUserId());
				if (targetDetails == null) {
					targetDetails = new TargetDetails();
					targetDetails.setUuid(UUID.randomUUID().toString());
					targetDetails.setCreator(user.getId());
				} else {
					
					targetDetails.setUpdatedBy(user.getId());
				}
				targetDetails.setTargetType(dto.getType());
				targetDetails = targetMapper.targetMapForUnionWiseTarget(targetDetailsDTO, targetDetails,
				    target.getPopulation());
				targetDetails.setUserId(target.getUserId());
				targetDetails.setBranchId(target.getBranchId());
				
				session.saveOrUpdate(targetDetails);
				
			}
			
		}
		
		returnValue = 1;
		
		return returnValue;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<ProductDTO> allActiveTarget(int roleId, String type) {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String hql = "select name,p.id from core.product p join core.product_role pr on p.id=pr.product_id  where status=:status and pr.role_id=:roleId and p.type=:type ";
		
		Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.LONG).setString("status", Status.ACTIVE.name())
		        .setInteger("roleId", roleId).setString("type", type)
		        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@Transactional
	@SuppressWarnings("unchecked")
	public List<TargetCommontDTO> allTargetUser(int roleId, String type, String branchIds) {
		Session session = getSessionFactory();
		List<TargetCommontDTO> result = null;
		
		String hql = "select user_id userId, branch_id branchId from core.get_userid_by_branch_or_location(:roleId,'{"
		        + branchIds + "}',:type);";
		Query query = session.createSQLQuery(hql).addScalar("userId", StandardBasicTypes.INTEGER)
		        .addScalar("branchId", StandardBasicTypes.INTEGER).setInteger("roleId", roleId).setString("type", type)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<TargetCommontDTO> allTargetUserByUnionWithPopulation(Integer roleId, Integer locationTagId) {
		Session session = getSessionFactory();
		List<TargetCommontDTO> result = null;
		
		String hql = "" + "SELECT cat.user_id as userId, " + "       cat.location_id as locationId, "
		        + "       wp.population as population, " + "       ub.branch_id as branchId "
		        + "FROM   core.users_catchment_area cat " + "       JOIN core.\"location\" l "
		        + "         ON cat.location_id = l.id " + "       JOIN core.location_tag ltag "
		        + "         ON l.location_tag_id = ltag.id " + "       JOIN core.user_role r "
		        + "         ON r.user_id = cat.user_id " + "       JOIN core.union_wise_population wp "
		        + "         ON l.id = wp.union_id " + "       JOIN core.user_branch ub "
		        + "         ON ub.user_id = cat.user_id " + "WHERE  ltag.id = " + locationTagId + " "
		        + "       AND r.role_id = " + roleId + "";
		Query query = session.createSQLQuery(hql).addScalar("userId", StandardBasicTypes.INTEGER)
		        .addScalar("branchId", StandardBasicTypes.INTEGER).addScalar("locationId", StandardBasicTypes.INTEGER)
		        .addScalar("population", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getUserListForTargetSet(int locationId, String branchIds, String roleName, Integer length,
	                                                      Integer start, String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select username,user_id userId,branch_id branchId,role_id roleId,branch_name branchName,branch_code branchCode,first_name firstName,last_name lastName,role_name roleName,location_name locationName,population from core.user_list_for_target_set(:locationId,'{"
		        + branchIds + "}',:roleName,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("userId", StandardBasicTypes.INTEGER).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("locationName", StandardBasicTypes.STRING).addScalar("population", StandardBasicTypes.INTEGER)
		        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
		        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getUserListForTargetSetCount(int locationId, String branchIds, String roleName) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.user_list_for_target_set_count(:locationId,'{" + branchIds + "}',:roleName)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setString("roleName", roleName);
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
			String setTarget = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"set-individual/"
			        + dto.getBranchId() + "/" + dto.getRoleId() + "/" + dto.getUserId() + ".html?name=" + dto.getFullName()
			        + "\">Set target</a> </div>";
			String viewTarget = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"view-individual/"
			        + dto.getBranchId() + "/" + dto.getRoleId() + "/" + dto.getUserId() + ".html?name=" + dto.getFullName()
			        + "\">View target</a> </div>";
			String editTarget = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"edit-individual/"
			        + dto.getBranchId() + "/" + dto.getRoleId() + "/" + dto.getUserId() + ".html?name=" + dto.getFullName()
			        + "\">Edit target</a> </div>";
			patient.put(setTarget);
			patient.put(viewTarget);
			patient.put(editTarget);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	public JSONObject getUnionWisePopulationSetOfDataTable(Integer draw, int userCount, List<TargetCommontDTO> dtos)
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
			patient.put(dto.getLocationName());
			patient.put(dto.getPopulation());
			String view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"set-individual-target-pk/"
			        + dto.getBranchId() + "/" + dto.getRoleId() + "/" + dto.getUserId() + ".html?name=" + dto.getFullName()
			        + "&id=" + dto.getUsername() + "&location=" + dto.getLocationName() + "&population=1200"
			        + "\">Set target</a> </div>";
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getBranchListForPositionalTarget(int locationId, String branchIds, String roleName,
	                                                               Integer length, Integer start, String orderColumn,
	                                                               String orderDirection) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,'{"
		        + branchIds + "}',:roleName,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
		        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
		        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getPMVisitReportByManager(JSONObject params) throws JSONException {
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,first_name firstName,last_name lastName,user_id id,total_branch numberOfBranch,total_am numberOfAm,total_sk numberOfSK,total_pa numberOfPA,target_vs_achv achievementInPercentage from report.pm_visit_report_dm_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.INTEGER).addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
		        .addScalar("numberOfAm", StandardBasicTypes.INTEGER).addScalar("numberOfSK", StandardBasicTypes.INTEGER)
		        .addScalar("numberOfPA", StandardBasicTypes.INTEGER)
		        .addScalar("achievementInPercentage", StandardBasicTypes.FLOAT)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getPMVisitReportByLocation(JSONObject params) {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		TargetReportDTO targetReportDTO = new TargetReportDTO();
		targetReportDTO.setFirstName("Arif");
		targetReportDTO.setLastName("haque");
		targetReportDTO.setLocationName("Dhaka");
		targetReportDTO.setNumberOfSK(23);
		targetReportDTO.setNumberOfAm(12);
		targetReportDTO.setNumberOfBranch(3);
		targetReportDTO.setAchievementInPercentage(23.3f);
		/*String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,'{"
		        + branchIds + "}',:roleName,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
		        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
		        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();*/
		dtos.add(targetReportDTO);
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getDMVisitReportByManager(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,first_name firstName,last_name lastName,user_id id,total_branch numberOfBranch,total_sk numberOfSK,total_pa numberOfPA,target_vs_achv achievementInPercentage from report.dm_visit_report_am_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.INTEGER).addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
		        .addScalar("numberOfSK", StandardBasicTypes.INTEGER).addScalar("numberOfPA", StandardBasicTypes.INTEGER)
		        .addScalar("achievementInPercentage", StandardBasicTypes.FLOAT)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getDMVisitReportByLocation(JSONObject params) {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		for (int i = 0; i < 30; i++) {
			TargetReportDTO targetReportDTO = new TargetReportDTO();
			targetReportDTO.setFirstName("Arif");
			targetReportDTO.setLastName("haque");
			targetReportDTO.setLocationName("Dhaka");
			targetReportDTO.setNumberOfSK(23);
			targetReportDTO.setNumberOfAm(12);
			targetReportDTO.setNumberOfBranch(3);
			targetReportDTO.setAchievementInPercentage(23.3f);
			/*String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,'{"
			        + branchIds + "}',:roleName,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
			        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
			        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
			dtos = query.list();*/
			dtos.add(targetReportDTO);
		}
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getPMServiceReportByManager(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,first_name firstName,last_name lastName ,user_id id,total_am numberOfAm, total_sk numberOfSK, "
		        + " anc_target ANCServiceTarget,anc_sell ANCServiceSell,anc_tva ANCServiceAchievement "
		        + ",pnc_target PNCServiceTarget,pnc_sell PNCServiceSell,pnc_tva PNCServiceAchievement"
		        + " , women_target WomenServiceTarget,women_sell WomenServiceSell,women_tva WomenServiceAchievement "
		        + " , ncd_target NCDServiceTarget,ncd_sell NCDServiceSell , ncd_tva NCDServiceAchievement "
		        + ", adolescent_target AdolescentServiceTarget,adolescent_sell AdolescentServiceSell, adolescent_tva AdolescentServiceAchievement "
		        + ", iycf_target IYCFServiceTarget , iycf_sell IYCFServiceSell, iycf_tva IYCFServiceAchievement from report.pm_service_report_dm_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.INTEGER).addScalar("numberOfAm", StandardBasicTypes.INTEGER)
				.addScalar("numberOfSK", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("PNCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("WomenServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("NCDServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("AdolescentServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("IYCFServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceAchievement", StandardBasicTypes.FLOAT)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getPMServiceReportByLocation(JSONObject params) {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		for (int i = 0; i < 20; i++) {
			TargetReportDTO targetReportDTO = new TargetReportDTO();
			targetReportDTO.setFirstName("Arif");
			targetReportDTO.setLastName("haque");
			targetReportDTO.setLocationName("Dhaka");
			targetReportDTO.setNumberOfSK(23);
			targetReportDTO.setNumberOfAm(12);
			targetReportDTO.setNumberOfBranch(3);
			targetReportDTO.setAchievementInPercentage(23.3f);
			targetReportDTO.setAchievementInPercentage(23.3f);
			targetReportDTO.setANCServiceAchievement(78.34f);
			targetReportDTO.setANCServiceSell(34);
			targetReportDTO.setANCServiceTarget(41);
			
			targetReportDTO.setPNCServiceAchievement(62.5f);
			targetReportDTO.setPNCServiceSell(34);
			targetReportDTO.setPNCServiceTarget(40);
			
			targetReportDTO.setNCDServiceAchievement(45.4f);
			targetReportDTO.setNCDServiceSell(41);
			targetReportDTO.setNCDServiceTarget(50);
			
			targetReportDTO.setWomenServiceAchievement(34.4f);
			targetReportDTO.setWomenServiceSell(34);
			targetReportDTO.setWomenServiceTarget(32);
			
			targetReportDTO.setIYCFServiceAchievement(45.4f);
			targetReportDTO.setIYCFServiceSell(45);
			targetReportDTO.setIYCFServiceTarget(43);
			/*String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,'{"
			        + branchIds + "}',:roleName,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
			        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
			        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
			dtos = query.list();*/
			dtos.add(targetReportDTO);
		}
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getDMServiceReportByManager(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,first_name firstName,last_name lastName ,user_id id,number_of_sk numberOfSK,number_of_branch numberOfBranch "
		        + " ,anc_target ANCServiceTarget,anc_sell ANCServiceSell,anc_tva ANCServiceAchievement "
		        + ",pnc_target PNCServiceTarget,pnc_sell PNCServiceSell,pnc_tva PNCServiceAchievement"
		        + " , women_target WomenServiceTarget,women_sell WomenServiceSell,women_tva WomenServiceAchievement "
		        + " , ncd_target NCDServiceTarget,ncd_sell NCDServiceSell , ncd_tva NCDServiceAchievement "
		        + ", adolescent_target AdolescentServiceTarget,adolescent_sell AdolescentServiceSell, adolescent_tva AdolescentServiceAchievement "
		        + ", iycf_target IYCFServiceTarget , iycf_sell IYCFServiceSell, iycf_tva IYCFServiceAchievement from report.dm_service_report_am_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.INTEGER).addScalar("numberOfSK", StandardBasicTypes.INTEGER)
		        .addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("PNCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("WomenServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("NCDServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("AdolescentServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("IYCFServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceAchievement", StandardBasicTypes.FLOAT)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getDMServiceReportByLocation(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,first_name firstName,last_name lastName ,user_id id,number_of_sk numberOfSK,number_of_branch numberOfBranch "
		        + " ,anc_target ANCServiceTarget,anc_sell ANCServiceSell,anc_tva ANCServiceAchievement "
		        + ",pnc_target PNCServiceTarget,pnc_sell PNCServiceSell,pnc_tva PNCServiceAchievement"
		        + " , women_target WomenServiceTarget,women_sell WomenServiceSell,women_tva WomenServiceAchievement "
		        + " , ncd_target NCDServiceTarget,ncd_sell NCDServiceSell , ncd_tva NCDServiceAchievement "
		        + ", adolescent_target AdolescentServiceTarget,adolescent_sell AdolescentServiceSell, adolescent_tva AdolescentServiceAchievement "
		        + ", iycf_target IYCFServiceTarget , iycf_sell IYCFServiceSell, iycf_tva IYCFServiceAchievement from report.dm_service_report_am_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.INTEGER).addScalar("numberOfSK", StandardBasicTypes.INTEGER)
		        .addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("PNCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("WomenServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("NCDServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("AdolescentServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("IYCFServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceAchievement", StandardBasicTypes.FLOAT)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getAMServiceReportByBranch(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select branch_name branchName,number_of_sk numberOfSK, "
		        + " anc_target ANCServiceTarget,anc_sell ANCServiceSell,anc_tva ANCServiceAchievement "
		        + ",pnc_target PNCServiceTarget,pnc_sell PNCServiceSell,pnc_tva PNCServiceAchievement"
		        + " , women_target WomenServiceTarget,women_sell WomenServiceSell,women_tva WomenServiceAchievement "
		        + " , ncd_target NCDServiceTarget,ncd_sell NCDServiceSell , ncd_tva NCDServiceAchievement "
		        + ", adolescent_target AdolescentServiceTarget,adolescent_sell AdolescentServiceSell, adolescent_tva AdolescentServiceAchievement "
		        + ", iycf_target IYCFServiceTarget , iycf_sell IYCFServiceSell, iycf_tva IYCFServiceAchievement from report.am_service_report_branch_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("numberOfSK", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("PNCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("WomenServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("NCDServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("AdolescentServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("IYCFServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceAchievement", StandardBasicTypes.FLOAT)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getAMVisitReportByBranch(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select branch_name branchName,total_sk numberOfSK,total_pa numberOfPA,target_vs_achv achievementInPercentage from report.am_visit_report_branch_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("numberOfSK", StandardBasicTypes.INTEGER).addScalar("numberOfPA", StandardBasicTypes.INTEGER)
		        .addScalar("achievementInPercentage", StandardBasicTypes.FLOAT)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getAMVisitReportByLocation(JSONObject params) {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		for (int i = 0; i < 20; i++) {
			TargetReportDTO targetReportDTO = new TargetReportDTO();
			targetReportDTO.setFirstName("Arif");
			targetReportDTO.setLastName("haque");
			targetReportDTO.setLocationName("Dhaka");
			targetReportDTO.setNumberOfSK(23);
			targetReportDTO.setNumberOfAm(12);
			targetReportDTO.setNumberOfBranch(3);
			targetReportDTO.setBranchName("Ratanpur");
			targetReportDTO.setAchievementInPercentage(23.3f);
			targetReportDTO.setAchievementInPercentage(23.3f);
			targetReportDTO.setANCServiceAchievement(78.34f);
			targetReportDTO.setANCServiceSell(34);
			targetReportDTO.setANCServiceTarget(41);
			
			targetReportDTO.setPNCServiceAchievement(62.5f);
			targetReportDTO.setPNCServiceSell(34);
			targetReportDTO.setPNCServiceTarget(40);
			
			targetReportDTO.setNCDServiceAchievement(45.4f);
			targetReportDTO.setNCDServiceSell(41);
			targetReportDTO.setNCDServiceTarget(50);
			
			targetReportDTO.setWomenServiceAchievement(34.4f);
			targetReportDTO.setWomenServiceSell(34);
			targetReportDTO.setWomenServiceTarget(32);
			
			targetReportDTO.setIYCFServiceAchievement(45.4f);
			targetReportDTO.setIYCFServiceSell(45);
			targetReportDTO.setIYCFServiceTarget(43);
			/*String hql = "select id branchId,branch_code branchCode,branch_name branchName,upazila_name upazilaName,total userCount from core.branch_list_by_location_with_user_list(:locationId,'{"
			        + branchIds + "}',:roleName,:start,:length)";
			Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
			        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
			        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
			        .setInteger("locationId", locationId).setString("roleName", roleName).setInteger("length", length)
			        .setInteger("start", start).setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
			dtos = query.list();*/
			dtos.add(targetReportDTO);
		}
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getAMServiceReportByProvider(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		String hql = "select user_name userName,branch_name branchName,first_name firstName,last_name lastName,mobile mobile, "
		        + " anc_target ANCServiceTarget,anc_sell ANCServiceSell,anc_tva ANCServiceAchievement "
		        + ",pnc_target PNCServiceTarget,pnc_sell PNCServiceSell,pnc_tva PNCServiceAchievement"
		        + " , women_target WomenServiceTarget,women_sell WomenServiceSell,women_tva WomenServiceAchievement "
		        + " , ncd_target NCDServiceTarget,ncd_sell NCDServiceSell , ncd_tva NCDServiceAchievement "
		        + ", adolescent_target AdolescentServiceTarget,adolescent_sell AdolescentServiceSell, adolescent_tva AdolescentServiceAchievement "
		        + ", iycf_target IYCFServiceTarget , iycf_sell IYCFServiceSell, iycf_tva IYCFServiceAchievement from report.am_service_report_sk_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("userName", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .addScalar("lastName", StandardBasicTypes.STRING).addScalar("mobile", StandardBasicTypes.STRING)
		        .addScalar("ANCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("ANCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("PNCServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("PNCServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("WomenServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("WomenServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("NCDServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("NCDServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("AdolescentServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("AdolescentServiceAchievement", StandardBasicTypes.FLOAT)
		        .addScalar("IYCFServiceTarget", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceSell", StandardBasicTypes.INTEGER)
		        .addScalar("IYCFServiceAchievement", StandardBasicTypes.FLOAT)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetReportDTO> getAMVisitReportByProvider(JSONObject params) throws JSONException {
		
		Session session = getSessionFactory();
		
		List<TargetReportDTO> dtos = new ArrayList<TargetReportDTO>();
		
		String hql = "select branch_name branchName ,user_name userName,mobile mobile,first_name firstName,last_name lastName,hh_visit_target hhVisitTarget,hh_visit_ach hhVisitAchievement ,hh_visit_target_vs_achv hhVisitAchievementInPercentage "
		        + " ,elco_target elcoVisitTarget,elco_achv elcoVisitAchievement,elco_targte_vs_achv elcoVisitAchievementInPercentage "
		        + " ,  methods_users_target methodsUsersVisitTarget,methods_users_target_achv methodsUsersVisitAchievement,methods_users_target_vsachv methodsUsersVisitAchievementInPercentage "
		        + " ,adolescent_target adolescentMethodsUsersVisitTarget,adolescent_target_achv adolescentMethodsUsersVisitAchievement,adolescent_target_vs_achv adolescentMethodsUsersVisitAchievementInPercentage "
		        + " , pregnancy_identified_target pregnancydentifiedVisitTarget,pregnancy_identified_achv pregnancydentifiedVisitAchievement,pregnancy_identified_target_vs_achv pregnancydentifiedVisitAchievementInPercentage "
		        + " , delivery_target deliveryVisitTarget,delivery_achv deliveryVisitAchievement,delivery_target_vs_achv deliveryVisitAchievementInPercentage "
		        + " , institutionalized_target institutionalizedDeliveryVisitTarget,institutionalized_achv institutionalizedDeliveryVisitAchievement,institutionalized_target_vs_achv institutionalizedDeliveryVisitAchievementInPercentage "
		        + " , child_0_6_months_target Child06VisitTarget,child_0_6_months_achv Child06VisitAchievement,child_0_6_months_target_vs_achv Child06VisitAchievementInPercentage  "
		        + " , child_7_24_months_target Child724VisitTarget,child_7_24_months_achv Child724VisitAchievement,child_7_24_months_target_vs_achv Child724VisitAchievementInPercentage "
		        + " , child_18_36_months_target Child1836VisitTarget,child_18_36_months_achv Child1836VisitAchievement,child_18_36_months_target_vs_achv Child1836VisitAchievementInPercentage "
		        + " , pregnant_target pregnantVisitTarget ,pregnant_achv pregnantVisitAchievement,pregnant_target_vs_achv pregnantVisitAchievementInPercentage "
				+ " , immu_0_59_months_target immunizationVisitTarget, immu_0_59_months_achv immunizationVisitAchievement, sk_immu_0_59_months_target_vs_achv immunizationVisitAchievementInPercentage from report.am_visit_report_sk_wise('"
		        + params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("userName", StandardBasicTypes.STRING).addScalar("mobile", StandardBasicTypes.STRING)
		        .addScalar("firstName", StandardBasicTypes.STRING).addScalar("lastName", StandardBasicTypes.STRING)
		        .addScalar("hhVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("hhVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("hhVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("elcoVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("elcoVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("elcoVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("methodsUsersVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("methodsUsersVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("methodsUsersVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("adolescentMethodsUsersVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentMethodsUsersVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("adolescentMethodsUsersVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("pregnancydentifiedVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("pregnancydentifiedVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("pregnancydentifiedVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("deliveryVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("deliveryVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("deliveryVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("institutionalizedDeliveryVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("institutionalizedDeliveryVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("institutionalizedDeliveryVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("Child06VisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("Child06VisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("Child06VisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("Child724VisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("Child724VisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("Child724VisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("Child1836VisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("Child1836VisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("Child1836VisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .addScalar("pregnantVisitTarget", StandardBasicTypes.INTEGER)
		        .addScalar("pregnantVisitAchievement", StandardBasicTypes.INTEGER)
		        .addScalar("pregnantVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
				.addScalar("immunizationVisitTarget", StandardBasicTypes.INTEGER)
				.addScalar("immunizationVisitAchievement", StandardBasicTypes.INTEGER)
				.addScalar("immunizationVisitAchievementInPercentage", StandardBasicTypes.FLOAT)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetReportDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getBranchListForPositionalTargetCount(int locationId, String branchIds, String roleName) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.branch_list_by_location_with_user_list_count(:locationId,'{" + branchIds
		        + "}',:roleName)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setString("roleName", roleName);
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
	                                                                                 int month, int year, int day) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "select percentage, id Id, product_id productId ,product_name productName,quantity from core.get_target_info_by_branch_or_location_or_user_by_role_by_month(:roleId,:locationOrBranchOrUserId,:typeName,:locationTag,:month,:year,:day)";
		Query query = session.createSQLQuery(hql).addScalar("percentage", StandardBasicTypes.STRING)
		        .addScalar("Id", StandardBasicTypes.LONG).addScalar("productId", StandardBasicTypes.INTEGER)
		        .addScalar("productName", StandardBasicTypes.STRING).addScalar("quantity", StandardBasicTypes.INTEGER)
		        .setInteger("roleId", roleId).setInteger("locationOrBranchOrUserId", locationOrBranchOrUserId)
		        .setString("typeName", typeName).setString("locationTag", locationTag).setInteger("month", month)
		        .setInteger("year", year).setInteger("day", day)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TargetCommontDTO> getTargetInfoForPopulationWise(int roleId, int locationTagId, int month, int year) {
		
		Session session = getSessionFactory();
		List<TargetCommontDTO> dtos = new ArrayList<>();
		
		String hql = "" + "SELECT td.percentage as percentage, "
		        + "        cast(Coalesce(td.product_id, 0) as integer) as productId, "
		        + "       p.\"name\" as productName, " + "       Coalesce(td.quantity, 0) as quantity "
		        + "FROM   core.target_details td " + "       join core.product p " + "         ON p.id = td.product_id "
		        + "       join core.user_role r " + "         ON td.user_id = r.user_id "
		        + "       join core.users_catchment_area cat " + "         ON cat.user_id = td.user_id "
		        + "       join core.\"location\" l " + "         ON cat.location_id = l.id "
		        + "       join core.location_tag ltag " + "         ON l.location_tag_id = ltag.id "
		        + "       join core.union_wise_population wp " + "         ON l.id = wp.union_id " + "WHERE  r.role_id = "
		        + roleId + " " + "       AND ltag.id = " + locationTagId + " " + "       AND td.\"month\" = " + month + " "
		        + "       AND td.\"year\" = " + year + " " + "       AND p.status = 'ACTIVE'   AND td.percentage != '0' "
		        + " GROUP  BY td.product_id, " + "          p.\"name\", " + "          td.quantity, "
		        + "          td.percentage;";
		Query query = session.createSQLQuery(hql).addScalar("percentage", StandardBasicTypes.STRING)
		        .addScalar("productId", StandardBasicTypes.INTEGER).addScalar("productName", StandardBasicTypes.STRING)
		        .addScalar("quantity", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(TargetCommontDTO.class));
		dtos = query.list();
		
		return dtos;
	}

	@Transactional
	public List<ForumTargetReportDTO> getForumReportForPMByManager(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<ForumTargetReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.pm_forum_report_by_dm('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("username", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("numberOfAM", StandardBasicTypes.INTEGER)
				.addScalar("numberOfSK", StandardBasicTypes.INTEGER)
				.addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
				.addScalar("adolescentAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTarget", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantTarget", StandardBasicTypes.INTEGER)

				.setResultTransformer(new AliasToBeanResultTransformer(ForumTargetReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<ForumTargetReportDTO> getForumReportForDMByAM(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<ForumTargetReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.dm_forum_report_by_am('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("username", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("numberOfSK", StandardBasicTypes.INTEGER)
				.addScalar("numberOfBranch", StandardBasicTypes.INTEGER)
				.addScalar("adolescentAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTarget", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantTarget", StandardBasicTypes.INTEGER)

				.setResultTransformer(new AliasToBeanResultTransformer(ForumTargetReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<ForumTargetReportDTO> getForumReportForAMByBranch(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<ForumTargetReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.am_forum_report_by_branch('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("branchName", StandardBasicTypes.STRING)
				.addScalar("numberOfSK", StandardBasicTypes.INTEGER)
				.addScalar("adolescentAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTarget", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantTarget", StandardBasicTypes.INTEGER)

				.setResultTransformer(new AliasToBeanResultTransformer(ForumTargetReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<ForumTargetReportDTO> getForumReportForAMBySK(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<ForumTargetReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.am_forum_report_by_sk('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("branchName", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("adolescentAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTarget", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adolescnetAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdTarget", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("ncdAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfTarget", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("iycfAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenTarget", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("womenAvgParticipantTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultTarget", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantAchv", StandardBasicTypes.INTEGER)
				.addScalar("adultAvgParticipantTarget", StandardBasicTypes.INTEGER)

				.setResultTransformer(new AliasToBeanResultTransformer(ForumTargetReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<HrReportDTO> getHRReportDMWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<HrReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.pm_hr_report_dm_wise('"+  params + "')";
		Query query = session.createSQLQuery(hql)
				.addScalar("dmName", StandardBasicTypes.STRING)
				.addScalar("totalAm", StandardBasicTypes.INTEGER)
				.addScalar("totalBranch", StandardBasicTypes.INTEGER)
				.addScalar("positions", StandardBasicTypes.INTEGER)
				.addScalar("activeUsers", StandardBasicTypes.INTEGER)
				.addScalar("onLeaveUsers", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(HrReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<HrReportDTO> getHRReportAMWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<HrReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.dm_hr_report_am_wise('"+  params + "')";
		Query query = session.createSQLQuery(hql)
				.addScalar("amName", StandardBasicTypes.STRING)
				.addScalar("totalBranch", StandardBasicTypes.INTEGER)
				.addScalar("positions", StandardBasicTypes.INTEGER)
				.addScalar("activeUsers", StandardBasicTypes.INTEGER)
				.addScalar("onLeaveUsers", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(HrReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<HrReportDTO> getHRReportBranchWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<HrReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.am_hr_report_branch_wise('"+  params + "')";
		Query query = session.createSQLQuery(hql)
				.addScalar("branchName", StandardBasicTypes.STRING)
				.addScalar("positions", StandardBasicTypes.INTEGER)
				.addScalar("activeUsers", StandardBasicTypes.INTEGER)
				.addScalar("onLeaveUsers", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(HrReportDTO.class));
		dtos = query.list();

		return dtos;
	}

	@Transactional
	public List<TimestamReportDTO> getPMTimestapmReportDMWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<TimestamReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.pm_timestamp_report_dm_wise('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("providerUserName", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("iycfTime", StandardBasicTypes.INTEGER)
				.addScalar("ancTime", StandardBasicTypes.INTEGER)
				.addScalar("ncdTime", StandardBasicTypes.INTEGER)
				.addScalar("womenTime", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTime", StandardBasicTypes.INTEGER)
				.addScalar("hhVisitTime", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(TimestamReportDTO.class));
		dtos = query.list();
		return dtos;
	}

	@Transactional
	public List<TimestamReportDTO> getDMTimestapmReportAMWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<TimestamReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.dm_timestamp_report_am_wise('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("providerUserName", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("iycfTime", StandardBasicTypes.INTEGER)
				.addScalar("ancTime", StandardBasicTypes.INTEGER)
				.addScalar("ncdTime", StandardBasicTypes.INTEGER)
				.addScalar("womenTime", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTime", StandardBasicTypes.INTEGER)
				.addScalar("hhVisitTime", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(TimestamReportDTO.class));
		dtos = query.list();
		return dtos;
	}

	@Transactional
	public List<TimestamReportDTO> getAMTimestapmReportBranchWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<TimestamReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.am_timestamp_report_branch_wise('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("branchName", StandardBasicTypes.STRING)
				.addScalar("iycfTime", StandardBasicTypes.INTEGER)
				.addScalar("ancTime", StandardBasicTypes.INTEGER)
				.addScalar("ncdTime", StandardBasicTypes.INTEGER)
				.addScalar("womenTime", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTime", StandardBasicTypes.INTEGER)
				.addScalar("hhVisitTime", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(TimestamReportDTO.class));
		dtos = query.list();
		return dtos;
	}

	@Transactional
	public List<TimestamReportDTO> getAMTimestapmReportProviderWise(JSONObject params) throws JSONException {

		Session session = getSessionFactory();
		List<TimestamReportDTO> dtos = new ArrayList<>();

		String hql = "select * from report.am_timestamp_report_provider_wise('"+  params + "','{" + params.getString("branchIds") + "}')";
		Query query = session.createSQLQuery(hql)
				.addScalar("providerUserName", StandardBasicTypes.STRING)
				.addScalar("fullName", StandardBasicTypes.STRING)
				.addScalar("branchName", StandardBasicTypes.STRING)
				.addScalar("iycfTime", StandardBasicTypes.INTEGER)
				.addScalar("ancTime", StandardBasicTypes.INTEGER)
				.addScalar("ncdTime", StandardBasicTypes.INTEGER)
				.addScalar("womenTime", StandardBasicTypes.INTEGER)
				.addScalar("adolescentTime", StandardBasicTypes.INTEGER)
				.addScalar("hhVisitTime", StandardBasicTypes.INTEGER)
				.setResultTransformer(new AliasToBeanResultTransformer(TimestamReportDTO.class));
		dtos = query.list();
		return dtos;
	}
}
