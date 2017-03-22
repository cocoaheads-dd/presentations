import React, { Component } from 'react';
import {
  Image,
  StyleSheet,
  Text,
  TouchableHighlight,
  View
} from 'react-native';

class Tweet extends Component {

  render() {
    let media = null;
    if (this.props.media) {
      media = 
      (
        <TouchableHighlight onPress={() => this.props.imagePress(this.props.media)}>
          <Image resizeMode='center' style={styles.media} source={{uri: this.props.media}} />
        </TouchableHighlight>
      )
    }

    return (<View style={styles.container}>
      <Image progressiveRenderingEnabled={true} source={{uri: this.props.picture}} style={styles.image}></Image>
      <View style={styles.textContainer}>
        <Text style={styles.name}>{this.props.from}</Text>
        <Text style={styles.text}>{this.props.message}</Text>
        {media}
      </View>
    </View>);
  }

}

const styles = StyleSheet.create({
  container: {
    padding: 10, 
    flexDirection: 'row',
    justifyContent: 'flex-start'
  },
  image: {
    marginRight: 10,
    marginTop: 5,
    height: 50,
    width: 50,
    borderRadius: 5
  },
  textContainer: {
    flex: 8,
    flexDirection: 'column'
  },
  name: {
    color: 'red',
    fontWeight: '500',
    fontSize: 18
  },
  text: {
    fontSize: 14,
    fontWeight: '100'
  },
  media: {
    height: 100,
    width: 100,
    alignSelf: 'center'
  }
});

export default Tweet;
