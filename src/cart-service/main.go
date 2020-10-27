// TODO: assess need for gorilla mux
// TODO: create adapter for cache
// TODO: handle routes more reuse
// TODO: error handling
// TODO: logging

package main

import (
	"fmt"

	"github.com/caarlos0/env/v6"
)

func main() {
	cfg := Config{}
	if err := env.Parse(&cfg); err != nil {
		fmt.Println(err.Error())
	}

	a := App{}
	a.Init(&cfg)
	a.Run(cfg.ServerPort)
}
