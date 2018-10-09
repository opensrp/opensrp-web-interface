package org.opensrp.common.util;

import java.text.SimpleDateFormat;

import org.opensrp.connector.util.HttpUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public abstract class OpensrpProperties {
	
	@Value("#{opensrp['openmrs.url']}")
	protected String OPENMRS_BASE_URL;
	
	@Value("#{opensrp['openmrs.username']}")
	protected String OPENMRS_USER;
	
	@Value("#{opensrp['openmrs.password']}")
	protected String OPENMRS_PWD;
	
	@Value("#{opensrp['openmrs.login.location.tag.id']}")
	protected String loginLocationId;
	
	@Value("#{opensrp['openmrs.visit.location.tag.id']}")
	protected String visitLocationId;
	
	public static final SimpleDateFormat OPENMRS_DATE = new SimpleDateFormat("yyyy-MM-dd");
	
	public OpensrpProperties() {
	}
	
	public OpensrpProperties(String openmrsUrl, String user, String password, String loginLocationId, String visitLocationId) {
		OPENMRS_BASE_URL = openmrsUrl;
		OPENMRS_USER = user;
		OPENMRS_PWD = password;
		this.loginLocationId = loginLocationId;
		this.visitLocationId = visitLocationId;
	}
	
	/**
	 * returns url after trimming ending slash
	 * 
	 * @return
	 */
	public String getURL() {
		return HttpUtil.removeEndingSlash(OPENMRS_BASE_URL);
	}
	
	void setURL(String url) {
		OPENMRS_BASE_URL = url;
	}
	
}
