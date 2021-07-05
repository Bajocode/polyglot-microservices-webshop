package cart

type cart struct {
	Items []cartItem `json:"items"`
}

type cartItem struct {
	ProductID string `json:"productid"`
	Quantity  int    `json:"quantity"`
	Price     int    `json:"price"`
}
