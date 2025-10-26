// src/styles/patient/patientDrawerStyles.js
import { StyleSheet, Platform } from 'react-native';

export const patientDrawerStyles = StyleSheet.create({
  drawerContainer: {
    flex: 1,
    paddingTop: Platform.OS === 'ios' ? 50 : 40,
    borderTopRightRadius: 36,
    borderBottomRightRadius: 36,
    overflow: 'hidden',
  },
  headerContainer: {
    alignItems: 'center',
    paddingVertical: 28,
    marginHorizontal: 16,
    borderRadius: 24,
    backgroundColor: 'rgba(255,255,255,0.2)',
  },
  avatarWrapper: {
    marginBottom: 14,
    shadowColor: '#00C6FF',
    shadowOpacity: 0.5,
    shadowRadius: 10,
  },
  avatarBorder: {
    padding: 3,
    borderRadius: 100,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 100,
  },
  userName: { color: '#fff', fontSize: 19, fontWeight: '700' },
  userEmail: { color: '#E6F0FF', fontSize: 14, opacity: 0.9 },
  menuContainer: { flex: 1, marginTop: 24, paddingHorizontal: 12 },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 16,
    marginBottom: 10,
    backgroundColor: 'rgba(255,255,255,0.12)',
  },
  iconWrapper: { width: 32, alignItems: 'center', justifyContent: 'center' },
  menuText: { color: '#fff', fontSize: 16, fontWeight: '500', marginLeft: 8 },
  footer: {
    padding: 16,
    borderTopWidth: 0.3,
    borderTopColor: 'rgba(255,255,255,0.3)',
  },
  logoutButton: { alignItems: 'center', marginBottom: 8 },
  logoutGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    borderRadius: 20,
    paddingVertical: 10,
    paddingHorizontal: 20,
    shadowColor: '#FF6B6B',
    shadowOpacity: 0.4,
    shadowRadius: 8,
  },
  logoutText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  versionText: { color: '#E6F0FF', fontSize: 13, opacity: 0.8, textAlign: 'center' },
});
