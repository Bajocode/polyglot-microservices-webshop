import Routing from '../Routing';
import Postgres from '../Postgres';
import OrderHandler from './OrderHandler';
import OrderRepository from './OrderRepository';
import OrderRoute from './OrderRoute';

const init = (store: Postgres): Routing => {
  const repo = new OrderRepository(store);
  const handler = new OrderHandler(repo);
  const route = new OrderRoute(handler);

  return route;
};

export default init;
