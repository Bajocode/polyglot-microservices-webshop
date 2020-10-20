package com.fabijanbajo.catalog.products;

import java.util.UUID;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("products")
public class Product {
	
	@Id
	private UUID productId;
	private String name;
	private int price;

	public Product() {}
	public Product(
			UUID productId,
			String name,
			int price) {
		this.productId = productId;
		this.name = name;
		this.price = price;
	}

	public UUID getProductId() {
		return productId;
	}
	public void setProductId(UUID productId) {
		this.productId = productId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}

}
