package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type App struct {
	Repository *Repository
	Router     *mux.Router
}

func (a *App) Init(config *Config) {
	a.Repository = NewRepository(NewRedis(config), config.RedisCartTTL)
	r := mux.NewRouter()
	r.HandleFunc("/cart/{id}", a.GetCart).Methods("GET")
	r.HandleFunc("/cart", a.PutCart).Methods("PUT")
	r.HandleFunc("/cart/{id}", a.DelCart).Methods("DELETE")
	a.Router = r
}

func (a *App) Run(port string) {
	log.Fatal(http.ListenAndServe(":"+port, a.Router))
}
