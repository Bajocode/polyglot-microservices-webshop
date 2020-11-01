interface Order {
  orderId: string;
  userId: string;
  orderItems: OrderItem[];
  total: number;
}

export interface OrderItem {
  orderId: string;
  productId: string;
  quantity: number;
  price: number;
}

export default Order;
