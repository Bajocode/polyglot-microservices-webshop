const envalid = require('envalid');

class Config {
  get serverPort() {
    return this.env.SERVER_PORT;
  }
  get serverHost() {
    return this.env.SERVER_HOST;
  }

  constructor() {
    this.env = this.validated();
  }

  validated() {
    const schema = {
      SERVER_PORT: envalid.port(),
      SERVER_HOST: envalid.str(),
    };
    return envalid.cleanEnv(process.env, schema);
  }
}

module.exports = Config
