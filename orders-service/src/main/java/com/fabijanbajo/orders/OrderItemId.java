package com.fabijanbajo.orders;

import java.io.Serializable;

public class OrderItemId implements Serializable {
	private final String orderId;
	private final String productId;

	public OrderItemId(String orderId, String productId) {
		this.orderId = orderId;
		this.productId = productId;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) return true;
		if (!(obj instanceof OrderItemId)) return false;
		OrderItemId cast = (OrderItemId)obj;
		return orderId.equals(cast.orderId) && productId.equals(cast.productId);
	}

	@Override
	public int hashCode() {
		final int prime = 31;
        int result = 1;
        result = prime * result + ((orderId == null) ? 0 : orderId.hashCode());
        result = prime * result + ((productId == null) ? 0 : productId.hashCode());
        return result;
	}
}
