import App from './App';
import Config from './Config';
import LogFactory from './LogFactory';
import health from './health';
import users from './users';
import auth from './auth';
import Postgres from './Postgres';
import UserRepository from './users/UserRepository';

const cfg = new Config();
const logger = LogFactory.create(cfg);
const store = new Postgres(cfg, logger);
const userRepo = new UserRepository(store);
const app = new App(cfg, logger, [
  health(store),
  users(store, userRepo),
  auth(store, cfg, userRepo),
]);

app.listen();

