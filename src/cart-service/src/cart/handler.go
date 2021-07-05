package cart

import (
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"cart-service/util"

	"github.com/sirupsen/logrus"
)

var userID string

// Handling defines request handling capabilities
type Handling interface {
	Route(http.ResponseWriter, *http.Request) error
	handleGet(http.ResponseWriter, *http.Request) error
	handlePut(http.ResponseWriter, *http.Request) error
	handleDel(http.ResponseWriter, *http.Request) error
}

// Handler is a request handler with repository
type Handler struct {
	repo *Repository
}

// NewHandler constructs a new request handler
func NewHandler(r *Repository) Handling {
	return &Handler{r}
}

type handlerFunc func(http.ResponseWriter, *http.Request) error

// ErrorHandler handles client and server errors
func ErrorHandler(h handlerFunc, logger *logrus.Logger) http.Handler {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		err := h(res, req)

		if err == nil {
			return
		}

		logger.Errorf("Error: %v", err)

		clientErr, ok := err.(util.ClientError)
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

// Route is a request router that ensures only routes cart requests with userID
func (h *Handler) Route(res http.ResponseWriter, req *http.Request) error {
	if !strings.HasSuffix(req.URL.Path, "cart") {
		return util.NewHTTPError(nil, http.StatusBadRequest, "Bad request: not found")
	}

	if err := extractUserID(req); err != nil {
		return err
	}

	switch req.Method {
	case http.MethodGet:
		return h.handleGet(res, req)
	case http.MethodPut:
		return h.handlePut(res, req)
	case http.MethodDelete:
		return h.handleDel(res, req)
	}

	return util.NewHTTPError(nil, http.StatusNotImplemented, "Bad request: not implemented")
}

func (h *Handler) handleGet(res http.ResponseWriter, req *http.Request) error {
	cart, err := h.repo.Get(req.Context(), userID)
	if err != nil {
		return util.NewHTTPError(err, http.StatusBadRequest, "Bad request: cart not found")
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusOK)
	if err = json.NewEncoder(res).Encode(cart); err != nil {
		return fmt.Errorf("Server error (response encoding): %v", err)
	}

	return nil
}

func (h *Handler) handlePut(res http.ResponseWriter, req *http.Request) error {
	var payload cart

	if err := json.NewDecoder(req.Body).Decode(&payload); err != nil {
		return util.NewHTTPError(err, http.StatusBadRequest, "Bad request: invalid JSON")
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

func extractUserID(req *http.Request) error {
	userID = strings.TrimPrefix(strings.TrimSuffix(req.URL.Path, "/cart"), "/")

	if validUUID(userID) {
		return nil
	}

	return util.NewHTTPError(nil, http.StatusBadRequest, "Bad request: invalid userID")
}

func validUUID(uuid string) bool {
	r := regexp.MustCompile("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[8|9|aA|bB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}$")

	return r.MatchString(uuid)
}
