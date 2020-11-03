import {NextFunction, Request, Response} from 'express';
import {Logger} from 'winston';
import LogFactory from '../LogFactory';

export default function logMiddleware(logger: Logger) {
  return function(
      req: Request,
      res: Response,
      next: NextFunction) {
    const start = process.hrtime();

    res.on('finish', () => {
      logger.info(toLog(req, res, start));
    });

    next();
  };
}

function toLog(req: Request, res: Response, start: [number, number]): string {
  const method = req.method;
  const url = req.url;
  const status = res.statusCode;
  const dur = LogFactory.toMilliString(start);
  const msg = `${method} ${url} ${status} - ${dur}`;

  return msg;
}

