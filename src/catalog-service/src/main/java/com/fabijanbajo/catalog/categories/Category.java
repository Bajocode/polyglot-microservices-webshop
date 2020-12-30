package com.fabijanbajo.catalog.categories;

import java.sql.Timestamp;
import javax.validation.constraints.NotBlank;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("categories")
public class Category {

	@Id
	private int categoryid;
	@NotBlank(message = "category.parentid required")
	private int parentid;
	@NotBlank(message = "category.name required")
	private String name;
	private boolean isfinal;
	
	public Category() {}
	public Category(
			int categoryid,
			int parentid,
			String name,
			boolean isfinal,
			Timestamp created) {
		this.categoryid = categoryid;
		this.parentid = parentid;
		this.name = name;
		this.isfinal= isfinal;
	}

	public int getCategoryid() {
		return categoryid;
	}
	public void setCategoryid(int categoryid) {
		this.categoryid = categoryid;
	}
	public int getParentid() {
		return parentid;
	}
	public void setParentid(int parentid) {
		this.parentid = parentid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean getIsfinal() {
		return isfinal;
	}
	public void setIsfinal(boolean isfinal) {
		this.isfinal = isfinal;
	}
}
