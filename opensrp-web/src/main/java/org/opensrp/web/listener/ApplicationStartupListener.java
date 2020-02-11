/**
 * @author proshanto
 * */

package org.opensrp.web.listener;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.log4j.Logger;
import org.opensrp.web.util.DefaultApplicationSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class ApplicationStartupListener implements ApplicationListener<ContextRefreshedEvent> {
	
	private static final Logger logger = Logger.getLogger(ApplicationStartupListener.class);
	
	@Autowired
	private DefaultApplicationSettingService defaultSystemSettingService;
	
	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		
		if (event.getApplicationContext().getParent() != null) {
			logger.info("Opensrp Dashboard " + " Application Stating............" + event.getApplicationContext().getId());
			try {
				defaultSystemSettingService.saveDefaultAppSetting();
			}
			catch (ClassNotFoundException | SQLException | IOException e) {
				e.printStackTrace();
			}
		}
	}
}
