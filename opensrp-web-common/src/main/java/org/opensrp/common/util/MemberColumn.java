package org.opensrp.common.util;

public enum MemberColumn {
	_0(""), _4("age"), _5("gender"), _6("");
	
	private String value;
	
	MemberColumn(String value) {
		this.value = value;
	}
	
	public String getValue() {
		return this.value;
	}
	
}
