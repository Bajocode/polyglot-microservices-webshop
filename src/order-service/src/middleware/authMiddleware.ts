import {Request, NextFunction, Response} from 'express';
import {verify, SignOptions, Algorithm, JsonWebTokenError} from 'jsonwebtoken';
import HttpException from '../HttpException';
import Config from '../Config';

export default function authMiddleware(config: Config) {
  return async function(
      req: Request,
      res: Response,
      next: NextFunction) {
    if (!config.jwtValidationEnabled) return next();
    if (config.jwtPathsWhitelist.includes(req.path)) return next();

    const authHeader = req.headers.authorization;

    if (!authHeader) {
      next(new HttpException(401, 'No Authorization header'));
      return;
    }

    const [scheme, token] = authHeader.split(' ');

    if (scheme !== 'Bearer') {
      next(new HttpException(400, 'Authorization header scheme not Bearer'));
      return;
    }

    const jwtReg = /^[\w-]+\.[\w-]+\.[\w-.+\/=]*$/;

    if (!token || !jwtReg.test(token)) {
      next(new HttpException(400, `Invalid Token, ${jwtReg}`));
      return;
    }

    const options: SignOptions = {
      algorithm: config.jwtAlgo as Algorithm,
    };

    try {
      const result = verify(token, config.jwtSecret, options);
      const userid = result['userid'] as string;
      req['userid'] = userid;
      next();
    } catch (err) {
      if (err instanceof JsonWebTokenError) {
        next(new HttpException(400, `JWT Error, ${err.message}`));
      }
    }
  };
}
