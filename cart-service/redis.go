package main

import "github.com/go-redis/redis/v8"

func NewRedis(config *Config) *redis.Client {
	return redis.NewClient(&redis.Options{
		Addr:     config.RedisHost + ":" + config.RedisPort,
		Password: config.RedisPW,
		DB:       config.RedisDB,
	})
}
