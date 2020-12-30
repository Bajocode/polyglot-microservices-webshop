import {Router} from 'express';
import Routing from '../Routing';
import validationMiddleware from '../middleware/validationMiddleware';
import AuthHandler from './AuthHandler';
import {CreateUserDto} from '../users/Dto';

export default class AuthRoute implements Routing {
  public path = '/auth';
  public router = Router();
  private handler: AuthHandler;

  public constructor(handler: AuthHandler) {
    this.handler = handler;
    this.mountRoutes();
  }

  private mountRoutes() {
    this.register();
    this.login();
  }

  private register(): Router {
    return this.router.post(
        `${this.path}/register`,
        validationMiddleware(CreateUserDto),
        this.handler.register);
  }

  private login(): Router {
    return this.router.post(
        `${this.path}/login`,
        validationMiddleware(CreateUserDto),
        this.handler.login);
  }
}
