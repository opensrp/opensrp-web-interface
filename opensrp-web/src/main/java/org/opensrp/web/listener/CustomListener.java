package org.opensrp.web.listener;

import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.exolab.castor.types.DateTime;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.common.util.AllConstant;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.service.ChildGrowthService;
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
	private ChildGrowthService childGrowthServiceImpl;
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	public void startCalculateChildGrowth() throws Exception {
		searchBuilder.clear();
		List<Object[]> viewRefresh = databaseServiceImpl.refreshView(searchBuilder);
		int refreshCount = 0;
		Iterator obArrIterator = viewRefresh.iterator();
		if (obArrIterator.hasNext()) {
			refreshCount = refreshCount + (Integer) obArrIterator.next();
		}
		logger.info("refreshCount:" + refreshCount);
		//childGrowthServiceImpl.startCalculateChildGrowth();
	}

	public void updatingActionParser() throws Exception {
		searchBuilder.clear();
		databaseServiceImpl.actionParser(searchBuilder);
	}
}
