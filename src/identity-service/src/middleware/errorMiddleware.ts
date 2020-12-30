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
    const resCode = code >= 100 && code < 600 ? code : 500;
    const resBody = {status: resCode, message};

    logger.error(message, code);
    res.status(resCode).json(resBody);
  };
};
