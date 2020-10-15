package com.fabijanbajo.orders;

public class OrderItem {
	private String orderId;
	private final String productId;
	private final int quantity;
	private final int price;

	public OrderItem() {
		orderId = null;
		productId = null;
		quantity = 0;
		price = 0;
	}

	public OrderItem(
			String orderId,
			String productId,
			int quantity,
			int price) {
		this.orderId = orderId;
		this.productId = productId;
		this.quantity = quantity;
		this.price = price;
	}

	public String getOrderId() {
		return orderId;
	}

	public String getProductId() {
		return productId;
	}

	public int getQuantity() {
		return quantity;
	}

	public int getPrice() {
		return price;
	}
}
