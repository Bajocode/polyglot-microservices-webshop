package main

import "time"

type Config struct {
	AppEnv       string        `env:"APP_ENV" envDefault:"dev"`
	ServerPort   string        `env:"SERVER_PORT" envDefault:"9003"`
	LocalStore   bool          `env:"LOCAL_STORE_ENABLED" envDefault:"false"`
	LoggerLevel  string        `env:"LOGGER_LEVEL" envDefault:"info"`
	RedisHost    string        `env:"REDIS_HOST" envDefault:"0.0.0.0"`
	RedisPort    string        `env:"REDIS_PORT" envDefault:"6379"`
	RedisDB      int           `env:"REDIS_DB" envDefault:"0"`
	RedisPW      string        `env:"REDIS_PW,required"`
	RedisCartTTL time.Duration `env:"REDIS_CART_TTL" envDefault:"1h"`
}
