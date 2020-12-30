import {NextFunction, Request, Response} from 'express';
import {CreateUserDto} from '../users/Dto';
import AuthRepository from './AuthRepository';
import Token from './Token';

export default class AuthHandler {
  private readonly repo: AuthRepository;

  public constructor(repo: AuthRepository) {
    this.repo = repo;
  }

  public register = async (
      req: Request,
      res: Response,
      next: NextFunction) => {
    const dto: CreateUserDto = req.body;
    try {
      const token: Token = await this.repo.register(dto);
      res.status(201).json(token);
    } catch (err) {
      next(err);
    }
  }

  public login = async (
      req: Request,
      res: Response,
      next: NextFunction) => {
    const dto: CreateUserDto = req.body;
    try {
      const token: Token = await this.repo.login(dto);
      res.status(201).json(token);
    } catch (err) {
      next(err);
    }
  }
}
