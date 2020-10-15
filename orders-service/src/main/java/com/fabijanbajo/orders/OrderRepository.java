package com.fabijanbajo.orders;

import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;

public interface OrderRepository extends ReactiveCrudRepository<OrderEntity, String> {
	@Transactional(readOnly = true)
	Flux<OrderEntity> findByUserId(String userId);
}
