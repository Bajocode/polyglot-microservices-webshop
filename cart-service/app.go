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
	a.Router = mux.NewRouter()
	a.bindRoutes()
}

func (a *App) Run(port string) {
	log.Fatal(http.ListenAndServe(":"+port, a.Router))
}

func (a *App) bindRoutes() {
	a.Router.HandleFunc("/cart/{id}", a.GetCart).Methods("GET")
	a.Router.HandleFunc("/cart", a.PutCart).Methods("PUT")
	a.Router.HandleFunc("/cart/{id}", a.DelCart).Methods("DELETE")
}
