package com.fabijanbajo.catalog.categories;

import org.springframework.data.repository.reactive.ReactiveCrudRepository;

import reactor.core.publisher.Flux;

public interface CategoryRepository extends ReactiveCrudRepository<Category, Integer> {
	Flux<Category> findByParentid(int parentid);
}
