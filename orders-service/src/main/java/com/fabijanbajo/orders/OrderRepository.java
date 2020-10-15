package com.fabijanbajo.orders;

import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

public interface OrderRepository extends CrudRepository<OrderEntity, String> {
	@Transactional(readOnly = true)
	OrderEntity findByUserId(String userId);
}
