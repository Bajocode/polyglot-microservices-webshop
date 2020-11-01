import {Router} from 'express';
import validationMiddleware from '../middleware/validationMiddleware';
import Routing from '../Routing';
import {CreateExampleDto} from './Dto';
import ExampleHandler from './ExampleHandler';

export default class ExampleRoute implements Routing {
  public path = '/examples';
  public router = Router();
  private handler = new ExampleHandler();

  public constructor() {
    this.mountRoutes();
  }

  private mountRoutes() {
    this.router.get(
        `${this.path}/:exampleId`,
        this.handler.getById);
    this.router.post(
        `${this.path}`,
        validationMiddleware(CreateExampleDto),
        this.handler.post);
  }
}
