import { StyleSheet } from 'react-native';
import { Colors } from '../../shared/colors';

export const profileStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },

  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },

  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: Colors.textSecondary,
  },

  errorText: {
    fontSize: 16,
    color: Colors.error,
    textAlign: 'center',
    marginBottom: 12,
  },

  retryButton: {
    backgroundColor: Colors.primary,
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 12,
  },

  retryButtonText: {
    color: Colors.white,
    fontWeight: '600',
  },

  card: {
    backgroundColor: Colors.card,
    borderRadius: 16,
    padding: 24,
    margin: 16,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 6,
    elevation: 4,
  },

  header: {
    alignItems: 'center',
    marginBottom: 24,
  },

  title: {
    fontSize: 22,
    fontWeight: '700',
    color: Colors.text,
    marginTop: 8,
  },

  subtitle: {
    fontSize: 15,
    color: Colors.textSecondary,
    marginTop: 4,
  },

  infoContainer: {
    marginTop: 10,
    gap: 12,
  },

  infoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.background,
    borderRadius: 12,
    padding: 12,
  },

  infoIcon: {
    marginRight: 12,
  },

  label: {
    fontSize: 14,
    fontWeight: '500',
    color: Colors.textSecondary,
  },

  value: {
    fontSize: 16,
    color: Colors.text,
    fontWeight: '600',
  },

  editButton: {
    marginTop: 20,
  },

  editButtonGradient: {
    paddingVertical: 12,
    borderRadius: 14,
    alignItems: 'center',
  },

  editButtonText: {
    color: Colors.white,
    fontWeight: '600',
    fontSize: 16,
  },
});
