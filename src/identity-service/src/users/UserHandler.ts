import CrudHandler from '../crud/CrudHandler';
import User from './User';
import UserRepository from './UserRepository';

export default class UserHandler extends CrudHandler<User> {
  public constructor(repo: UserRepository) {
    super(repo);
  }
}
