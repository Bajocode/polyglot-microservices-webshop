package main

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/sirupsen/logrus"
)

func TestHandler(t *testing.T) {
	testCases := []struct {
		name   string
		method string
		body   string
		want   int
	}{
		{
			name:   "POST without body",
			method: http.MethodPost,
			body:   "",
			want:   http.StatusBadRequest,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			req := httptest.NewRequest(tc.method, "/", strings.NewReader(tc.body))
			recorder := httptest.NewRecorder()
			sut := new(Handler)
			l := logrus.New()
			l.SetOutput(ioutil.Discard)

			ErrorHandler(sut.HandleCharge, l).ServeHTTP(recorder, req)

			if recorder.Code != tc.want {
				t.Errorf("want '%d', got '%d'", tc.want, recorder.Code)
			}
		})
	}
}
