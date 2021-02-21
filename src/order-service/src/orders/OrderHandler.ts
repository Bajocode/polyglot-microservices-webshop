import axios from 'axios';
import {NextFunction, Request, Response} from 'express';
import Config from '../Config';
import CrudHandler from '../crud/CrudHandler';
import Order from './Order';
import OrderRepository from './OrderRepository';
import Payment from './payment';

export default class OrderHandler extends CrudHandler<Order> {
  private config: Config;
  public orderRepo: OrderRepository;

  public constructor(
      repo: OrderRepository,
      config: Config) {
    super(repo);
    this.config = config;
    this.orderRepo = repo;
  }

  public getAllForUser = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const userid: string = req.params.userid;
    try {
      const orders = await this.orderRepo.readAllForUser(userid);
      res.status(200).json(orders);
    } catch (err) {
      next(err);
    }
  }

  public getByIdForUser = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const userid: string = req.params.userid;
    const id: string = req.params.id;
    try {
      const order = await this.orderRepo.readByIdForUser(userid, id);
      res.status(200).json(order);
    } catch (err) {
      next(err);
    }
  }

  // TODO: charge with new endpoint, including userid
  public postForUser = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const dto: Order = req.body;
    const payment: Payment = {price: dto.price};
    try {
      await axios.post(`${this.config.paymentserviceUrl}/charge`, payment);
      const obj = await this.orderRepo.create(dto);
      res.setHeader('Location', req.url);
      res.status(201).json(obj);
    } catch (err) {
      next(err);
    }
    return;
  }

  public deleteForUser = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const userid: string = req.params.userid;
    const id: string = req.params.id;
    try {
      await this.orderRepo.deleteForUser(userid, id);
      res.status(204).json();
    } catch (err) {
      next(err);
    }
    return;
  }
}
