import App from './App';
import Config from './Config';
import LogFactory from './LogFactory';
import health from './health';
import orders from './orders';
import Postgres from './Postgres';

const config = new Config();
const logger = LogFactory.create(config);
const store = new Postgres(config, logger);
const app = new App(config, logger, [
  health(store),
  orders(store, config),
]);

app.listen();

