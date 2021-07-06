package util

import "time"

// Config is a configuration object that gets validated
type Config struct {
	AppEnv       string        `env:"APP_ENV" envDefault:"dev"`
	ServerHost   string        `env:"SERVER_HOST" envDefault:"0.0.0.0"`
	ServerPort   string        `env:"SERVER_PORT" envDefault:"9002"`
	LoggerLevel  string        `env:"LOGGER_LEVEL" envDefault:"debug"`
	ReadTimeout  time.Duration `env:"SERVER_READ_TIMEOUT" envDefault:"5s"`
	WriteTimeout time.Duration `env:"SERVER_WRTIE_TIMEOUT" envDefault:"10s"`
	IdleTimeout  time.Duration `env:"SERVER_IDLE_TIMEOUT" envDefault:"15s"`
	StripeKey    string        `env:"STRIPE_KEY" envDefault:"sk_test_51HZiCgDxAoVsftB1d2Dhrfn2a2Fn7PMMCnYnvyRmdcU03iHfcg0JISsKnlSiAraSeGdAJC0B0hFGVVOfFHqhevHk00HcZfP3yl"`
}
