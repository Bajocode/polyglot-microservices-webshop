package com.fabijanbajo.catalog.products;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.dao.DuplicateKeyException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import static reactor.core.publisher.Mono.error;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.validation.Valid;
import com.fabijanbajo.catalog.common.InvalidInputException;
import com.fabijanbajo.catalog.common.NotFoundException;

@RestController
public class ProductControllerImpl implements ProductController {

	private final ProductRepository repository;

	@Autowired
	public ProductControllerImpl(ProductRepository repository) {
		this.repository = repository;
	}

	@Override
	public Mono<Product> createProduct(@Valid Product product) {
		return repository.save(product)
			.onErrorMap(
					DuplicateKeyException.class,
					exception -> new InvalidInputException("Duplicate key, productid: " + product.getProductid()));
	}

	@Override
	public Flux<Product> getProducts(Optional<Integer> categoryid, Optional<String> productids) {
		if (productids.isPresent()) {
			String ids = productids.get();

			// if one of given id fails, throw
			List<UUID> uuids = Arrays.asList(ids.split(","))
				.stream()
				.map(s -> {
					try {
						return UUID.fromString(s);
					} catch (IllegalArgumentException exception) {
						throw new InvalidInputException(exception.getMessage());
					}
				})
				.collect(Collectors.toList());
			return repository.findAllById(uuids)
				.switchIfEmpty(
						error(new NotFoundException("Products not found for ids: " + productids)));
		} else if (categoryid.isPresent()) {
			return repository.findAllByCategory(categoryid.get());
		} else {
			return repository.findAll();
		}
	}

	@Override
	public Mono<Product> getProduct(UUID productid) {
		if (productid == null) {
			throw new InvalidInputException("Invalid productid: " + productid);
		}

		return repository.findById(productid)
			.switchIfEmpty(
					error(new NotFoundException("Product not found for productid: " + productid)));
	}

	@Override
	public Mono<Void> deleteProduct(UUID productid) {
		if (productid == null) {
			throw new InvalidInputException("Invalid productid: " + productid);
		}

		return repository.deleteById(productid);
	}
}
