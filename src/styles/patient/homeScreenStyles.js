// styles/patient/homeScreenStyles.js
import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F8FAFC' },
  content: { paddingBottom: 140 },

  // Header
  headerContainer: {
    height: 300,
    borderBottomLeftRadius: 40,
    borderBottomRightRadius: 40,
    overflow: 'hidden',
    elevation: 20,
  },
  headerBlur: {
    ...StyleSheet.absoluteFillObject,
    paddingHorizontal: 28,
    paddingTop: 70,
    justifyContent: 'space-between',
  },
  greeting: { fontSize: 18, color: '#E3F2FD', fontWeight: '600' },
  appName: { fontSize: 42, fontWeight: '900', color: '#FFF' },
  tagline: { fontSize: 16, color: '#BBDEFB' },

  // Health Ring
  ringContainer: { alignItems: 'center', marginTop: 20 },
  ringBg: {
    width: 90, height: 90,
    borderRadius: 45,
    backgroundColor: 'rgba(255,255,255,0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  ringProgress: {
    width: 90, height: 90,
    borderRadius: 45,
    borderWidth: 6,
    borderColor: '#4CAF50',
    position: 'absolute',
    borderLeftColor: 'transparent',
    borderBottomColor: 'transparent',
  },
  ringCenter: { alignItems: 'center' },
  ringValue: { fontSize: 18, fontWeight: '700', color: '#FFF' },
  ringLabel: { fontSize: 12, color: '#E0F7FA' },

  // FAB
  fabCard: { position: 'absolute', top: 260, left: 40, right: 40, zIndex: 10 },
  fabInner: { borderRadius: 28, overflow: 'hidden', elevation: 15 },
  fabGradient: { padding: 3 },
  fabBlur: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingVertical: 18 },

  // Menu
  menuGrid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'center', paddingHorizontal: 16, marginTop: 100, marginBottom: 24 },
  menuCard: { width: '44%', marginBottom: 20 },
  cardDark: { backgroundColor: '#1E1E1E' },
  cardGradient: { padding: 3, borderRadius: 24 },
  cardBlur: { padding: 20, borderRadius: 21, alignItems: 'center', backgroundColor: 'rgba(255,255,255,0.15)' },

  // Hero + Bottom
  heroContainer: { marginHorizontal: 20, height: 240, borderRadius: 32, overflow: 'hidden', marginBottom: 20 },
  heroImage: { width: '100%', height: '100%' },
  heroOverlay: { ...StyleSheet.absoluteFillObject, justifyContent: 'flex-end', padding: 24 },
  heroTitle: { color: '#FFF', fontSize: 24, fontWeight: '800' },
  heroSubtitle: { color: '#BBDEFB', fontSize: 14 },
  bottomHint: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginVertical: 24 },
  hintText: { marginLeft: 8, color: '#666', fontSize: 13, fontStyle: 'italic' },

  // Badge
  comingSoonBadge: { position: 'absolute', top: -8, right: -8, backgroundColor: '#FF3B30', paddingHorizontal: 8, paddingVertical: 3, borderRadius: 12, borderWidth: 2, borderColor: '#FFF' },
  badgeText: { color: '#FFF', fontSize: 9, fontWeight: '800' },
  cardTitle: { color: '#FFF', fontSize: 14, fontWeight: '700', textAlign: 'center', marginTop: 8, lineHeight: 18 },
  fabText: { color: '#FFF', fontWeight: '700', fontSize: 17, marginLeft: 12 },
});