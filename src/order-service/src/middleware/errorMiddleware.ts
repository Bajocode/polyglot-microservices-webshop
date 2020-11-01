import {Request, Response, NextFunction} from 'express';
import {Logger} from 'winston';
import HttpException from '../HttpException';

export default function errorMiddleware(logger: Logger) {
  return function(
      error: HttpException,
      req: Request,
      res: Response,
      next: NextFunction) {
    const code: number = error.code || 500;
    const message: string = error.message || 'Something went wrong';

    logger.error(message, code);

    res.status(code).json({message});
  };
};
