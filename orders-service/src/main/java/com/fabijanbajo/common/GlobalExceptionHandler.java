package com.fabijanbajo.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;


import static org.springframework.http.HttpStatus.NOT_FOUND;
import static org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY;

@RestControllerAdvice
class GlobalExceptionHandler {
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@ResponseStatus(NOT_FOUND)
	@ExceptionHandler(NotFoundException.class)
	public @ResponseBody
	HttpErrorInfo handleNotFoundExceptions(ServerHttpRequest req, Exception ex) {
		return createInfo(NOT_FOUND, req, ex);
	}

	@ResponseStatus(UNPROCESSABLE_ENTITY)
	@ExceptionHandler(InvalidInputException.class)
	public @ResponseBody
	HttpErrorInfo handleInvalidInputExceptions(ServerHttpRequest req, Exception ex) {
		return createInfo(UNPROCESSABLE_ENTITY, req, ex);
	}
	
	private HttpErrorInfo createInfo(HttpStatus status, ServerHttpRequest req, Exception ex) {
		final String path = req.getPath().pathWithinApplication().value();
		final String msg = ex.getMessage();

		logger.debug("HANDLED BY GlobalControllerExceptionHandler");
		logger.debug("Returning HTTP status: {} for path: {}, message: {}", status, path, msg);

		return new HttpErrorInfo(status, path, msg);
	}
}
