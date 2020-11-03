import {NextFunction, Request, Response} from 'express';

interface CrudHandling {
  getAll(req: Request, res: Response, next: NextFunction): Promise<void>;
  getById(req: Request, res: Response, next: NextFunction): Promise<void>;
  post(req: Request, res: Response, next: NextFunction): Promise<void>;
  put(req: Request, res: Response, next: NextFunction): Promise<void>;
  delete(req: Request, res: Response, next: NextFunction): Promise<void>;
}

export default CrudHandling;
