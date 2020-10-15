package com.fabijanbajo.orders;

import java.util.List;
import java.util.stream.Collectors;
import com.fabijanbajo.common.InvalidInputException;
import com.fabijanbajo.common.NotFoundException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Flux;

@RestController
public class OrderControllerImpl implements OrderController {
	private static final Logger LOG = LoggerFactory.getLogger(OrderControllerImpl.class);
	private final OrderRepository orderRepo;
	private final OrderItemRepository itemRepo;
	private final OrderMapper mapper;

	@Autowired
	public OrderControllerImpl(
			OrderRepository orderRepo,
			OrderItemRepository itemRepo,
			OrderMapper mapper) {
		this.orderRepo = orderRepo;
		this.itemRepo = itemRepo;
		this.mapper = mapper;
	}

	@Override
	public Mono<Order> getOrder(String orderId) {
		if (orderId == null) throw new InvalidInputException("id is null");
		return orderRepo
			.findById(orderId)
			.switchIfEmpty(Mono.error(new NotFoundException()))
			.log()
			.map(e -> mapper.fromDb(e));
	}

	@Override
	public Flux<Order> getOrders() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteOrder(String orderId) {
		// TODO Auto-generated method stub
	}

	@Override
	public Order createOrder(Order order) {
		OrderEntity entity = mapper.fromReq(order);
		return orderRepo
			.save(entity)
			.onErrorMap(DuplicateKeyException.class, e -> new InvalidInputException("dubpli-x"))
			.map(e -> mapper.fromDb(e))
			.block();
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
