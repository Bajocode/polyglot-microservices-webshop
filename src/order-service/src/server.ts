import App from './App';
import Config from './Config';
import LogFactory from './LogFactory';
import ExampleRoute from './example/ExampleRoute';

const config = new Config();
const logger = LogFactory.create(config);
const app = new App(config, logger, [
  new ExampleRoute(),
]);

app.listen();

