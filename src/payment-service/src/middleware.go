package main

import (
	"context"
	"net/http"
	"time"

	"github.com/sirupsen/logrus"
)

const requestIDKey key = 0

type key int

type responseWriter struct {
	http.ResponseWriter
	status int
}

func newResponseWriter(res http.ResponseWriter) *responseWriter {
	return &responseWriter{ResponseWriter: res, status: http.StatusOK}
}

func (rw *responseWriter) WriteHeader(status int) {
	rw.status = status
	rw.ResponseWriter.WriteHeader(status)
}

// LogMiddleware logs all request durations
func LogMiddleware(logger *logrus.Logger, next http.Handler) http.Handler {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		start := time.Now()
		wrappedRes := newResponseWriter(res)
		next.ServeHTTP(wrappedRes, req)
		logger.Infof(
			"%s %s %d - %s",
			req.Method,
			req.RequestURI,
			wrappedRes.status,
			time.Since(start))
	})
}

// TraceMiddleware adds a correlation id header for tracing
func TraceMiddleware(nextRequestID func() string, next http.Handler) http.Handler {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		requestID := req.Header.Get("X-Request-Id")
		if requestID == "" {
			requestID = nextRequestID()
		}
		ctx := context.WithValue(req.Context(), requestIDKey, requestID)
		res.Header().Set("X-Request-Id", requestID)

		next.ServeHTTP(res, req.WithContext(ctx))
	})
}
