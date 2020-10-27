package com.fabijanbajo.catalog.products;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
public class ProductControllerImpl implements ProductController {
	private static final Logger LOG = LoggerFactory.getLogger(ProductControllerImpl.class);
	private final ProductRepository repository;

	@Autowired
	public ProductControllerImpl(ProductRepository repository) {
		this.repository = repository;
	}

	@Override
	public Mono<Product> createProduct(Product product) {
		return repository.save(product);
	}

	@Override
	public Flux<Product> getProducts() {
		return repository.findAll();
	}
	
	@Override
	public Mono<Product> getProduct(String productId) {
		return repository.findById(productId);
	}

	@Override
	public Mono<Void> deleteProduct(String productId) {
		return repository.deleteById(productId);
	}
}
