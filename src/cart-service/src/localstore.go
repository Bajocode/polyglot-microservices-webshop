package main

import (
	"context"
	"errors"
	"sync"
)

type localStore struct {
	m  map[string][]byte
	mx sync.RWMutex
}

func NewLocalStore() Store {
	return &localStore{m: make(map[string][]byte)}
}

func (t *localStore) Get(ctx context.Context, key string) ([]byte, error) {
	t.mx.RLock()
	defer t.mx.RUnlock()
	v, ok := t.m[key]
	if !ok {
		return nil, errors.New("not found")
	}
	return v, nil
}

func (t *localStore) Set(ctx context.Context, key string, val []byte) error {
	t.mx.Lock()
	defer t.mx.Unlock()
	t.m[key] = val
	return nil
}

func (t *localStore) Del(ctx context.Context, key string) error {
	t.mx.Lock()
	defer t.mx.Unlock()
	delete(t.m, key)
	return nil
}
