package main

import (
	"net/http"
	"time"

	"github.com/sirupsen/logrus"
)

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
