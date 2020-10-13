package main

import "time"

type Config struct {
	ServerPort   string        `env:"SERVER_PORT" envDefault:"9003"`
	RedisHost    string        `env:"REDIS_HOST" envDefault:"0.0.0.0"`
	RedisPort    string        `env:"REDIS_PORT" envDefault:"6379"`
	RedisDB      int           `env:"REDIS_DB" envDefault:"0"`
	RedisUser    string        `env:"REDIS_USER,required"`
	RedisPW      string        `env:"REDIS_PW,required"`
	RedisCartTTL time.Duration `env:"REDIS_CART_TTL" envDefault:"1h"`
}
