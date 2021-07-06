import {NextFunction, Request, Response} from 'express';

export default function traceMiddleware() {
  return function(
      req: Request,
      res: Response,
      next: NextFunction) {
    // Check if requestId passed from other service
    let requestId = req.headers['x-request-id'];
    if (!requestId) {
      requestId = Date.now().toString();
    }
    // Update global req object prop and set header
    req['requestId'] = requestId;
    res.setHeader('X-Request-Id', requestId);

    next();
  };
}
