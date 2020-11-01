package main

import (
	"context"
)

type Store interface {
	Get(ctx context.Context, key string) ([]byte, error)
	Set(ctx context.Context, key string, val []byte) error
	Del(ctx context.Context, key string) error
}
