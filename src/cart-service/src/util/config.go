package util

import "time"

// Config is a configuration object that gets validated
type Config struct {
	AppEnv       string        `env:"APP_ENV" envDefault:"dev"`
	ServerHost   string        `env:"SERVER_HOST" envDefault:"0.0.0.0"`
	ServerPort   string        `env:"SERVER_PORT" envDefault:"9002"`
	LocalStore   bool          `env:"LOCAL_STORE_ENABLED" envDefault:"false"`
	LoggerLevel  string        `env:"LOGGER_LEVEL" envDefault:"debug"`
	ReadTimeout  time.Duration `env:"SERVER_READ_TIMEOUT" envDefault:"5s"`
	WriteTimeout time.Duration `env:"SERVER_WRTIE_TIMEOUT" envDefault:"10s"`
	IdleTimeout  time.Duration `env:"SERVER_IDLE_TIMEOUT" envDefault:"15s"`
	RedisHost    string        `env:"REDIS_HOST" envDefault:"0.0.0.0"`
	RedisPort    string        `env:"REDIS_PORT" envDefault:"6379"`
	RedisDB      int           `env:"REDIS_DB" envDefault:"0"`
	RedisPW      string        `env:"REDIS_PW"`
	RedisCartTTL time.Duration `env:"REDIS_CART_TTL" envDefault:"1h"`
}
