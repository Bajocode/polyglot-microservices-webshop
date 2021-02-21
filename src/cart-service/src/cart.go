package main

type Cart struct {
	Items []CartItem `json:"items"`
}

type CartItem struct {
	ProductID string `json:"productid"`
	Quantity  int    `json:"quantity"`
	Price     int    `json:"price"`
}
