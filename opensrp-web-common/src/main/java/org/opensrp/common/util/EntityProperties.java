package org.opensrp.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public abstract class EntityProperties {
	@Value("#{opensrp['project.entity']}")
	protected String PROJECT_ENTITY;

	@Value("#{opensrp['project.woman']}")
	protected String WOMAN_ENTITY;

	public static final SimpleDateFormat OPENSRP_DATE = new SimpleDateFormat("yyyy-MM-dd");
	public EntityProperties() {	}

	public EntityProperties(String opensrpUrl) {
		PROJECT_ENTITY = opensrpUrl;
	}

	public static void main(String[] args) {
		System.out.println(OPENSRP_DATE.format(new Date()));
	}

}


