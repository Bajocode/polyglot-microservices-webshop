import CrudHandler from '../crud/CrudHandler';
import Order from './Order';
import OrderRepository from './OrderRepository';

export default class OrderHandler extends CrudHandler<Order> {
  public constructor(repo: OrderRepository) {
    super(repo);
  }
}
