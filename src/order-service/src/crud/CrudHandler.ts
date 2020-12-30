import {NextFunction, Request, Response} from 'express';
import CrudHandling from './CrudHandling';
import CrudRepository from './CrudRepository';

export default abstract class CrudHandler<T> implements CrudHandling {
  protected repo: CrudRepository<T>;

  public constructor(repo: CrudRepository<T>) {
    this.repo = repo;
  }

  public getAll = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    try {
      const objects: T[] = await this.repo.readAll();
      res.status(200).json(objects);
    } catch (err) {
      next(err);
    }
  }

  public getById = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const id: string = req.params.id;
    try {
      const obj: T = await this.repo.readById(id);
      res.status(200).json(obj);
    } catch (err) {
      next(err);
    }
  }

  public post = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const dto: T = req.body;
    try {
      const obj = await this.repo.create(dto);
      res.setHeader('Location', req.url);
      res.status(201).json(obj);
    } catch (err) {
      next(err);
    }
    return;
  }


  public put = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const id: string = req.params.id;
    const dto: T = req.body;
    try {
      const updated = await this.repo.update(id, dto);
      res.setHeader('Location', req.url);
      res.status(204).json(updated);
    } catch (err) {
      next(err);
    }
    return;
  }


  public delete = async (
      req: Request,
      res: Response,
      next: NextFunction): Promise<void> => {
    const id: string = req.params.id;
    try {
      await this.repo.delete(id);
      res.status(204).json();
    } catch (err) {
      next(err);
    }
    return;
  }
}
