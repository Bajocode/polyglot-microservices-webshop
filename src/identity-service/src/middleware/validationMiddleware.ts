import {plainToClass} from 'class-transformer';
import {validate, ValidationError} from 'class-validator';
import {Request, Response, NextFunction, RequestHandler} from 'express';
import HttpException from '../HttpException';

export default function validationMiddleware(type: any): RequestHandler {
  return function validationMiddleware(
      req: Request,
      res: Response,
      next: NextFunction) {
    if (!isCreationMethod(req)) {
      next();
      return;
    }
    if (isEmpty(req)) {
      next(new HttpException(
          400,
          'Payload should not be empty'));
      return;
    }
    if (!req.headers['content-type']) {
      next(new HttpException(
          400,
          'No Content-Type header for non-empty payload'));
      return;
    }
    if (req.headers['content-type'] !== 'application/json') {
      next(new HttpException(
          415,
          'Content-Type header must be application/json'));
      return;
    }

    validate(plainToClass(type, req.body))
        .then((errs: ValidationError[]) => {
          if (errs.length > 0) {
            const msg = errs.map(
                (e) => Object.values(e.constraints)).join(', ');
            next(new HttpException(400, msg));
          } else {
            next();
          }
        });
  };
}

function isCreationMethod(req: Request): boolean {
  return ['POST', 'PATCH', 'PUT'].includes(req.method);
}

function isEmpty(req: Request): boolean {
  return req.headers['content-length'] === '0';
}

