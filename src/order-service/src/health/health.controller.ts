import {Controller, Get} from '@nestjs/common';
import {HealthCheckService, TypeOrmHealthIndicator, HealthCheck} from '@nestjs/terminus';

@Controller()
export default class HealthController {
  constructor(
    private health: HealthCheckService,
    private db: TypeOrmHealthIndicator,
  ) {}

  @Get('/healthz')
  @HealthCheck()
  healthy() {
    return;
  }

  @Get('/readyz')
  @HealthCheck()
  ready() {
    return this.health.check([
      async () => this.db.pingCheck('database'),
    ]);
  }
}
