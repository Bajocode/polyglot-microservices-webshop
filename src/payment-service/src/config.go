package main

type Config struct {
	AppEnv      string `env:"APP_ENV" envDefault:"dev"`
	ServerPort  string `env:"SERVER_PORT" envDefault:"9004"`
	LoggerLevel string `env:"LOGGER_LEVEL" envDefault:"info"`
	StripeKey   string `env:"STRIPE_KEY" envDefault:"sk_test_51HZiCgDxAoVsftB1d2Dhrfn2a2Fn7PMMCnYnvyRmdcU03iHfcg0JISsKnlSiAraSeGdAJC0B0hFGVVOfFHqhevHk00HcZfP3yl"`
}
