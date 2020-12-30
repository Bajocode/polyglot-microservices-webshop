package main

type Cart struct {
	UserID string     `json:"userid"`
	Items  []CartItem `json:"items"`
}

type CartItem struct {
	ProductID string `json:"productid"`
	Quantity  int    `json:"quantity"`
	Price     int    `json:"price"`
}
