package org.opensrp.common.util;

public enum HouseholdColumn {
	_1("household_id"), _0("household_head"), _3("number_Of_member"), _2("registration_date"), _4("last_visit_date"), _5(
	        "village"), _6(""), _7("contact"), _8("");
	
	private String value;
	
	HouseholdColumn(String value) {
		this.value = value;
	}
	
	public String getValue() {
		return this.value;
	}
	
}
