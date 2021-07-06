package util

import (
	"encoding/json"
	"fmt"
)

// ClientError defines a client http error
type ClientError interface {
	Error() string
	ResponseBody() ([]byte, error)
	ResponseHeaders() (int, map[string]string)
}

// NewHTTPError constructs an http error
func NewHTTPError(err error, status int, message string) error {
	return &HTTPError{
		Cause:   err,
		Message: message,
		Status:  status,
	}
}

// HTTPError defines an http error
type HTTPError struct {
	Cause   error  `json:"-"`
	Message string `json:"message"`
	Status  int    `json:"-"`
}

func (e *HTTPError) Error() string {
	if e.Cause == nil {
		return e.Message
	}
	return e.Message + " : " + e.Cause.Error()
}

// ResponseBody encodes an http error into json
func (e *HTTPError) ResponseBody() ([]byte, error) {
	body, err := json.Marshal(e)
	if err != nil {
		return nil, fmt.Errorf("Error while parsing res body: %v", err)
	}
	return body, nil
}

// ResponseHeaders defines standardized response headers
func (e *HTTPError) ResponseHeaders() (int, map[string]string) {
	return e.Status, map[string]string{
		"content-type": "application/json; charset=utf-8",
	}
}
