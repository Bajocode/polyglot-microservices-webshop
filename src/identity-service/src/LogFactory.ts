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

  public static toMilliString(start: [number, number]): string {
    const diff = process.hrtime(start);
    const milli = diff[0] * 1e3 + diff[1] * 1e-6;

    return `${milli.toFixed(3)}μs`;
  }
}
