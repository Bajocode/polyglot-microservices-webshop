package main

import (
	"context"
	"encoding/json"
	"time"

	"github.com/go-redis/redis/v8"
)

type Repository struct {
	cache *redis.Client
	ttl   time.Duration
}

func NewRepository(cache *redis.Client, ttl time.Duration) *Repository {
	return &Repository{cache, ttl}
}

func (r *Repository) GetCart(ctx context.Context, userID string) (*Cart, error) {
	var (
		cart *Cart
		enc  []byte
		err  error
	)
	if enc, err = r.cache.Get(ctx, userID).Bytes(); err != nil {
		return nil, err
	}
	err = json.Unmarshal(enc, &cart)
	return cart, err
}

func (r *Repository) UpdateCart(ctx context.Context, cart Cart) (*Cart, error) {
	var (
		enc []byte
		err error
	)
	if enc, err = json.Marshal(cart); err != nil {
		return nil, err
	}
	if err = r.cache.Set(ctx, cart.UserID, enc, r.ttl).Err(); err != nil {
		return nil, err
	}
	return r.GetCart(ctx, cart.UserID)
}

func (r *Repository) DeleteCart(ctx context.Context, userID string) error {
	return r.cache.Del(ctx, userID).Err()
}
