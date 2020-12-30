import Routing from '../Routing';
import Postgres from '../Postgres';
import HealthRoute from './HealthRoute';

const init = (store: Postgres): Routing => {
  return new HealthRoute(store);
};

export default init;
