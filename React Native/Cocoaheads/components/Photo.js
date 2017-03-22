import React, {Component} from 'react';
import {
  Image,
  Modal,
  StyleSheet,
  TouchableHighlight
} from 'react-native';

class Photo extends Component {

  render() {
    return (
      <Modal
        animationType='slide'
        visible={this.props.picture != null}
        supportedOrientations={['portrait', 'landscape']}>
        <TouchableHighlight
          onPress={() => this.props.onPress()}
          style={styles.all}
        >
          <Image resizeMode='contain' source={{uri: this.props.picture}} style={styles.all} />
        </TouchableHighlight>
      </Modal>
    )
  }

}

const styles = StyleSheet.create({
  all: {
    flex: 1
  }
});

Photo.propTypes = {
  visible: React.PropTypes.bool,
  onPress: React.PropTypes.func
}

export default Photo;
