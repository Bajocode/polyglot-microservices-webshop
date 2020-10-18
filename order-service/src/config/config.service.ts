import * as joi from '@hapi/joi';
import {Injectable} from '@nestjs/common';

@Injectable()
export default class ConfigService {
  public get nodeEnv(): string {
    return String(this.envVars.NODE_ENV);
  }
  public get loggerLevel(): string {
    return String(this.envVars.LOGGER_LEVEL);
  }
  public get loggerEnabled(): boolean {
    return Boolean(this.envVars.LOGGER_ENABLED);
  }
  public get serverHost(): string {
    return String(this.envVars.SERVER_HOST);
  }
  public get serverPort(): number {
    return Number(this.envVars.SERVER_PORT);
  }
  public get postgresHost(): string {
    return String(this.envVars.POSTGRES_HOST);
  }
  public get postgresPort(): number {
    return Number(this.envVars.POSTGRES_PORT);
  }
  public get postgresUser(): string {
    return String(this.envVars.POSTGRES_USER);
  }
  public get postgresPw(): string {
    return String(this.envVars.POSTGRES_PW);
  }
  public get postgresDb(): string {
    return String(this.envVars.POSTGRES_DB);
  }

  private envVars: NodeJS.ProcessEnv;

  public constructor() {
    this.envVars = this.validateConfig(process.env, this.envVarsSchema);
  }

  private readonly envVarsSchema: joi.ObjectSchema = joi.object({
    NODE_ENV: joi.string()
        .valid('development', 'production', 'test', 'provision')
        .default('development'),
    LOGGER_LEVEL: joi.string()
        .valid('error', 'warn', 'info', 'verbose', 'debug', 'silly')
        .default('info'),
    LOGGER_ENABLED: joi.boolean()
        .truthy('TRUE').truthy('true').truthy('1')
        .falsy('FALSE').falsy('false').falsy('0')
        .default(true),
    SERVER_HOST: joi.string()
        .default('0.0.0.0'),
    SERVER_PORT: joi.number()
        .default(9002),
    POSTGRES_HOST: joi.string()
        .default('0.0.0.0'),
    POSTGRES_PORT: joi.number()
        .default(5432),
    POSTGRES_USER: joi.string()
        .default('admin'),
    POSTGRES_PW: joi.string()
        .default('admin'),
    POSTGRES_DB: joi.string()
        .default('order-service'),
  }).unknown()
      .required();

  private validateConfig(
      config: NodeJS.ProcessEnv,
      schema: joi.ObjectSchema): NodeJS.ProcessEnv {
    const {error, value: validatedConfig} = schema.validate(config);

    if (error) {
      throw new Error(`Config validation error: ${error.message}`);
    }

    return validatedConfig;
  }
}
