package com.fabijanbajo.orders;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface OrderController {
	@PostMapping(
		value = "/orders",
		consumes = "application/json",
		produces = "application/json"
	)
	Order createOrder(@RequestBody Order body);
	
	@GetMapping(
		value = "/orders",
		produces = "application/json"
	)
	Flux<Order> getOrders();

	@GetMapping(
		value = "/orders/{orderId}",
		produces = "application/json"
	)
	Mono<Order> getOrder(@PathVariable String orderId);

	@DeleteMapping(value = "/orders/{orderId}")
	void deleteOrder(@PathVariable String orderId);
}
