package com.fabijanbajo.catalog.common;

public class HttpExceptionInfo {
	
	private final int status;
	private final String message;

	public HttpExceptionInfo() {
		this.status = 0;
		this.message = null;
	}

	public HttpExceptionInfo(
			int status,
			String message) {
		this.status = status;
		this.message = message;
	}

	public int getStatus() {
		return status;
	}
	public String getMessage() {
		return message;
	}
}
