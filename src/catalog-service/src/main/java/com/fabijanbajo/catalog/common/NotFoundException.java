package com.fabijanbajo.catalog.common;

import org.springframework.web.server.ResponseStatusException;
import static org.springframework.http.HttpStatus.NOT_FOUND;

public class NotFoundException extends ResponseStatusException {

	public NotFoundException() {
		super(NOT_FOUND);
	}

	public NotFoundException(String message) {
		super(NOT_FOUND, message);
	}

	public NotFoundException(String message, Throwable cause) {
		super(NOT_FOUND, message, cause);
	}
}
