import axios from 'axios';
import {NextFunction, Request, Response} from 'express';
import Config from '../Config';
import CrudHandler from '../crud/CrudHandler';
import Order from './Order';
import OrderRepository from './OrderRepository';
import Payment from './payment';

export default class OrderHandler extends CrudHandler<Order> {
  private config: Config;

  public constructor(
      repo: OrderRepository,
      config: Config) {
    super(repo);
    this.config = config;
  }

  public post = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const dto: Order = req.body;
    const payment: Payment = {price: dto.price};
    try {
      await axios.post(`${this.config.paymentserviceUrl}/charge`, payment);
      const obj = await this.repo.create(dto);
      res.setHeader('Location', req.url);
      res.status(201).json(obj);
    } catch (err) {
      next(err);
    }
    return;
  }
}
