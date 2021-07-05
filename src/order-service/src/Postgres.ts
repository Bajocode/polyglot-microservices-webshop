import {Pool, QueryConfig, QueryResult, types} from 'pg';
import {Logger} from 'winston';
import Config from './Config';
import LogFactory from './LogFactory';

export default class Postgres {
  private logger: Logger
  private pool: Pool;

  public constructor(cfg: Config, logger: Logger) {
    this.logger = logger;
    this.pool = new Pool({
      host: cfg.postgresHost,
      port: cfg.postgresPort,
      user: cfg.postgresUser,
      password: cfg.postgresPw,
      database: cfg.postgresDb,
    });

    // Convert bigserial + bigint (both with typeId = 20) to number
    types.setTypeParser(20, parseInt);
  }

  public async query(text, values=[]) {
    const q: QueryConfig = {
      text,
      values,
    };
    const start = process.hrtime();
    const res = await this.pool.query(q);
    this.logger.info(this.queryLog(text, start, res));

    return res;
  }

  public async insert(obj: any, table: string) {
    const vals = Object.values(obj);
    const cols = Object.keys(obj).join(',');
    const params = Array.from(new Array(vals.length), (x, i) => i+1)
        .map((v) => `$${v}`)
        .join(',');

    return this.query(
        `INSERT INTO ${table}(${cols}) VALUES (${params}) RETURNING *`,
        vals,
    );
  }

  public async ready() {
    return await this.query('SELECT version();');
  }

  private queryLog(
      qstr: string,
      start: [number, number],
      res: QueryResult): string {
    const dur = LogFactory.toMilliString(start);
    const rows = res.rowCount;

    return `postgres: ${qstr}, ${rows} rows - ${dur}`;
  }
}
