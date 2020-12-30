package main

import (
	"log"
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
		log.Fatal(err.Error())
	}

	if cfg.LocalStore {
		s = NewLocalStore()
	} else {
		s = NewRedisAdapter(&cfg)
	}

	h := NewCartHandler(NewRepository(s, cfg.RedisCartTTL))
	l := logrus.New()

	if cfg.AppEnv == "prod" {
		l.SetFormatter(&logrus.JSONFormatter{})
	} else {
		l.SetFormatter(&logrus.TextFormatter{})
	}

	http.Handle("/cart", LogMiddleware(l, ErrorHandler(h.RouteCart, l)))
	l.Fatal(http.ListenAndServe(":"+cfg.ServerPort, nil))
}
