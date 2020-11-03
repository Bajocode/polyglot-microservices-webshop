import {bool, CleanEnv, cleanEnv, port, str} from 'envalid';

export default class Config {
  public get nodeEnv(): string {
    return String(this.env.NODE_ENV);
  }
  public get isProd(): boolean {
    return Boolean(this.env.isProduction);
  }
  public get loggerLevel(): string {
    return String(this.env.LOGGER_LEVEL);
  }
  public get loggerEnabled(): boolean {
    return Boolean(this.env.LOGGER_ENABLED);
  }
  public get serverHost(): string {
    return String(this.env.SERVER_HOST);
  }
  public get serverPort(): number {
    return Number(this.env.SERVER_PORT);
  }
  public get postgresHost(): string {
    return String(this.env.POSTGRES_HOST);
  }
  public get postgresPort(): number {
    return Number(this.env.POSTGRES_PORT);
  }
  public get postgresDb(): string {
    return String(this.env.POSTGRES_DB);
  }
  public get postgresUser(): string {
    return String(this.env.POSTGRES_USER);
  }
  public get postgresPw(): string {
    return String(this.env.POSTGRES_PW);
  }

  private env: NodeJS.ProcessEnv & CleanEnv;

  public constructor() {
    this.env = this.validated();
  }

  private validated(): NodeJS.ProcessEnv & CleanEnv {
    const schema = {
      NODE_ENV: str({
        choices: ['development', 'test', 'production'],
        default: 'development',
      }),
      LOGGER_LEVEL: str({
        choices: [
          'emerg', 'alert', 'crit', 'error',
          'warning', 'notice', 'info', 'debug'],
        default: 'debug',
      }),
      LOGGER_ENABLED: bool({
        default: true,
      }),
      SERVER_HOST: str({
        default: '0.0.0.0',
      }),
      SERVER_PORT: port({
        default: 9002,
      }),
      POSTGRES_HOST: str({
        default: '0.0.0.0',
      }),
      POSTGRES_PORT: port({
        default: 5432,
      }),
      POSTGRES_DB: str({
        default: 'order-service',
      }),
      POSTGRES_USER: str({
        default: 'admin',
      }),
      POSTGRES_PW: str({
        default: 'admin',
      }),
    };
    return cleanEnv(process.env, schema);
  }
}
