// src/shared/theme.js
export const Colors = {
  /** 🎨 Màu chính */
  primary: '#007AFF',
  primaryLight: '#00C6FF',
  primaryDark: '#0051A8',

  /** ⚪ Nền & text */
  background: '#F9FAFB',
  white: '#FFFFFF',
  black: '#000000',
  text: '#111827',
  textSecondary: '#6B7280',

  /** 🩺 Trạng thái */
  success: '#22C55E',
  warning: '#FACC15',
  error: '#EF4444',
  info: '#3B82F6',

  /** 🧩 Phụ */
  border: '#E5E7EB',
  card: '#FFFFFF',
  shadow: 'rgba(0, 0, 0, 0.1)',

  /** 🌙 Dark mode */
  darkBackground: '#1F2937',
  darkCard: '#374151',
  darkText: '#F3F4F6',
};

export const Typography = {
  fontFamily: 'System',
  fontSize: {
    xs: 12,
    sm: 14,
    md: 16,
    lg: 18,
    xl: 22,
    xxl: 28,
  },
  fontWeight: {
    light: '300',
    regular: '400',
    medium: '500',
    semiBold: '600',
    bold: '700',
  },
};

export const Spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
};

export const Radius = {
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  pill: 50,
  full: 9999,
};

export const Shadows = {
  sm: {
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 2,
  },
  md: {
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 6,
    elevation: 5,
  },
};

export const Theme = {
  Colors,
  Typography,
  Spacing,
  Radius,
  Shadows,
};
