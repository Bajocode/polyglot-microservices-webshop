package com.fabijanbajo.catalog.common;

import org.springframework.web.server.ResponseStatusException;
import static org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY;

public class InvalidInputException extends ResponseStatusException {

	public InvalidInputException() {
		super(UNPROCESSABLE_ENTITY);
	}

	public InvalidInputException(String message) {
		super(UNPROCESSABLE_ENTITY, message);
	}

	public InvalidInputException(String message, Throwable cause) {
		super(UNPROCESSABLE_ENTITY, message, cause);
	}
}
