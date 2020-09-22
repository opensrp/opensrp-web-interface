/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
import org.opensrp.common.dto.WebNotificationCommonDTO;
import org.opensrp.common.util.DateUtil;
import org.opensrp.common.util.TaregtSettingsType;
import org.opensrp.common.util.WebNotificationType;
import org.opensrp.core.dto.WebNotificationDTO;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.WebNotification;
import org.opensrp.core.entity.WebNotificationUser;
import org.opensrp.core.mapper.WebNotificationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class WebNotificationService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(WebNotificationService.class);
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	private WebNotificationMapper webNotificationMapper;
	
	public WebNotificationService() {
		
	}
	
	@Transactional
	public <T> Integer saveAll(WebNotificationDTO dto) throws Exception {
		Session session = getSessionFactory();
		
		WebNotification webNotification = findById(dto.getId(), "id", WebNotification.class);
		if (webNotification == null) {
			webNotification = new WebNotification();
		} else {
			boolean isDelete = deleteAllByPrimaryKey(dto.getId(), "web_notification_user", "web_notification_id");
			if (!isDelete) {
				return null;
			}
		}
		
		List<TargetCommontDTO> targetTos = getAllUser(dto.getRoles(), TaregtSettingsType.valueOf(dto.getLocationType())
		        .name(), dto.getLocationTypeId());
		
		Set<WebNotificationUser> _webNotificationUsers = new HashSet<>();
		for (TargetCommontDTO webNotificationUser : targetTos) {
			WebNotificationUser _webNotificationUser = new WebNotificationUser();
			_webNotificationUser.setUserId(webNotificationUser.getUserId());
			_webNotificationUser.setWebNotification(webNotification);
			_webNotificationUsers.add(_webNotificationUser);
		}
		
		webNotification.setWebNotifications(_webNotificationUsers);
		webNotification = webNotificationMapper.map(dto, webNotification);
		session.saveOrUpdate(webNotification);
		
		return 1;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<WebNotificationCommonDTO> getWebNotificationList(int locationId, int branchId, int roleId, String startDate,
	                                                             String endDate, String type, Integer length, Integer start,
	                                                             String orderColumn, String orderDirection) {
		
		Session session = getSessionFactory();
		List<WebNotificationCommonDTO> dtos = new ArrayList<>();
		
		String hql = "select created createdTime, id,title,notification,start_date sendDate,send_time_hour sendTimeHour,send_time_minute sendTimeMinute,branch_name branchName,branch_code branchCode,role_name roleName,type from core.web_notification_list( :locationId,:branchId ,:roleId,:startDate ,:endDate, :type, :start, :length)";
		Query query = session.createSQLQuery(hql).addScalar("createdTime", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("title", StandardBasicTypes.STRING)
		        .addScalar("notification", StandardBasicTypes.STRING).addScalar("sendDate", StandardBasicTypes.DATE)
		        .addScalar("sendTimeHour", StandardBasicTypes.INTEGER)
		        .addScalar("sendTimeMinute", StandardBasicTypes.INTEGER).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("type", StandardBasicTypes.STRING).setInteger("locationId", locationId)
		        .setInteger("branchId", branchId).setInteger("roleId", roleId).setString("startDate", startDate)
		        .setString("endDate", endDate).setString("type", type).setInteger("start", start)
		        .setInteger("length", length)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(WebNotificationCommonDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getWebNotificationListCount(int locationId, int branchId, int roleId, String startDate, String endDate,
	                                       String type) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.web_notification_list_count( :locationId,:branchId,:roleId,:startDate,:endDate,:type)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
		        .setInteger("roleId", roleId).setString("startDate", startDate).setString("endDate", endDate)
		        .setString("type", type);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject drawDataTableOfWebNotification(Integer draw, int total, List<WebNotificationCommonDTO> dtos,
	                                                 String type) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw + 1);
		response.put("recordsTotal", total);
		response.put("recordsFiltered", total);
		JSONArray array = new JSONArray();
		for (WebNotificationCommonDTO dto : dtos) {
			JSONArray patient = new JSONArray();
			
			String view = "";
			if (dto.getType().equalsIgnoreCase(WebNotificationType.SCHEDULE.name())) {
				patient.put(dto.getSendDate() + " " + dto.getSendTimeHour() + ":" + dto.getSendTimeMinute());
				String date = dto.getSendDate() + " " + dto.getSendTimeHour() + ":" + dto.getSendTimeMinute();
				if (DateUtil.getTimestamp(date) > System.currentTimeMillis()) {
					
					view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"details/" + dto.getId() + ".html\">Details</a> "
					        + " | <a class='text-primary' \" href=\"edit/" + dto.getId() + ".html\">Edit</a> " + "</div>";
					
				} else {
					
					view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"details/" + dto.getId()
					        + ".html\">Details</a> </div>";
				}
			} else if (dto.getType().equalsIgnoreCase(WebNotificationType.DRAFT.name())) {
				patient.put(dto.getCreatedTime());
				view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"details/" + dto.getId() + ".html\">Details</a> "
				        + " | <a class='text-primary' \" href=\"edit/" + dto.getId() + ".html\">Edit</a> " + "</div>";
			} else {
				patient.put(dto.getCreatedTime());
				view = "<div class='col-sm-12 form-group'><a class='text-primary' \" href=\"details/" + dto.getId()
				        + ".html\">Details</a> </div>";
			}
			
			patient.put(dto.getType());
			patient.put(dto.getTitle());
			patient.put(dto.getRoleName());
			
			patient.put(view);
			array.put(patient);
		}
		response.put("data", array);
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Role> getWebNotificationRoles() {
		
		Session session = getSessionFactory();
		List<Role> dtos = new ArrayList<>();
		
		String hql = "select id,name from core.web_notification_roles()";
		Query query = session.createSQLQuery(hql).setResultTransformer(new AliasToBeanResultTransformer(Role.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<WebNotificationCommonDTO> getWebNotificationDetailsById(long notificationId) {
		
		Session session = getSessionFactory();
		List<WebNotificationCommonDTO> dtos = new ArrayList<>();
		
		String hql = "select title,notification,status,notification_type as type,send_date_and_time createdTime,branch_name as branchName,division_name divisionName,district_name districtName,upazilla_name upazillaName,role_name as roleName from core.web_notification_details(:notificationId)";
		Query query = session.createSQLQuery(hql).addScalar("title", StandardBasicTypes.STRING)
		        .addScalar("notification", StandardBasicTypes.STRING)
		        .addScalar("status", StandardBasicTypes.STRING)
		        .addScalar("type", StandardBasicTypes.STRING)
		        .addScalar("createdTime", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("divisionName", StandardBasicTypes.STRING)
		        .addScalar("districtName", StandardBasicTypes.STRING)
		        .addScalar("upazillaName", StandardBasicTypes.STRING)
		        .addScalar("roleName", StandardBasicTypes.STRING)
		        .setLong("notificationId", notificationId)
		        
		        .setResultTransformer(new AliasToBeanResultTransformer(WebNotificationCommonDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
}
