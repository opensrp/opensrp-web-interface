package org.opensrp.common.exception;

public class LocationNotFoundException extends Exception {

	private String errorMessage;

	public LocationNotFoundException(String message) {
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
