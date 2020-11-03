import Postgres from '../Postgres';
import CrudRepository from '../crud/CrudRepository';
import OrderItem from './OrderItem';

export default class OrderItemRepository extends CrudRepository<OrderItem> {
  public constructor(store: Postgres) {
    super(store, 'order_items', 'orderid');
  }

  public async readAllById(id: string): Promise<OrderItem[]> {
    const {rows} = await this.store.query(
        `SELECT * FROM ${this.table} WHERE ${this.idColName} = $1`,
        [id],
    );
    return rows;
  }
}
