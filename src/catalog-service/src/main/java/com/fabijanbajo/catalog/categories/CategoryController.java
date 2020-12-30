package com.fabijanbajo.catalog.categories;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import reactor.core.publisher.Flux;

public interface CategoryController {

	@GetMapping(
		value = "/catalog/categories",
		produces = "application/json"
	)
	Flux<Category> getCategories(@RequestParam(name = "parent", required = false) Integer parentid);
}
