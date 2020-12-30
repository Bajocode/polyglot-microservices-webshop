package com.fabijanbajo.catalog.products;

import java.util.UUID;
import javax.validation.constraints.NotBlank;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("products")
public class Product {
	
	@Id
	private UUID productid;
	@NotBlank(message = "product.name required")
	private String name;
	private int price;

	public Product() {}
	public Product(
			UUID productid,
			String name,
			int price) {
		this.productid = productid;
		this.name = name;
		this.price = price;
	}

	public UUID getProductid() {
		return productid;
	}
	public void setProductid(UUID productid) {
		this.productid = productid;
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
