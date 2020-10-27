import {NestFactory} from '@nestjs/core';
import {Logger, ValidationPipe} from '@nestjs/common';
import AppModule from './app.module';
import ConfigService from './config/config.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const config: ConfigService = app.get('ConfigService');
  // app.useGlobalPipes(new ValidationPipe());
  await app.listenAsync(config.serverPort, config.serverHost);
  Logger.debug(`nodejs pid${process.pid} listening @:${config.serverPort}`);

  // TODO:
  // - Intall postgres UUID extension through Kubernetes init container
  // - Add db init script https://github.com/GauSim/nestjs-typeorm
}

bootstrap();
