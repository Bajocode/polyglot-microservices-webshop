import {Router} from 'express';
import Routing from '../Routing';
import validationMiddleware from '../middleware/validationMiddleware';
import OrderHandler from './OrderHandler';
import {CreateOrderDto, UpdateOrderDto} from './Dto';

export default class OrderRoute implements Routing {
  public path = '/orders';
  public router = Router();
  private handler: OrderHandler;

  public constructor(handler: OrderHandler) {
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
        validationMiddleware(CreateOrderDto),
        this.handler.post);
  }

  private put(): Router {
    return this.router.put(
        `${this.path}/:id`,
        validationMiddleware(UpdateOrderDto),
        this.handler.put);
  }

  private delete(): Router {
    return this.router.delete(
        `${this.path}/:id`,
        this.handler.delete);
  }
}
