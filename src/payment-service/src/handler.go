package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/sirupsen/logrus"
	"github.com/stripe/stripe-go/v71"
	"github.com/stripe/stripe-go/v71/charge"
)

const hardcodedUserID = "85a3a5d5-e50f-463b-a757-9acf5515644a"

type Handling interface {
	HandleCharge(http.ResponseWriter, *http.Request) error
}

type Handler struct{}

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

func (h *Handler) HandleCharge(res http.ResponseWriter, req *http.Request) error {
	var payment Payment
	if err := json.NewDecoder(req.Body).Decode(&payment); err != nil {
		return NewHTTPError(err, http.StatusBadRequest, "Bad request: invalid JSON")
	}

	token := req.FormValue("stripeToken")
	params := &stripe.ChargeParams{
		Amount:      stripe.Int64(int64(payment.Price)),
		Currency:    stripe.String(string(stripe.CurrencyUSD)),
		Description: stripe.String("Example charge from GO"),
	}

	token = "tok_us"

	params.SetSource(token)

	if _, err := charge.New(params); err != nil {
		return fmt.Errorf("Charge error: %v", err)
	}

	res.WriteHeader(http.StatusOK)

	return nil
}
