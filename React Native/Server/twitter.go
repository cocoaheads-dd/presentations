package main

import (
	"fmt"
	"log"

	"strings"

	"github.com/dghubble/go-twitter/twitter"
	"github.com/dghubble/oauth1"
)

type tweet struct {
	ID      string `json:"key"`
	From    string `json:"from"`
	Message string `json:"message"`
	Picture string `json:"picture"`
	Media   string `json:"media,omitempty"`
}

type twitterClient struct {
	messages chan *tweet
	stop     chan struct{}
	client   *twitter.Client
}

func newTwitterClient() *twitterClient {
	config := oauth1.NewConfig("", "") // TODO: Insert authentication information
	token := oauth1.NewToken("", "")   // TODO: Insert authentication information
	httpClient := config.Client(oauth1.NoContext, token)

	client := twitter.NewClient(httpClient)

	return &twitterClient{
		messages: make(chan *tweet),
		stop:     make(chan struct{}),
		client:   client,
	}
}

func (t *twitterClient) stream(term string) {
	str, err := t.client.Streams.Filter(&twitter.StreamFilterParams{Track: []string{term}})
	if err != nil {
		log.Fatal(err)
	}
	demux := twitter.NewSwitchDemux()
	demux.Tweet = func(message *twitter.Tweet) {
		fmt.Printf("--- %s: %10s\n", message.User.Name, message.Text)
		var media string
		if len(message.Entities.Media) > 0 {
			media = message.Entities.Media[0].MediaURLHttps
		}
		image := strings.Replace(message.User.ProfileImageURLHttps, "normal", "bigger", 1)
		t.messages <- &tweet{
			ID:      message.IDStr,
			From:    message.User.Name,
			Picture: image,
			Message: message.Text,
			Media:   media,
		}
	}

	go demux.HandleChan(str.Messages)

	fmt.Printf("============ STARTED: %s\n", term)
	<-t.stop
	fmt.Printf("============ STOPPED: %s\n", term)

	str.Stop()
}

func (t *twitterClient) search(query string, count int) ([]tweet, error) {
	s, _, err := t.client.Search.Tweets(&twitter.SearchTweetParams{Count: count, Query: query})
	mapped := make([]tweet, len(s.Statuses))
	for i, message := range s.Statuses {
		var media string
		if len(message.Entities.Media) > 0 {
			media = message.Entities.Media[0].MediaURLHttps
		}
		image := strings.Replace(message.User.ProfileImageURLHttps, "normal", "bigger", 1)
		mapped[i] = tweet{
			ID:      message.IDStr,
			From:    message.User.Name,
			Picture: image,
			Message: message.Text,
			Media:   media,
		}
	}
	return mapped, err
}
