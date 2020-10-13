import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import ConfigModule from './config/ConfigModule';
import Config from './config/Config';
import CatalogModule from './catalog/CatalogModule';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (config: Config) => ({
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
      inject: [Config],
    }),
    CatalogModule,
  ],
})
export class AppModule {}
