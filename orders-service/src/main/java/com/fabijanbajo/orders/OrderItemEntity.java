// TODO: https://www.callicoder.com/hibernate-spring-boot-jpa-one-to-many-mapping-example/

package com.fabijanbajo.orders;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "order_items")
@IdClass(OrderItemId.class)
public class OrderItemEntity {
	@Version
	private int version;

	@Id
	@Column(
		name = "order_id",
		insertable = false,
		updatable = false)
	private String orderId;

	@Id
	@Column(name = "product_Id")
	private String productId;

	@Column(
		name = "quantity",
		nullable = false)
	private int quantity;

	@Column(
		name = "price",
		nullable = false)
	private int price;
	
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "order_id", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@JsonIgnore
	private OrderEntity order;

	public OrderItemEntity() {}
	public OrderItemEntity(String orderId, String productId, int quantity, int price) {
		this.orderId = orderId;
		this.productId = productId;
		this.quantity = quantity;
		this.price = price;
	}

	public int getVersion() {
		return version;
	}
	public void setVersion(int version) {
		this.version = version;
	}
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
}
