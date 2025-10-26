import { StyleSheet, Dimensions } from 'react-native';
import { Colors } from '../../shared/colors';

const { width, height } = Dimensions.get('window');

export const registerStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  gradientBackground: {
    flex: 1,
    justifyContent: 'center', // Center content vertically
    alignItems: 'center', // Center content horizontally
  },
  centeredContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    paddingHorizontal: width * 0.05, // Responsive padding
    paddingVertical: 20,
  },
  formContainer: {
    backgroundColor: Colors.white,
    borderRadius: 30,
    padding: 28,
    width: Math.min(width * 0.9, 400), // Max width of 400px or 90% of screen
    alignSelf: 'center',
    shadowColor: Colors.shadow,
    shadowOpacity: 0.2,
    shadowRadius: 16,
    shadowOffset: { width: 0, height: 4 },
    elevation: 10,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 24,
  },
  title: {
    fontSize: 28,
    fontWeight: '800',
    color: Colors.text,
    marginTop: 16,
    letterSpacing: 0.5,
    textShadowColor: 'rgba(0, 0, 0, 0.1)',
    textShadowOffset: { width: 1, height: 1 },
    textShadowRadius: 4,
  },
  subtitle: {
    fontSize: 16,
    color: Colors.textSecondary,
    marginBottom: 32,
    textAlign: 'center',
    lineHeight: 22,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 16,
    borderWidth: 1.5,
    borderColor: Colors.grayLight,
    marginBottom: 20,
    paddingHorizontal: 14,
    backgroundColor: Colors.white,
    shadowColor: Colors.shadow,
    shadowOpacity: 0.1,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 2 },
    elevation: 4,
  },
  inputError: {
    borderColor: '#F87171',
    shadowColor: '#F87171',
    shadowOpacity: 0.3,
  },
  errorText: {
    color: '#F87171',
    fontSize: 13,
    marginTop: 6,
    marginLeft: 34,
    fontWeight: '500',
  },
  icon: {
    marginRight: 10,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: Colors.text,
    paddingVertical: 16,
    fontWeight: '500',
  },
  button: {
    borderRadius: 16,
    overflow: 'hidden',
    marginTop: 12,
    shadowColor: Colors.primary,
    shadowOpacity: 0.4,
    shadowRadius: 12,
    shadowOffset: { width: 0, height: 6 },
    elevation: 8,
  },
  buttonGradient: {
    paddingVertical: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonDisabled: {
    opacity: 0.6,
  },
  buttonText: {
    color: Colors.white,
    fontSize: 18,
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  footer: {
    marginTop: 28,
    alignItems: 'center',
  },
  link: {
    color: Colors.textSecondary,
    fontSize: 16,
    fontWeight: '500',
  },
  linkBold: {
    fontWeight: '700',
    color: Colors.primary,
  },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  loadingText: {
    marginTop: 12,
    fontSize: 18,
    color: Colors.white,
    fontWeight: '600',
  },
});