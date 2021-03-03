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

	h := NewHandler(NewRepository(s, cfg.RedisCartTTL))
	l := logrus.New()

	if cfg.AppEnv == "prod" {
		l.SetFormatter(&logrus.JSONFormatter{})
	} else {
		l.SetFormatter(&logrus.TextFormatter{})
	}

	if level, err := logrus.ParseLevel(cfg.LoggerLevel); err == nil {
		l.SetLevel(level)
	}

	http.Handle("/", LogMiddleware(l, ErrorHandler(h.Route, l)))
	l.Fatal(http.ListenAndServe(":"+cfg.ServerPort, nil))
}
