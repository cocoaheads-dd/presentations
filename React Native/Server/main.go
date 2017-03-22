package main

import (
	"fmt"
	"log"
	"net/http"

	"encoding/json"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

var client = newTwitterClient()

func main() {

	http.HandleFunc("/search", search)
	http.HandleFunc("/stream", stream)

	http.ListenAndServe(":8080", nil)
}

func search(w http.ResponseWriter, r *http.Request) {
	values := r.URL.Query()["term"]
	if len(values) != 1 {
		fmt.Fprintln(w, "no term parameter specified!")
		return
	}
	t := values[0]

	tweets, err := client.search(t, 20)
	if err != nil {
		fmt.Fprintf(w, "ERROR1: %v", err)
		return
	}
	b, err := json.Marshal(tweets)
	if err != nil {
		fmt.Fprintf(w, "ERROR2: %v", err)
		return
	}

	fmt.Fprintf(w, "%s", string(b))
}

func stream(w http.ResponseWriter, r *http.Request) {

	values := r.URL.Query()["term"]
	if len(values) != 1 {
		fmt.Fprintln(w, "no term parameter specified!")
		return
	}
	t := values[0]

	con, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatal(err)
	}

	go client.stream(t)

	stop := make(chan struct{})

	go func() {
		_, _, err := con.ReadMessage()
		if err != nil {
			stop <- struct{}{}
		}
	}()

endless:
	for {
		select {
		case message := <-client.messages:
			con.WriteJSON(message)
		case <-stop:
			break endless
		}
	}

	fmt.Println("STOPPED")
	client.stop <- struct{}{}
	con.Close()
}
