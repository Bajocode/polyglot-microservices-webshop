package main

import (
	"fmt"
	"net/http"

	"github.com/caarlos0/env/v6"
	"github.com/sirupsen/logrus"
)

func main() {
	var (
		cfg Config
		s   Store
	)

	if err := env.Parse(&cfg); err != nil {
		fmt.Println(err.Error())
	}

	if cfg.LocalStore {
		s = NewLocalStore()
	} else {
		s = NewRedisAdapter(&cfg)
	}

	mux := http.NewServeMux()
	r := NewRepository(s, cfg.RedisCartTTL)
	h := NewCartHandler(r)
	l := logrus.New()

	if cfg.AppEnv == "prod" {
		l.SetFormatter(&logrus.JSONFormatter{})
	} else {
		l.SetFormatter(&logrus.TextFormatter{})
	}

	mux.Handle("/cart", LogMiddleware(l, ErrorHandler(h.RouteCart, l)))

	l.Fatal(http.ListenAndServe(":"+cfg.ServerPort, mux))
}
