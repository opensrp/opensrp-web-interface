package org.opensrp.web.util;

import org.springframework.beans.factory.annotation.Value;

public abstract class PropertiesValue {
	
	@Value("#{opensrp['division.tag.id']}")
	protected int divisionTagId;
	
	public PropertiesValue(int divisionTagId) {
		
		this.divisionTagId = divisionTagId;
	}
	
}
