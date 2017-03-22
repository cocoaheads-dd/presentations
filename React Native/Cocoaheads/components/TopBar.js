import React, { Component } from 'react';
import {
  Button,
  Keyboard,
  StyleSheet,
  TextInput,
  View
} from 'react-native';

export default class TopBar extends Component {

  constructor(props) {
    super(props);
    this.state = {
      term: 'Cocoaheads_DD',
      streaming: false
    }
  }

  componentDidMount() {
    this.props.search(this.state.term);
  }

  render() {
    return (<View style={styles.topBar}>
          <TextInput style={styles.input} 
                    returnKeyType="search" 
                    autoFocus={true}
                    autoCapitalize='none' 
                    value={this.state.term}
                    placeholder='Search something!'
                    selectionColor='red'
                    onChangeText={ (term) => this.setState({term}) }
                    onSubmitEditing={() => {
                      Keyboard.dismiss();
                      this.props.search(this.state.term);
                    }} />
          <View style={styles.buttons}>
            <Button title="Search" onPress={ () => this.props.search(this.state.term) }/>
            <Button title="Start" onPress={ () => {
                this.props.start(this.state.term);
                this.setState({streaming: true});
              }} disabled={this.state.streaming}/>
            <Button title="Stop" onPress={ () => {
                this.props.stop();
                this.setState({streaming: false});
              }} disabled={!this.state.streaming}/>
            <Button title="Clear" color='red' onPress={ () => this.props.clear() }/>
          </View>
        </View>)
  }

}

TopBar.propTypes = {
  search: React.PropTypes.func.isRequired,
  start: React.PropTypes.func.isRequired,
  stop: React.PropTypes.func.isRequired,
  clear: React.PropTypes.func.isRequired
}

const styles = StyleSheet.create({
  topBar: {
    flexDirection: 'column',
    paddingTop: 20,
    backgroundColor: '#f8f8f8'
  },
  input: {
    height: 40,
    backgroundColor: 'white', 
    borderRadius: 5,
    textAlign: 'center'
  },
  buttons: {
    flexDirection: 'row',
    justifyContent: 'space-around'
  }
})
