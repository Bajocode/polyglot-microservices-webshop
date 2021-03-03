package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/sirupsen/logrus"
)

var userID string

type Handling interface {
	Route(http.ResponseWriter, *http.Request) error
	handleGet(http.ResponseWriter, *http.Request) error
	handlePut(http.ResponseWriter, *http.Request) error
	handleDel(http.ResponseWriter, *http.Request) error
}

type Handler struct {
	repo *Repository
}

func NewHandler(r *Repository) Handling {
	return &Handler{r}
}

type handlerFunc func(http.ResponseWriter, *http.Request) error

func ErrorHandler(h handlerFunc, logger *logrus.Logger) http.Handler {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		err := h(res, req)

		if err == nil {
			return
		}

		logger.Errorf("Error: %v", err)

		clientErr, ok := err.(ClientError)
		if !ok {
			res.WriteHeader(500)
			return
		}

		body, err := clientErr.ResponseBody()
		if err != nil {
			logger.Errorf("Error: %v", err)
			res.WriteHeader(500)
			return
		}

		status, headers := clientErr.ResponseHeaders()
		for k, v := range headers {
			res.Header().Set(k, v)
		}
		res.WriteHeader(status)
		res.Write(body)
	})
}

func (h *Handler) Route(res http.ResponseWriter, req *http.Request) error {
	userID = extractUserID(req)

	if len(userID) == 0 {
		return NewHTTPError(nil, http.StatusBadRequest, "Bad request: no userID")
	}

	switch req.Method {
	case http.MethodGet:
		return h.handleGet(res, req)
	case http.MethodPut:
		return h.handlePut(res, req)
	case http.MethodDelete:
		return h.handleDel(res, req)
	}
	return NewHTTPError(nil, http.StatusNotImplemented, "Bad request: not implemented")
}

func (h *Handler) handleGet(res http.ResponseWriter, req *http.Request) error {
	cart, err := h.repo.Get(req.Context(), userID)
	if err != nil {
		return NewHTTPError(err, http.StatusBadRequest, "Bad request: cart not found")
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusOK)
	if err = json.NewEncoder(res).Encode(cart); err != nil {
		return fmt.Errorf("Server error (response encoding): %v", err)
	}

	return nil
}

func (h *Handler) handlePut(res http.ResponseWriter, req *http.Request) error {
	var payload Cart

	if err := json.NewDecoder(req.Body).Decode(&payload); err != nil {
		return NewHTTPError(err, http.StatusBadRequest, "Bad request: invalid JSON")
	}

	cart, err := h.repo.Update(req.Context(), userID, payload)
	if err != nil {
		return fmt.Errorf("Server error (update store): %v", err)
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusCreated)
	if err = json.NewEncoder(res).Encode(cart); err != nil {
		return fmt.Errorf("Server error (response encoding): %v", err)
	}

	return nil
}

func (h *Handler) handleDel(res http.ResponseWriter, req *http.Request) error {
	if err := h.repo.Delete(req.Context(), userID); err != nil {
		return fmt.Errorf("Caching error: %v", err)
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusNoContent)

	return nil
}

func extractUserID(req *http.Request) string {
	userID := strings.TrimSuffix(req.URL.Path, "/cart")

	return strings.TrimPrefix(userID, "/")
}
