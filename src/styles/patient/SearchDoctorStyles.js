// src/styles/patient/SearchDoctorScreenStyles.js
import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#F5F6FA',
  },

  searchInput: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 12,
    marginBottom: 16,
    borderColor: '#ddd',
    borderWidth: 1,
    fontSize: 16,
  },

  doctorCard: {
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },

  doctorName: {
    fontSize: 18,
    fontWeight: '700',
    color: '#1a1a1a',
  },

  doctorDepartment: {
    color: '#555',
    marginVertical: 4,
    fontSize: 15,
  },

  bookButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#007AFF',
    borderRadius: 8,
    paddingVertical: 10,
    justifyContent: 'center',
    marginTop: 10,
    shadowColor: '#007AFF',
    shadowOpacity: 0.25,
    shadowRadius: 6,
    elevation: 4,
  },

  bookButtonText: {
    color: 'white',
    fontWeight: '600',
    marginLeft: 6,
    fontSize: 16,
  },

  emptyText: {
    textAlign: 'center',
    color: '#666',
    marginTop: 20,
    fontSize: 15,
  },
});
