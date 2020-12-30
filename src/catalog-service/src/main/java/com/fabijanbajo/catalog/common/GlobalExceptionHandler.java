package com.fabijanbajo.catalog.common;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalExceptionHandler {
	 
	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@ExceptionHandler(ResponseStatusException.class)
	public @ResponseBody HttpExceptionInfo handleHttpExceptions(
			ServerHttpRequest request,
			ServerHttpResponse response,
			ResponseStatusException exception) {
		response.setStatusCode(exception.getStatus());
		logger.error(stringifyTrace(exception));

		return new HttpExceptionInfo(
				exception.getStatus().value(),
				exception.getReason());
	}

	private String stringifyTrace(Exception exception) {
		Writer stringWriter = new StringWriter();
		PrintWriter printWriter = new PrintWriter(stringWriter);
		exception.printStackTrace(printWriter);
		return stringWriter.toString();
	}
}
