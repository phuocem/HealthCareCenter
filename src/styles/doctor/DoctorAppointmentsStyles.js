import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5', // Nền sáng nhẹ
    paddingTop: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1E293B', // Màu chữ đậm
    textAlign: 'center',
    marginBottom: 20,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 16,
    marginHorizontal: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3, // Shadow cho Android
  },
  name: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1E293B',
    marginBottom: 4,
  },
  service: {
    fontSize: 16,
    color: '#64748B', // Màu chữ phụ
    marginBottom: 4,
  },
  time: {
    fontSize: 14,
    color: '#94A3B8',
    marginBottom: 4,
  },
  symptoms: {
    fontSize: 14,
    color: '#EF4444', // Màu đỏ nhẹ cho triệu chứng
    marginBottom: 8,
  },
  status: {
    fontSize: 14,
    fontWeight: '500',
    marginBottom: 8,
  },
  confirmButton: {
    backgroundColor: '#2ecc71', // Xanh lá
    padding: 8,
    borderRadius: 8,
    marginTop: 8,
    alignItems: 'center',
  },
  confirmButtonText: {
    color: '#FFFFFF',
    fontWeight: 'bold',
    fontSize: 14,
  },
  cancelButton: {
    backgroundColor: '#e74c3c', // Đỏ
    padding: 8,
    borderRadius: 8,
    marginTop: 8,
    alignItems: 'center',
  },
  cancelButtonText: {
    color: '#FFFFFF',
    fontWeight: 'bold',
    fontSize: 14,
  },
  emptyText: {
    fontSize: 16,
    color: '#64748B',
    textAlign: 'center',
    marginTop: 20,
  },
});