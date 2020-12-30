package com.fabijanbajo.catalog.products;

import java.util.UUID;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface ProductRepository extends ReactiveCrudRepository<Product, UUID> {
	@Query("SELECT products.* FROM products INNER JOIN product_categories ON product_categories.productid = products.productid WHERE product_categories.categoryid = :categoryId")
	Flux<Product> findAllByCategory(Integer categoryid);
}
