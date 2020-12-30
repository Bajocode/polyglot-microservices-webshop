import Routing from '../Routing';
import Postgres from '../Postgres';
import UserHandler from './UserHandler';
import UserRepository from './UserRepository';
import UserRoute from './UserRoute';

const init = (store: Postgres, userRepo: UserRepository): Routing => {
  const handler = new UserHandler(userRepo);
  const route = new UserRoute(handler);

  return route;
};

export default init;
