package org.opensrp.connector.openmrs.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.opensrp.connector.util.HttpUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public abstract class OpensrpCredentialsService {
	@Value("#{opensrp['opensrp.url']}")
	protected String OPENSRP_BASE_URL;

	@Value("#{opensrp['opensrp.username']}")
	protected String OPENSRP_USER;

	@Value("#{opensrp['opensrp.password']}")
	protected String OPENSRP_PWD;

	public static final SimpleDateFormat OPENSRP_DATE = new SimpleDateFormat("yyyy-MM-dd");
	public OpensrpCredentialsService() {	}

	public OpensrpCredentialsService(String opensrpUrl, String user, String password) {
		OPENSRP_BASE_URL = opensrpUrl;
		OPENSRP_USER = user;
		OPENSRP_PWD = password;
	}

	/**
	 * returns url after trimming ending slash
	 * @return
	 */
	public String getURL() {
		return HttpUtil.removeEndingSlash(OPENSRP_BASE_URL);
	}

	void setURL(String url) {
		OPENSRP_BASE_URL = url;
	}

	public static void main(String[] args) {
		System.out.println(OPENSRP_DATE.format(new Date()));
	}

}
