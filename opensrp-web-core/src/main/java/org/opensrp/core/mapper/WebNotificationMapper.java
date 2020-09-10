package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.Status;
import org.opensrp.common.util.WebNotificationType;
import org.opensrp.core.dto.WebNotificationDTO;
import org.opensrp.core.entity.WebNotification;
import org.opensrp.core.entity.WebNotificationRole;
import org.opensrp.core.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class WebNotificationMapper {
	
	@Autowired
	private TrainingService trainingService;
	
	public WebNotification map(WebNotificationDTO dto, WebNotification webNotification) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = (User) auth.getPrincipal();
		
		webNotification.setNotificationTitle(dto.getNotificationTitle());
		webNotification.setNotification(dto.getNotification());
		
		webNotification.setBranch(dto.getBranch());
		
		webNotification.setTimestamp(System.currentTimeMillis());
		webNotification.setStatus(Status.valueOf(dto.getStatus()).name());
		webNotification.setType(WebNotificationType.valueOf(dto.getType()).name());
		
		webNotification.setType(dto.getType());
		webNotification.setDistrict(dto.getDistrict());
		webNotification.setDivision(dto.getDivision());
		webNotification.setUpazila(dto.getUpazila());
		webNotification.setRoleId(dto.getRoleId());
		webNotification.setSendDate(dto.getSendDate());
		webNotification.setSendTimeHour(dto.getSendTimeHour());
		webNotification.setSendTimeMinute(dto.getSendTimeMinute());
		
		Set<WebNotificationRole> _webNotificationRoles = new HashSet<>();
		
		for (Integer roleId : dto.getRoles()) {
			WebNotificationRole _webNotificationRole = new WebNotificationRole();
			_webNotificationRole.setRole(roleId);
			_webNotificationRole.setWebNotification(webNotification);
			_webNotificationRoles.add(_webNotificationRole);
		}
		webNotification.setWebNotificationRoles(_webNotificationRoles);
		
		if (webNotification.getId() != null && (webNotification.getId() != 0)) {
			
			webNotification.setUpdatedBy(user.getId());
			
		} else {
			webNotification.setCreator(user.getId());
			webNotification.setUuid(UUID.randomUUID().toString());
		}
		
		return webNotification;
		
	}
}
