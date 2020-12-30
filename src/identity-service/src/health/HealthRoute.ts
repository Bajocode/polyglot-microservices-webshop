import {Router} from 'express';
import Postgres from '../Postgres';
import Routing from '../Routing';

export default class HealthRoute implements Routing {
  public path = '/status';
  public router = Router();

  public constructor(store: Postgres) {
    this.router.get(`${this.path}/healthz`, (req, res) => {
      res.status(200).send();
    });
    this.router.get(`${this.path}/readyz`, (req, res) => {
      return store.ready()
          .then(() => res.status(200).send())
          .catch(() => res.status(500).send());
    });
  }
}
