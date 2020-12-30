import Postgres from '../Postgres';
import CrudRepository from '../crud/CrudRepository';
import User from './User';
import HttpException from '../HttpException';

export default class UserRepository extends CrudRepository<User> {
  public constructor(store: Postgres) {
    super(store, 'users', 'userid');
  }

  public async readByEmail(email: string): Promise<User> {
    const {rows} = await this.store.query(
        `SELECT * FROM users WHERE email = $1`,
        [email],
    );
    if (!rows[0]) {
      throw new HttpException(404, `User not found with email: ${email}`);
    }
    return rows[0];
  }

  public async create(obj: User): Promise<User> {
    const {rows} = await this.store.query(
        `SELECT * FROM users WHERE email = $1`,
        [obj.email],
    );
    if (rows[0]) {
      throw new HttpException(409, `Email ${obj.email} exists`);
    }

    return super.create(obj);
  }
}
