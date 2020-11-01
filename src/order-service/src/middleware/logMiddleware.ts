import {NextFunction, Request, Response} from 'express';
import {Logger} from 'winston';

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
  const dur = toMilliString(start);
  const msg = `${method} ${url} ${status} - ${dur}`;

  return msg;
}

function toMilliString(start: [number, number]): string {
  const diff = process.hrtime(start);
  const milli = diff[0] * 1e3 + diff[1] * 1e-6;

  return `${milli.toFixed(3)}μs`;
}
