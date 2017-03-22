import React from 'react';
import { ListView } from 'react-native';

const base = "benchr.bootes.uberspace.de:62957";

class TwitterClient {

  constructor(props) {
    this.tweets = [];
    this.onChange = props.onChange;
  }

  search(term) {
    return fetch('http://' + base + '/search?term=' + encodeURIComponent(term))
      .then((response) => response.json())
      .then((responseJson) => {
        this.tweets = responseJson;
        this.onChange();
      })
      .catch((error) => {
        console.error(error);
      });
  }

  stream(term) {
    this.stop();
    this.socket = new WebSocket('ws://' + base + '/stream?term=' + encodeURIComponent(term));
    this.socket.onmessage = (event) => {
      tweet = JSON.parse(event.data);
      console.log(event.data);
      // this.tweets.push(tweet);
      this.tweets.unshift(tweet);
      this.onChange();
    };
  }

  stop() {
    if (this.socket) {
      this.socket.close();
    }
  }

  clear() {
    this.tweets = [];
    this.onChange();
  }

}

TwitterClient.propTypes = {
  onChange: React.PropTypes.func.isRequired
};

export default TwitterClient;
