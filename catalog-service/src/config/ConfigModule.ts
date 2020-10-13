import Config from './Config';
import {Module, Global} from '@nestjs/common';

@Global()
@Module({
  providers: [
    {
      provide: Config,
      useValue: new Config(),
    },
  ],
  exports: [Config],
})
export default class ConfigModule {}
