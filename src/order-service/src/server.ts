import App from './App';
import Config from './Config';
import LogFactory from './LogFactory';
import health from './health';
import orders from './orders';
import Postgres from './Postgres';

const cfg = new Config();
const logger = LogFactory.create(cfg);
const store = new Postgres(cfg, logger);
const app = new App(cfg, logger, [
  health(store),
  orders(store),
]);

app.listen();

