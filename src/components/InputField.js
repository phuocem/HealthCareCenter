import React from 'react';
import { TextInput, StyleSheet } from 'react-native';

export default function InputField({ ...props }) {
  return <TextInput style={styles.input} {...props} />;
}

const styles = StyleSheet.create({
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 12,
    marginBottom: 10,
  },
});
