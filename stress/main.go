package main

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"
)

func main() {
	var err error
	var resp *http.Response

	for i := 0; i < 500; i++ {
		if resp, err = http.Get("http://app:8080/"); err != nil {
			panic(err)
		}
		fmt.Println("-- Response " + strconv.Itoa(resp.StatusCode))
		for k, v := range resp.Header {
			fmt.Println("  " + k + " = " + strings.Join(v, ", "))
		}
		_ := resp.Body.Close()
	}
}
