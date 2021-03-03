package main

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/sirupsen/logrus"
)

type want struct {
	status int
	body   string
}
type prep struct {
	userID string
	cart   *Cart
}
type testCase struct {
	name   string
	path   string
	method string
	body   string
	prep   *prep
	want   *want
}

func TestHandler(t *testing.T) {
	testCases := []testCase{
		{
			name:   "GET known userID",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodGet,
			body:   "",
			prep:   &prep{"9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6", newCartMock()},
			want:   &want{http.StatusOK, `{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}`},
		},
		{
			name:   "GET unknown userID",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodGet,
			body:   "",
			prep:   &prep{},
			want:   &want{http.StatusOK, `{"items":[]}`},
		},
		{
			name:   "GET no userID",
			path:   "/cart",
			method: http.MethodGet,
			body:   "",
			prep:   &prep{},
			want:   &want{http.StatusBadRequest, `{"message":"Bad request: no userID"}`},
		},
		{
			name:   "PUT filled cart",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodPut,
			body:   `{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}`,
			prep:   &prep{},
			want:   &want{http.StatusCreated, `{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}`},
		},
		{
			name:   "PUT empty cart",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodPut,
			body:   `{"items":[]}`,
			prep:   &prep{},
			want:   &want{http.StatusCreated, `{"items":[]}`},
		},
		{
			name:   "PUT empty body",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodPut,
			body:   "",
			prep:   &prep{},
			want:   &want{http.StatusBadRequest, `{"message":"Bad request: invalid JSON"}`},
		},
		{
			name:   "DELETE known userID",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodDelete,
			body:   "",
			prep:   &prep{"9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6", newCartMock()},
			want:   &want{http.StatusNoContent, ""},
		},
		{
			name:   "DELETE unknown userID",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodDelete,
			body:   "",
			prep:   &prep{},
			want:   &want{http.StatusNoContent, ""},
		},
		{
			name:   "POST not implemented",
			path:   "/9e2f2a9f-972f-4fd8-8ba6-1ed36966f5b6/cart",
			method: http.MethodPost,
			body:   "",
			prep:   &prep{},
			want:   &want{http.StatusNotImplemented, `{"message":"Bad request: not implemented"}`},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			req := httptest.NewRequest(tc.method, tc.path, strings.NewReader(tc.body))
			recorder := httptest.NewRecorder()
			s := NewLocalStore()
			enc, _ := json.Marshal(tc.prep.cart)
			s.Set(context.TODO(), tc.prep.userID, enc)
			l := logrus.New()
			l.SetOutput(ioutil.Discard)

			sut := NewHandler(NewRepository(s, 1))
			ErrorHandler(sut.Route, l).ServeHTTP(recorder, req)

			if recorder.Code != tc.want.status {
				t.Errorf("want '%d', got '%d'", tc.want.status, recorder.Code)
			}
			if strings.TrimSpace(recorder.Body.String()) != tc.want.body {
				t.Errorf("want '%s', got '%s'", tc.want.body, recorder.Body)
			}
		})
	}
}

func newCartMock() *Cart {
	return &Cart{[]CartItem{
		{
			ProductID: "94e8d5de-2192-4419-b824-ccbe7b21fa6f",
			Price:     200,
			Quantity:  2,
		},
	}}
}
