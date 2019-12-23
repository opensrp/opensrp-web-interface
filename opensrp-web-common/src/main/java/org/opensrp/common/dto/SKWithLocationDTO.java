package org.opensrp.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class SKWithLocationDTO {

	@JsonProperty("sk_id")
	Integer skId;

	@JsonProperty("sk_location_id")
	Integer skLocationId;

	@JsonProperty("ss_of_sk")
	List<SSWithUCAIdDTO> ssWithUCAIdDTOList;

	public Integer getSkId() {
		return skId;
	}

	public void setSkId(Integer skId) {
		this.skId = skId;
	}

	public Integer getSkLocationId() {
		return skLocationId;
	}

	public void setSkLocationId(Integer skLocationId) {
		this.skLocationId = skLocationId;
	}

	public List<SSWithUCAIdDTO> getSsWithUCAIdDTOList() {
		return ssWithUCAIdDTOList;
	}

	public void setSsWithUCAIdDTOList(List<SSWithUCAIdDTO> ssWithUCAIdDTOList) {
		this.ssWithUCAIdDTOList = ssWithUCAIdDTOList;
	}
}
