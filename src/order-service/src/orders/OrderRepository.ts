import Postgres from '../Postgres';
import HttpException from '../HttpException';
import CrudRepository from '../crud/CrudRepository';
import Order from './Order';
import OrderItemRepository from './OrderItemRepository';

export default class OrderRepository extends CrudRepository<Order> {
  private itemRepo: OrderItemRepository;

  public constructor(store: Postgres) {
    super(store, 'orders', 'orderid');
    this.itemRepo = new OrderItemRepository(store);
  }

  // Skip userid (sent through JWT claims)
  public async readAllForUser(userid: string): Promise<Order[]> {
    const {rows} = await this.store.query(
        `SELECT orderid, price, created\
      FROM orders WHERE userid = $1`, [userid]);
    return rows;
  }

  public async readByIdForUser(userid: string, id: string): Promise<Order> {
    const {rows} = await this.store.query(
        `SELECT orderid, price, created\
      FROM orders WHERE userid = $1 AND orderid = $2`,
        [userid, id],
    );

    if (!rows[0]) {
      throw new HttpException(404, `Order not found with id ${id}`);
    }

    const order: Order = rows[0];
    order.items = await this.itemRepo.readAllById(id);

    return order;
  }

  public async create(obj: Order): Promise<Order> {
    obj.created = Date.now();
    const {items, ...rest} = obj;
    const {rows} = await this.store.insert(rest, this.table);
    const id = rows[0].orderid;

    items.forEach(async (i) => await this.itemRepo.create({orderid: id, ...i}));

    delete rows[0].userid;
    return rows[0];
  }

  public async update(id: string, obj: Order): Promise<Order> {
    const updated = await super.update(id, obj);

    delete updated.userid;
    return updated;
  }

  public async deleteForUser(userid: string, id: string): Promise<void> {
    await this.store.query(
        `DELETE FROM orders WHERE userid = $1 AND orderid = $2`,
        [userid, id],
    );
    return;
  }

  public async readById(id: string): Promise<Order> {
    const order: Order = await super.readById(id);
    order.items = await this.itemRepo.readAllById(id);

    return order;
  }
}
