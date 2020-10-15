package com.fabijanbajo.orders;

import java.util.List;

public class Order {
	private final String orderId;
	private	final String userId;
	// private List<OrderItem> orderItems;
	private final int total;

	public Order(
			String orderId,
			String userId,
			// List<OrderItem> orderItems,
			int total) {
		this.orderId = orderId;
		this.userId = userId;
		// this.orderItems = orderItems;
		this.total = total;
	}

	public String getOrderId() {
		return orderId;
	}
	
	public String getUserId() {
		return userId;
	}

	// public List<OrderItem> getOrderItems() {
	// 	return orderItems;
	// }
	// public void setOrderItems(List<OrderItem> orderItems) {
	// 	this.orderItems = orderItems;
	// }

	public int getTotal() {
		return total;
	}
}
