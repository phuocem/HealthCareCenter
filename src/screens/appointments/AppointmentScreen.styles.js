import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', padding: 16 },
  title: { fontSize: 20, fontWeight: 'bold', marginBottom: 12 },
  card: {
    backgroundColor: '#f9f9f9',
    borderRadius: 10,
    padding: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 5,
  },
  info: { marginBottom: 8 },
  doctor: { fontSize: 16, fontWeight: '600' },
  specialty: { color: '#555', marginBottom: 4 },
  date: { color: '#007AFF', marginBottom: 4 },
  symptoms: { color: '#333', fontStyle: 'italic', marginBottom: 4 },
  status: { fontWeight: '500', marginBottom: 8 },
  confirmed: { color: 'green' },
  pending: { color: 'orange' },
  completed: { color: 'blue' },
  cancelled: { color: 'red' },
  cancelButton: {
    backgroundColor: '#FF3B30',
    paddingVertical: 8,
    borderRadius: 6,
    alignItems: 'center',
  },
  cancelText: { color: '#fff', fontWeight: '600' },
  empty: { textAlign: 'center', color: '#777', marginTop: 40 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
});
