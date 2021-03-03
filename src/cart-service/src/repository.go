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

func (r *Repository) Get(ctx context.Context, userID string) (*Cart, error) {
	var (
		cart *Cart
		enc  []byte
		err  error
	)
	if enc, err = r.store.Get(ctx, userID); err != nil {
		return r.Update(ctx, userID, Cart{[]CartItem{}})
	}
	err = json.Unmarshal(enc, &cart)
	return cart, err
}

func (r *Repository) Update(ctx context.Context, userID string, cart Cart) (*Cart, error) {
	var (
		enc []byte
		err error
	)
	if enc, err = json.Marshal(cart); err != nil {
		return nil, err
	}

	if err = r.store.Set(ctx, userID, enc); err != nil {
		return nil, err
	}
	return r.Get(ctx, userID)
}

func (r *Repository) Delete(ctx context.Context, userID string) error {
	return r.store.Del(ctx, userID)
}
