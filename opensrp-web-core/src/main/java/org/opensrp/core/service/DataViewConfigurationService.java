/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.entity.DataViewConfiguration;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DataViewConfigurationService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(DataViewConfigurationService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public DataViewConfigurationService() {
		
	}
	
	@Transactional
	public JSONObject getConfigurationByNameFormName(String formName) throws JSONException {
		List<DataViewConfiguration> configurations = findAllByKey(formName, "formName", DataViewConfiguration.class);
		
		JSONObject config = new JSONObject();
		for (DataViewConfiguration dataViewConfiguration : configurations) {
			
			config.put(dataViewConfiguration.getKeyName(), dataViewConfiguration.getValue());
			System.err.println(config);
		}
		
		return config;
	}
}
