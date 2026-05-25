import 'package:flutter/material.dart';

class AppColors {
  
  static const primary = Color(0xFF004C83);    
  static const secondary = Color(0xFF00A4E4);  
  static const accent = Color(0xFFE31A2D);     
  
  
  static const background = Color(0xFFF8FAFC); 
  static const surface = Colors.white;
  static const glass = Color(0x33FFFFFF);
  
  
  static const success = Color(0xFF10B981); 
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  
  
  static const textPrimary = Color(0xFF0F172A); 
  static const textSecondary = Color(0xFF475569); 
  static const textMuted = Color(0xFF94A3B8);
  
  
  static const doctor = Color(0xFF0F766E); 
  static const patient = Color(0xFF0284C7); 
  static const admin = Color(0xFF0F172A);
  
  
  
  
  static const patientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF0369A1), Color(0xFF0C4A6E)],
  );
  
  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x26FFFFFF), Color(0x0DFFFFFF)],
  );
  
  static const neonBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
  );

  static const neonEmeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF059669)],
  );
  
  static const neonPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC084FC), Color(0xFF7C3AED)],
  );

  static const neonOrangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
  );
  
  static const neonPinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF472B6), Color(0xFFDB2777)],
  );
  
  static const doctorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
  );

  
  static const adminBg = Color(0xFF080D1A);        
  static const adminSurface = Color(0xFF0F1626);   
  static const adminCardBorder = Color(0xFF1E293B); 
  static const adminGlowColor = Color(0x1A38BDF8);  
  static const adminTextPrimary = Color(0xFFF8FAFC);
  static const adminTextSecondary = Color(0xFF94A3B8);
  static const adminTextMuted = Color(0xFF64748B);
  
  static const adminGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF020617)],
  );
  
  static const adminPanelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get neonGlowBlue => [
    BoxShadow(
      color: const Color(0xFF0284C7).withValues(alpha: 0.15),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];
  
  static List<BoxShadow> get neonGlowEmerald => [
    BoxShadow(
      color: const Color(0xFF059669).withValues(alpha: 0.15),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];
}
