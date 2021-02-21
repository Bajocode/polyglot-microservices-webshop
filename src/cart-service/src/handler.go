package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/sirupsen/logrus"
)

var userID string

type CartHandling interface {
	RouteCart(http.ResponseWriter, *http.Request) error
	handleGet(http.ResponseWriter, *http.Request) error
	handlePut(http.ResponseWriter, *http.Request) error
	handleDel(http.ResponseWriter, *http.Request) error
}

type CartHandler struct {
	repo *Repository
}

func NewCartHandler(r *Repository) CartHandling {
	return &CartHandler{r}
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

func (h *CartHandler) RouteCart(res http.ResponseWriter, req *http.Request) error {
	userID = strings.TrimSuffix(req.URL.Path, "/cart")
	userID = strings.TrimPrefix(userID, "/")
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
	return nil
}

func (h *CartHandler) handleGet(res http.ResponseWriter, req *http.Request) error {
	cart, err := h.repo.GetCart(req.Context(), userID)
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

func (h *CartHandler) handlePut(res http.ResponseWriter, req *http.Request) error {
	var payload Cart

	if err := json.NewDecoder(req.Body).Decode(&payload); err != nil {
		return NewHTTPError(err, http.StatusBadRequest, "Bad request: invalid JSON")
	}

	cart, err := h.repo.UpdateCart(req.Context(), userID, payload)
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

func (h *CartHandler) handleDel(res http.ResponseWriter, req *http.Request) error {
	if err := h.repo.DeleteCart(req.Context(), userID); err != nil {
		return NewHTTPError(err, http.StatusBadRequest, "Bad request: cart not found")
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusNoContent)

	return nil
}
