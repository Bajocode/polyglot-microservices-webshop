import {createLogger, format, Logger, transports} from 'winston';
import Config from './Config';

export default class LogFactory {
  public static create(cfg: Config): Logger {
    const logger = createLogger();

    if (cfg.isProd) {
      logger.add(
          new transports.Console({
            format: format.json(),
            level: cfg.loggerLevel,
          }));
    } else {
      logger.add(
          new transports.Console({
            format: format.simple(),
            level: cfg.loggerLevel,
          }));
    }

    return logger;
  }
}
