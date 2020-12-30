package main

import (
	"log"
	"net/http"

	"github.com/caarlos0/env/v6"
	"github.com/sirupsen/logrus"
	"github.com/stripe/stripe-go/v71"
)

func main() {
	var cfg Config

	if err := env.Parse(&cfg); err != nil {
		log.Fatal(err.Error())
	}

	stripe.Key = cfg.StripeKey
	h := new(PaymentHandler)
	l := logrus.New()

	if cfg.AppEnv == "prod" {
		l.SetFormatter(&logrus.JSONFormatter{})
	} else {
		l.SetFormatter(&logrus.TextFormatter{})
	}

	http.Handle("/charge", LogMiddleware(l, ErrorHandler(h.HandleCharge, l)))
	l.Fatal(http.ListenAndServe(":"+cfg.ServerPort, nil))
}
