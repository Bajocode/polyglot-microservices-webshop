package main

import (
	"context"
	"encoding/json"
	"time"
)

type Repository struct {
	store Store
	ttl   time.Duration
}

func NewRepository(store Store, ttl time.Duration) *Repository {
	return &Repository{store, ttl}
}

func (r *Repository) GetCart(ctx context.Context, userID string) (*Cart, error) {
	var (
		cart *Cart
		enc  []byte
		err  error
	)
	if enc, err = r.store.Get(ctx, userID); err != nil {
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

	if err = r.store.Set(ctx, cart.UserID, enc); err != nil {
		return nil, err
	}
	return r.GetCart(ctx, cart.UserID)
}

func (r *Repository) DeleteCart(ctx context.Context, userID string) error {
	return r.store.Del(ctx, userID)
}
