package main

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

func (a *App) GetCart(res http.ResponseWriter, req *http.Request) {
	cart, err := a.Repository.GetCart(req.Context(), mux.Vars(req)["id"])
	if err != nil {
		http.Error(res, err.Error(), http.StatusBadRequest)
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusCreated)
	if err = json.NewEncoder(res).Encode(cart); err != nil {
		http.Error(res, err.Error(), http.StatusInternalServerError)
	}
}

func (a *App) PutCart(res http.ResponseWriter, req *http.Request) {
	var payload Cart

	if err := json.NewDecoder(req.Body).Decode(&payload); err != nil {
		http.Error(res, err.Error(), http.StatusBadRequest)
		return
	}

	cart, err := a.Repository.UpdateCart(req.Context(), payload)
	if err != nil {
		http.Error(res, err.Error(), http.StatusInternalServerError)
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusCreated)
	if err = json.NewEncoder(res).Encode(cart); err != nil {
		http.Error(res, err.Error(), http.StatusInternalServerError)
	}
}

func (a *App) DelCart(res http.ResponseWriter, req *http.Request) {
	if err := a.Repository.DeleteCart(req.Context(), mux.Vars(req)["id"]); err != nil {
		http.Error(res, err.Error(), http.StatusBadRequest)
	}

	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusNoContent)
}
