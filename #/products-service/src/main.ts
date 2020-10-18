import {NestFactory} from '@nestjs/core';
import {AppModule} from './app.module';
import {Logger, ValidationPipe} from '@nestjs/common';
import Config from './config/Config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const config: Config = app.get('Config');
  app.useGlobalPipes(new ValidationPipe());
  await app.listenAsync(config.serverPort, config.serverHost);
  Logger.debug(`nodejs pid${process.pid} listening @:${config.serverPort}`);

  // TODO:
  // - Intall postgres UUID extension through Kubernetes init container
  // - Add db init script https://github.com/GauSim/nestjs-typeorm
}

bootstrap();
