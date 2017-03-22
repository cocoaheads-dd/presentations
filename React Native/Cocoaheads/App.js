import React, { Component } from 'react';
import { 
  FlatList,
  StyleSheet,
  Text,
  View
 } from 'react-native';
import TwitterClient from './components/TwitterClient';
import Tweet from './components/Tweet';
import Photo from './components/Photo';
import TopBar from './components/TopBar';

export default class App extends Component {

  constructor(props) {
    super(props);
    this.twitter = new TwitterClient({
      onChange: this.refresh.bind(this),
    });
    this.state = {
      tweets: this.twitter.tweets,
      loading: false,
      picture: null
    };
  }

  refresh() {
    this.setState({
      loading: false,
      tweets: this.twitter.tweets
    });
  }

  render() {

    let content = null;
    if (this.state.loading) {
      content = (<Text style={styles.loadingText}>Loading...</Text>)
    } else {
      if (this.state.tweets.length === 0) {
        content = <Text style={styles.loadingText}>Nothing found... :(</Text>
      } else {
        content = (<FlatList
            data={this.state.tweets}
            renderItem={(data) => <Tweet {...data.item} 
                                        imagePress={(url) => this.setState({picture: url})} />
                      }
            style={styles.list}
          />)
        }
    }

    return (
      <View style={styles.app}>
        <Photo 
          picture={this.state.picture}
          onPress={() => this.setState({picture: null})}
        />
        <TopBar
                search={(term) => this.startSearch(term) }
                start={(term) => this.startStream(term) }
                stop={() => this.endStream() }
                clear={() => this.twitter.clear() }
                />

        {content}
      </View>);
  }

  startSearch(term) {
    this.setState({loading: true});
    this.twitter.search(term);
  }

  startStream(term) {
    this.twitter.stream(term)
    this.setState({loading: false, streaming: true})
  }

  endStream() {
    this.twitter.stop()
    this.setState({streaming: false})
  }

}

const styles = StyleSheet.create({
  app: {
    flex: 1,
    flexDirection: 'column'
  },
  loadingText: {
    textAlign: 'center',
    fontSize: 24,
    padding: 20
  },
  list: {}
})
