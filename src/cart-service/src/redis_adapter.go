package main

import (
	"context"
	"time"

	"github.com/go-redis/redis/v8"
)

func NewRedisAdapter(config *Config) Store {
	client := redis.NewClient(&redis.Options{
		Addr:     config.RedisHost + ":" + config.RedisPort,
		Password: config.RedisPW,
		DB:       config.RedisDB,
	})
	return &redisAdapter{client: client, ttl: config.RedisCartTTL}
}

type redisAdapter struct {
	client *redis.Client
	ttl    time.Duration
}

func (r *redisAdapter) Get(ctx context.Context, key string) ([]byte, error) {
	return r.client.Get(ctx, key).Bytes()
}

func (r *redisAdapter) Set(ctx context.Context, key string, val []byte) error {
	return r.client.Set(ctx, key, val, r.ttl).Err()
}

func (r *redisAdapter) Del(ctx context.Context, key string) error {
	return r.client.Del(ctx, key).Err()
}
