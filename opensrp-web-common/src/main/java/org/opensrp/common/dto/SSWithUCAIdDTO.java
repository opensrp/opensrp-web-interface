package org.opensrp.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class SSWithUCAIdDTO {

	@JsonProperty("uca_id")
	Integer ucaId;

	@JsonProperty("ss_name")
	String ssName;

	public Integer getUcaId() {
		return ucaId;
	}

	public void setUcaId(Integer ucaId) {
		this.ucaId = ucaId;
	}

	public String getSsName() {
		return ssName;
	}

	public void setSsName(String ssName) {
		this.ssName = ssName;
	}
}
