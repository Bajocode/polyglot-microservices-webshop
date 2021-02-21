import {Router} from 'express';
import Routing from '../Routing';
import validationMiddleware from '../middleware/validationMiddleware';
import OrderHandler from './OrderHandler';
import {CreateOrderDto, UpdateOrderDto} from './Dto';

export default class OrderRoute implements Routing {
  public path = 'orders';
  public router = Router();
  private handler: OrderHandler;

  public constructor(handler: OrderHandler) {
    this.handler = handler;
    this.mountRoutes();
  }

  private mountRoutes() {
    this.getAllForUser();
    this.getByIdForUser();
    this.postForUser();
    this.putForUser();
    this.deleteForUser();
  }

  private getAllForUser(): Router {
    return this.router.get(
        `/:userid/${this.path}`,
        this.handler.getAllForUser);
  }

  private getByIdForUser(): Router {
    return this.router.get(
        `/:userid/${this.path}/:id`,
        this.handler.getByIdForUser);
  }

  private postForUser(): Router {
    return this.router.post(
        `/:userid/${this.path}`,
        validationMiddleware(CreateOrderDto),
        this.handler.postForUser);
  }

  private putForUser(): Router {
    return this.router.put(
        `/:userid/${this.path}/:id`,
        validationMiddleware(UpdateOrderDto),
        this.handler.put);
  }

  private deleteForUser(): Router {
    return this.router.delete(
        `/:userid/${this.path}/:id`,
        this.handler.deleteForUser);
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
}
