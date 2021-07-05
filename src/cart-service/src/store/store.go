package store

import (
	"context"
)

// Store defines storing capabilities
type Store interface {
	Get(ctx context.Context, key string) ([]byte, error)
	Set(ctx context.Context, key string, val []byte) error
	Del(ctx context.Context, key string) error
}
