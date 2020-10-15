package com.fabijanbajo.orders;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

@Mapper(componentModel = "spring")
public interface OrderMapper {
	@Mappings({
		@Mapping(target = "version", ignore = true),
		@Mapping(target = "orderId", ignore = true),
	})
	OrderEntity fromReq(Order order);

	@Mapping(
		target = "orderId",
		expression = "java(entity.getOrderId().toString())")
	Order fromDb(OrderEntity entity);

	@Mappings({
		@Mapping(target = "version", ignore = true),
		@Mapping(target = "orderId", ignore = true),
	})
	OrderItemEntity fromReq(OrderItem orderItem);

	OrderItem fromDb(OrderItemEntity itemEntity);
	
	List<OrderItemEntity> fromReq(List<OrderItem> items);
	List<OrderItem> fromDb(List<OrderItemEntity> entities);
}
