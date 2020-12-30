import ConfigService from './config.service';
import {Module, Global} from '@nestjs/common';

@Global()
@Module({
  providers: [
    {
      provide: ConfigService,
      useValue: new ConfigService(),
    },
  ],
  exports: [ConfigService],
})
export default class ConfigModule {}
