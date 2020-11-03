import Postgres from '../Postgres';
import CrudRepository from '../crud/CrudRepository';
import Order from './Order';
import OrderItemRepository from './OrderItemRepository';

export default class OrderRepository extends CrudRepository<Order> {
  private itemRepo: OrderItemRepository;

  public constructor(store: Postgres) {
    super(store, 'orders', 'orderid');
    this.itemRepo = new OrderItemRepository(store);
  }

  public async readById(id: string): Promise<Order> {
    const order: Order = await super.readById(id);
    order.items = await this.itemRepo.readAllById(id);

    return order;
  }

  public async create(obj: Order): Promise<Order> {
    const {items, ...rest} = obj;
    const {rows} = await this.store.insert(rest, this.table);
    const id = rows[0].orderid;

    items.forEach(async (i) => await this.itemRepo.create({orderid: id, ...i}));

    return rows[0];
  }
}
