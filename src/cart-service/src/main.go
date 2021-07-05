package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync/atomic"
	"time"

	"cart-service/cart"
	"cart-service/store"
	"cart-service/util"

	"github.com/caarlos0/env/v6"
	"github.com/sirupsen/logrus"
)

var healthy int32

func main() {
	var cfg util.Config
	if err := env.Parse(&cfg); err != nil {
		log.Fatal(err.Error())
	}

	logger := newLogger(cfg)
	server := newServer(cfg, logger)
	ctx := shutDownContext(context.Background(), server, logger)

	logger.Infof("go pid%d @ %s:%s", os.Getpid(), cfg.ServerHost, cfg.ServerPort)
	atomic.StoreInt32(&healthy, 1)

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		logger.Fatalf("Could not listen on %s: %v", ":"+cfg.ServerPort, err)
	}

	<-ctx.Done()
	logger.Infoln("Server stopped")
}

func shutDownContext(ctx context.Context, server *http.Server, logger *logrus.Logger) context.Context {
	ctx, done := context.WithCancel(ctx)
	quit := make(chan os.Signal, 1)

	signal.Notify(quit, os.Interrupt)
	go func() {
		defer done()
		<-quit
		signal.Stop(quit)
		close(quit)
		atomic.StoreInt32(&healthy, 0)
		logger.Debugln("Graceful shutdown...")

		ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
		defer cancel()

		server.SetKeepAlivesEnabled(false)
		if err := server.Shutdown(ctx); err != nil {
			logger.Fatalf("Could not gracefully shutdown server: %v\n", err)
		}
	}()
	return ctx
}

func newLogger(cfg util.Config) *logrus.Logger {
	l := logrus.New()

	if cfg.AppEnv == "prod" {
		l.SetFormatter(&logrus.JSONFormatter{})
	} else {
		l.SetFormatter(&logrus.TextFormatter{})
	}

	if level, err := logrus.ParseLevel(cfg.LoggerLevel); err == nil {
		l.SetLevel(level)
	}

	return l
}

func newServer(cfg util.Config, logger *logrus.Logger) *http.Server {
	router := newRouter(cfg, logger)
	server := &http.Server{
		Addr:         cfg.ServerHost + ":" + cfg.ServerPort,
		Handler:      router,
		ReadTimeout:  cfg.ReadTimeout,
		WriteTimeout: cfg.WriteTimeout,
		IdleTimeout:  cfg.IdleTimeout,
	}

	return server
}

func newRouter(cfg util.Config, logger *logrus.Logger) *http.ServeMux {
	nextRequestID := func() string {
		return fmt.Sprintf("%d", time.Now().UnixNano()/int64(time.Millisecond))
	}
	s := newStore(cfg)
	h := cart.NewHandler(cart.NewRepository(&s, cfg.RedisCartTTL))
	router := http.NewServeMux()
	router.Handle("/", TraceMiddleware(nextRequestID, LogMiddleware(logger, cart.ErrorHandler(h.Route, logger))))
	router.Handle("/healthz", healthz())

	return router
}

func newStore(cfg util.Config) store.Store {
	if cfg.LocalStore {
		return store.NewLocalStore()
	} else {
		return store.NewRedisAdapter(cfg)
	}
}

func healthz() http.Handler {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		if atomic.LoadInt32(&healthy) == 1 {
			res.WriteHeader(http.StatusNoContent)
			return
		}
		res.WriteHeader(http.StatusServiceUnavailable)
	})
}
