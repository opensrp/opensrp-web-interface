/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.util.TaregtSettingsType;
import org.opensrp.core.dto.WebNotificationDTO;
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
		
		List<TargetCommontDTO> targetTos = targetService.allTargetUser(dto.getRoleId(),
		    TaregtSettingsType.valueOf(dto.getLocationType()).name(), dto.getLocationTypeId());
		
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
}
