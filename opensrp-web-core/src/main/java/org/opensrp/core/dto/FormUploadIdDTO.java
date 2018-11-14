package org.opensrp.core.dto;

public class FormUploadIdDTO {
	
	private int formId;
	
	public int getFormId() {
		return formId;
	}
	
	public void setFormId(int formId) {
		this.formId = formId;
	}
	
	@Override
	public String toString() {
		return "FormUploadIdDao [formId=" + formId + "]";
	}
	
}
