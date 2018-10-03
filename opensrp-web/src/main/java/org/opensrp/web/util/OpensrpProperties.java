/**
 * 
 */
package org.opensrp.web.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @author proshanto
 */
@Component
public abstract class OpensrpProperties {
	
	@Value("#{opensrp['dashboard.url']}")
	protected String dashboardUrl;
	
	public OpensrpProperties() {
		
	}
	
	public OpensrpProperties(String dashboardUrl) {
		this.dashboardUrl = dashboardUrl;
	}
}
