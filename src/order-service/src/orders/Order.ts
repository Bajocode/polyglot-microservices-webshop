import OrderItem from './OrderItem';

interface Order {
  orderid?: string;
  userid?: string;
  items?: OrderItem[];
  price: number;
  created?: number;
}

export default Order;
