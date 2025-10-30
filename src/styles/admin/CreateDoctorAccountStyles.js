import { StyleSheet, Platform } from 'react-native';

export const styles = StyleSheet.create({
  // Container chính
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
    paddingHorizontal: 20,
    paddingTop: 16,
  },

  // Tiêu đề
  title: {
    fontSize: 26,
    fontWeight: '700',
    color: '#1a1a1a',
    textAlign: 'center',
    marginBottom: 28,
    letterSpacing: 0.3,
  },

  // Nhóm input
  inputGroup: {
    marginBottom: 18,
  },

  label: {
    fontSize: 14,
    fontWeight: '600',
    color: '#2c3e50',
    marginBottom: 8,
    letterSpacing: 0.2,
  },

  // Input có icon
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: '#dfe6e9',
    borderRadius: 14,
    backgroundColor: '#fff',
    paddingHorizontal: 14,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.08,
        shadowRadius: 4,
      },
      android: {
        elevation: 3,
      },
    }),
  },

  icon: {
    marginRight: 10,
  },

  inputWithIcon: {
    flex: 1,
    paddingVertical: 16,
    fontSize: 16,
    color: '#2d3436',
    letterSpacing: 0.3,
  },

  // Dropdown chọn khoa
  dropdownButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1.5,
    borderColor: '#dfe6e9',
    borderRadius: 14,
    backgroundColor: '#fff',
    paddingHorizontal: 14,
    paddingVertical: 16,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.08,
        shadowRadius: 4,
      },
      android: {
        elevation: 3,
      },
    }),
  },

  dropdownText: {
    flex: 1,
    fontSize: 16,
    color: '#2d3436',
    marginLeft: 10,
  },

  // TextArea Bio
  textAreaWrapper: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    borderWidth: 1.5,
    borderColor: '#dfe6e9',
    borderRadius: 14,
    backgroundColor: '#fff',
    paddingHorizontal: 14,
    minHeight: 110,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.08,
        shadowRadius: 4,
      },
      android: {
        elevation: 3,
      },
    }),
  },

  textArea: {
    flex: 1,
    paddingTop: 14,
    fontSize: 16,
    color: '#2d3436',
    textAlignVertical: 'top',
    lineHeight: 22,
  },

  // Nút tạo
  button: {
    backgroundColor: '#007AFF',
    paddingVertical: 17,
    borderRadius: 16,
    alignItems: 'center',
    marginTop: 28,
    marginBottom: 20,
    ...Platform.select({
      ios: {
        shadowColor: '#007AFF',
        shadowOffset: { width: 0, height: 6 },
        shadowOpacity: 0.35,
        shadowRadius: 12,
      },
      android: {
        elevation: 8,
      },
    }),
  },

  buttonDisabled: {
    backgroundColor: '#b0b0b0',
    elevation: 0,
    shadowOpacity: 0,
  },

  buttonText: {
    color: '#fff',
    fontSize: 17,
    fontWeight: '600',
    letterSpacing: 0.3,
  },

  // Modal
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.55)',
  },

  modalContent: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: '#fff',
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    padding: 22,
    maxHeight: '88%',
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -4 },
        shadowOpacity: 0.2,
        shadowRadius: 12,
      },
      android: {
        elevation: 12,
      },
    }),
  },

  modalTitle: {
    fontSize: 19,
    fontWeight: '700',
    textAlign: 'center',
    color: '#1a1a1a',
    marginBottom: 18,
  },

  // Thanh tìm kiếm trong modal
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: '#e9ecef',
    borderRadius: 14,
    paddingHorizontal: 12,
    backgroundColor: '#f8f9fa',
    marginBottom: 16,
  },

  searchInput: {
    flex: 1,
    paddingVertical: 13,
    fontSize: 16,
    marginLeft: 8,
    color: '#2d3436',
  },

  // Mục khoa trong danh sách
  deptItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 15,
    paddingHorizontal: 6,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f2f6',
  },

  deptName: {
    fontSize: 16,
    color: '#2d3436',
    fontWeight: '500',
  },

  emptyText: {
    textAlign: 'center',
    color: '#95a5a6',
    fontStyle: 'italic',
    paddingVertical: 32,
    fontSize: 15,
  },

  // Nút hủy
  cancelButton: {
    marginTop: 14,
    paddingVertical: 15,
    backgroundColor: '#f8f9fa',
    borderRadius: 14,
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: '#dfe6e9',
  },

  cancelText: {
    fontSize: 16,
    color: '#636e72',
    fontWeight: '600',
  },
});