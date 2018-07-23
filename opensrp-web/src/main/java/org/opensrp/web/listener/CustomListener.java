package org.opensrp.web.listener;

import org.apache.log4j.Logger;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.common.util.AllConstant;
import org.opensrp.web.nutrition.service.impl.ChildGrowthServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Service;

@Service
@EnableScheduling
@Configuration
@EnableAsync
public class CustomListener {
	
	private static final Logger logger = Logger.getLogger(CustomListener.class);
	
	@Autowired
	private ChildGrowthServiceImpl childGrowthServiceImpl;
	
	public void startCalculateChildGrowth() throws Exception {
		childGrowthServiceImpl.startCalculateChildGrowth();
	}
}
