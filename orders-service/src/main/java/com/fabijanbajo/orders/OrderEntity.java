// TODO: https://www.callicoder.com/hibernate-spring-boot-jpa-one-to-many-mapping-example/

package com.fabijanbajo.orders;

import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import javax.persistence.*;

@Entity
@Table(name = "orders")
public class OrderEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private UUID orderId;

	@Version
	private int version;
	
	@Column(nullable = false)
	private String userId;

	@Column(nullable = false)
	private int total;

	// @OneToMany(
	// 	cascade = CascadeType.ALL,
	// 	fetch =  = FetchType.All,
	// 	mappedBy = "order"
	// )
	// private List<OrderItemEntity> items = new List<OrderItemEntity>() {
	// };
	
	public OrderEntity(UUID orderId, String userId, int total) {
		this.orderId = orderId;
		this.userId = userId;
		this.total = total;
	}

	public int getVersion() {
		return version;
	}
	public void setVersion(int version) {
		this.version = version;
	}
	public UUID getOrderId() {
		return orderId;
	}
	public void setOrderId(UUID orderId) {
		this.orderId = orderId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
}
