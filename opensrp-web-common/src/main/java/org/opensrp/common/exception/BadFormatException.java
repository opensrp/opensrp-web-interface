package org.opensrp.common.exception;

public class BadFormatException extends Exception {

	private String errorMessage;

	public BadFormatException(String message) {
		super(message);
		this.errorMessage = message;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
