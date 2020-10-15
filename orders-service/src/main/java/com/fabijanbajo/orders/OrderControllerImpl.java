package com.fabijanbajo.orders;

import java.util.List;
import java.util.stream.Collectors;
import com.fabijanbajo.common.InvalidInputException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
public class OrderControllerImpl implements OrderController {
	private static final Logger LOG = LoggerFactory.getLogger(OrderControllerImpl.class);
	private final OrderRepository orderRepo;
	private final OrderMapper mapper;

	@Autowired
	public OrderControllerImpl(
			OrderRepository orderRepo,
			OrderItemRepository itemRepo,
			OrderMapper mapper) {
		this.orderRepo = orderRepo;
		this.mapper = mapper;
	}

	@Override
	public Mono<Order> getOrder(String orderId) {
		return null;
	}

	@Override
	public Flux<Order> getOrders() {
		return null;
	}

	@Override
	public void deleteOrder(String orderId) {}

	@Override
	public Order createOrder(Order order) {
		try {
			OrderEntity orderEntityFromReq = mapper.fromReq(order);
			OrderEntity orderEntityFromDb = orderRepo.save(orderEntityFromReq);
			LOG.debug("Insert order: {} for user: {}", orderEntityFromDb.getOrderId(), orderEntityFromDb.getUserId());
			Order orderFromDb = mapper.fromDb(orderEntityFromDb);
			return orderFromDb;
		} catch (DataIntegrityViolationException exception) {
			throw exception;
		}
	}

	// @Override
	// public Order createOrder(Order order) {
	// 	try {
	// 		OrderEntity orderEntityFromReq = mapper.fromReq(order);
	// 		OrderEntity orderEntityFromDb = orderRepo.save(orderEntityFromReq);
	// 		LOG.debug("Created order: {} for user: {}", orderEntityFromDb.getOrderId(), orderEntityFromDb.getUserId());

	// 		String id = orderEntityFromDb.getOrderId().toString();
	// 		List<OrderItemEntity> itemEntitiesFromReq = mapper.fromReq(order.getOrderItems());
	// 		List<OrderItemEntity> itemEntitiesFromDb = itemEntitiesFromReq
	// 			.stream().peek(e ->  {
	// 				e.setOrderId(id);
	// 				itemRepo.save(e);
	// 			}).collect(Collectors.toList());
	// 		Order orderFromDb = mapper.fromDb(orderEntityFromDb);
	// 		orderFromDb.setOrderItems(mapper.fromDb(itemEntitiesFromDb));
			
	// 		return orderFromDb;
	// 	} catch (DataIntegrityViolationException exception) {
	// 		throw exception;
	// 	}
	// }
}
