import {Router} from 'express';
import Routing from '../Routing';
import validationMiddleware from '../middleware/validationMiddleware';
import UserHandler from './UserHandler';
import {CreateUserDto, UpdateUserDto} from './Dto';

export default class UserRoute implements Routing {
  public path = '/users';
  public router = Router();
  private handler: UserHandler;

  public constructor(handler: UserHandler) {
    this.handler = handler;
    this.mountRoutes();
  }

  private mountRoutes() {
    this.getAll();
    this.getById();
    this.post();
    this.put();
    this.delete();
  }

  private getAll(): Router {
    return this.router.get(
        `${this.path}`,
        this.handler.getAll);
  }

  private getById(): Router {
    return this.router.get(
        `${this.path}/:id`,
        this.handler.getById);
  }

  private post(): Router {
    return this.router.post(
        `${this.path}`,
        validationMiddleware(CreateUserDto),
        this.handler.post);
  }

  private put(): Router {
    return this.router.put(
        `${this.path}/:id`,
        validationMiddleware(UpdateUserDto),
        this.handler.put);
  }

  private delete(): Router {
    return this.router.delete(
        `${this.path}/:id`,
        this.handler.delete);
  }
}
