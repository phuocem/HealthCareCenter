import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f9f9f9',
    padding: 16,
  },
  title: {
    fontSize: 22,
    fontWeight: 'bold',
    marginBottom: 16,
    textAlign: 'center',
  },
  card: {
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 5,
    elevation: 3,
  },
  name: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  service: {
    fontSize: 15,
    color: '#444',
    marginTop: 6,
  },
  time: {
    fontSize: 15,
    color: '#555',
    marginTop: 6,
  },
  symptoms: {
    fontSize: 14,
    color: '#666',
    marginTop: 6,
  },
  status: {
    fontSize: 15,
    marginTop: 8,
  },
  emptyText: {
    textAlign: 'center',
    fontSize: 16,
    marginTop: 40,
    color: '#666',
  },
});
