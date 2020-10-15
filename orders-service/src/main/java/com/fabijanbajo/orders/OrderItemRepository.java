package com.fabijanbajo.orders;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

public interface OrderItemRepository extends CrudRepository<OrderItemEntity, String> {
	List<OrderItemEntity> findByOrderId(String orderId);
}
