package org.opensrp.web.model;

import org.springframework.stereotype.Service;

@Service
public class ClientInfo {

	String name;
	String householdNumber;
	String ssName;

	public ClientInfo() {
	}

	public ClientInfo(String name, String householdNumber, String ssName) {
		this.name = name;
		this.householdNumber = householdNumber;
		this.ssName = ssName;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getHouseholdNumber() {
		return householdNumber;
	}

	public void setHouseholdNumber(String householdNumber) {
		this.householdNumber = householdNumber;
	}

	public String getSsName() {
		return ssName;
	}

	public void setSsName(String ssName) {
		this.ssName = ssName;
	}
}
