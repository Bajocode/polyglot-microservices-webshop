package com.fabijanbajo.products;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ProductController {

	@PostMapping(
		value = "/products",
		consumes = "application/json",
		produces = "application/json"
	)
	Mono<Product> createProduct(@RequestBody Product product);
	
	@GetMapping(
		value = "/products",
		produces = "application/json"
	)
	Flux<Product> getProducts();

	@GetMapping(
		value = "/products/{productId}",
		produces = "application/json"
	)
	Mono<Product> getProduct(@PathVariable String productId);

	@DeleteMapping(value = "/products/{productId}")
	void deleteProduct(@PathVariable String productId);
}
