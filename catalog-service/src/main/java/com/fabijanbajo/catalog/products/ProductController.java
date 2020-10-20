package com.fabijanbajo.catalog.products;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ProductController {

	@PostMapping(
		value = "/catalog/products",
		consumes = "application/json",
		produces = "application/json"
	)
	Mono<Product> createProduct(@RequestBody Product product);
	
	@GetMapping(
		value = "/catalog/products",
		produces = "application/json"
	)
	Flux<Product> getProducts();

	@GetMapping(
		value = "/catalog/products/{productId}",
		produces = "application/json"
	)
	Mono<Product> getProduct(@PathVariable String productId);

	@DeleteMapping(value = "/catalog/products/{productId}")
	Mono<Void> deleteProduct(@PathVariable String productId);
}
