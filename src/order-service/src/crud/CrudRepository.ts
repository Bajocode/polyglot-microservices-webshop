import HttpException from '../HttpException';
import Postgres from '../Postgres';
import CrudStoring from './CrudStoring';

export default abstract class CrudRepository<T> implements CrudStoring<T> {
  protected store: Postgres;
  protected table: string;
  protected idColName: string;

  public constructor(store: Postgres, table: string, idColName: string='id') {
    this.store = store;
    this.table = table;
    this.idColName = idColName;
  }

  public async create(obj: T): Promise<T> {
    const {rows} = await this.store.insert(obj, this.table);
    return rows[0];
  }

  public async readAll(): Promise<T[]> {
    const {rows} = await this.store.query(`SELECT * from ${this.table}`);
    return rows;
  }

  public async readById(id: string): Promise<T> {
    const {rows} = await this.store.query(
        `SELECT * FROM ${this.table} WHERE ${this.idColName} = $1`,
        [id],
    );
    if (!rows[0]) {
      throw new HttpException(404, `Not found given ${this.idColName}`);
    }
    return rows[0];
  }

  public async update(id: string, obj: T): Promise<T> {
    await this.delete(id);
    return await this.create(obj);
  }

  public async delete(id: string): Promise<void> {
    await this.store.query(
        `DELETE FROM orders WHERE ${this.idColName} = $1`,
        [id],
    );
    return;
  }
}
