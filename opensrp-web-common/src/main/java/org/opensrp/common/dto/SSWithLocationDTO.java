package org.opensrp.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class SSWithLocationDTO {
	@JsonProperty("ss_id")
	Integer ssId;

	@JsonProperty("ss_location_id")
	Integer ssLocationId;

	public Integer getSsId() {
		return ssId;
	}

	public void setSsId(Integer ssId) {
		this.ssId = ssId;
	}

	public Integer getSsLocationId() {
		return ssLocationId;
	}

	public void setSsLocationId(Integer ssLocationId) {
		this.ssLocationId = ssLocationId;
	}
}
