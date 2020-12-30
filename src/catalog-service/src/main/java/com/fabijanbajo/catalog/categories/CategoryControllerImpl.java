package com.fabijanbajo.catalog.categories;

import com.fabijanbajo.catalog.common.NotFoundException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import static reactor.core.publisher.Mono.error;

@RestController
public class CategoryControllerImpl implements CategoryController {
	
	private final CategoryRepository repository;

	@Autowired
	public CategoryControllerImpl(CategoryRepository repository) {
		this.repository = repository;
	}

	@Override
	public Flux<Category> getCategories(Integer parentid) {
		return parentid == null
			? repository.findAll() 
			: repository.findByParentid(parentid)
				.switchIfEmpty(
						error(new NotFoundException("Categories not found for parentid: " + parentid)));
	}
}
