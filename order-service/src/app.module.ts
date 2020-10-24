import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {TerminusModule} from '@nestjs/terminus';
import ConfigModule from './config/config.module';
import ConfigService from './config/config.service';
import OrderModule from './orders/order.module';
import HealthController from './health/health.controller';

@Module({
  controllers: [
    HealthController,
  ],
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (config: ConfigService) => ({
        type: 'postgres',
        host: config.postgresHost,
        port: config.postgresPort,
        username: config.postgresUser,
        password: config.postgresPw,
        database: config.postgresDb,
        synchronize: true,
        autoLoadEntities: true,
        uuidExtension: 'uuid-ossp',
      }),
    }),
    TerminusModule,
    OrderModule,
  ],
})
export default class AppModule {}
