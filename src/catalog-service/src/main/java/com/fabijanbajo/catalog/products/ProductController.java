package com.fabijanbajo.catalog.products;

import java.util.Optional;
import java.util.UUID;
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
	Flux<Product> getProducts(
			@RequestParam(name = "category", required = false) Optional<Integer> categoryid,
			@RequestParam(name = "ids", required = false) Optional<String> productids);

	@GetMapping(
		value = "/catalog/products/{productid}",
		produces = "application/json"
	)
	Mono<Product> getProduct(@PathVariable UUID productid);

	@DeleteMapping(value = "/catalog/products/{productid}")
	Mono<Void> deleteProduct(@PathVariable UUID productid);
}
