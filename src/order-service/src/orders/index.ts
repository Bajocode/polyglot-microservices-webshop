import Routing from '../Routing';
import Postgres from '../Postgres';
import OrderHandler from './OrderHandler';
import OrderRepository from './OrderRepository';
import OrderRoute from './OrderRoute';
import Config from '../Config';

const init = (
    store: Postgres,
    config: Config): Routing => {
  const repo = new OrderRepository(store);
  const handler = new OrderHandler(repo, config);
  const route = new OrderRoute(handler);

  return route;
};

export default init;
