import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  // ── Dark Mode Color Palette ──
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF080808);
  static const Color foreground = Color(0xFFFFFFFF);

  // ── Light Mode Color Palette ──
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightGlassBg = Color(0x0D000000); // black 5%
  static const Color lightGlassBorder = Color(0x1A000000); // black 10%
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF334155);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightTextSubtle = Color(0xFF94A3B8);

  // Accent colors from liquid-glass
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color indigo600 = Color(0xFF4F46E5);

  // Glass effect colors (dark)
  static const Color glassBg = Color(0x0DFFFFFF); // white 5%
  static const Color glassBorder = Color(0x1AFFFFFF); // white 10%
  static const Color glassHoverBg = Color(0x1AFFFFFF); // white 10%
  static const Color glassHoverBorder = Color(0x33FFFFFF); // white 20%

  // Text opacity variants (dark)
  static const Color textPrimary = Color(0xFFFFFFFF); // 100%
  static const Color textSecondary = Color(0xCCFFFFFF); // 80%
  static const Color textMuted = Color(0x99FFFFFF); // 60%
  static const Color textSubtle = Color(0x66FFFFFF); // 40%

  // ── ShadThemeData: Dark ──
  static final liquidGlassDarkTheme = ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadSlateColorScheme.dark(
      background: background,
      foreground: foreground,
      primary: blue500,
      primaryForeground: Color(0xFF000000),
      secondary: purple600,
      secondaryForeground: foreground,
      destructive: Color(0xFFEF4444),
      destructiveForeground: foreground,
      muted: Color(0xFF1E293B),
      mutedForeground: textMuted,
      accent: Color(0xFF1E293B),
      accentForeground: foreground,
      card: glassBg,
      cardForeground: foreground,
      border: glassBorder,
      input: glassBorder,
      ring: blue400,
      selection: Color(0x4D3B82F6),
    ),
    radius: const BorderRadius.all(Radius.circular(16)),
    textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.notoSansKr),
  );

  // ── ShadThemeData: Light ──
  static final liquidGlassLightTheme = ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadSlateColorScheme.light(
      background: lightBackground,
      foreground: lightTextPrimary,
      primary: blue500,
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF1F5F9),
      secondaryForeground: lightTextPrimary,
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFF1F5F9),
      mutedForeground: lightTextMuted,
      accent: Color(0xFFF1F5F9),
      accentForeground: lightTextPrimary,
      card: lightSurface,
      cardForeground: lightTextPrimary,
      border: lightGlassBorder,
      input: lightGlassBorder,
      ring: blue500,
      selection: Color(0x263B82F6),
    ),
    radius: const BorderRadius.all(Radius.circular(16)),
    textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.notoSansKr),
  );

  // ── Material ThemeData (for compatibility) ──
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: blue500,
      onPrimary: Color(0xFF000000),
      secondary: purple600,
      onSecondary: foreground,
      surface: surface,
      onSurface: foreground,
      error: Color(0xFFEF4444),
      onError: foreground,
    ),
    textTheme: GoogleFonts.notoSansKrTextTheme(
      ThemeData.dark().textTheme,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: foreground,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: blue400, width: 1.5),
      ),
      filled: true,
      fillColor: glassBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(color: textMuted),
      hintStyle: const TextStyle(color: textSubtle),
      prefixIconColor: textMuted,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: foreground,
        foregroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        foregroundColor: foreground,
        side: const BorderSide(color: glassBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: blue400,
      unselectedItemColor: textSubtle,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: blue500,
      foregroundColor: foreground,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: glassBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: glassBorder),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: glassBg,
      contentTextStyle: const TextStyle(color: foreground),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: blue500,
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFF1F5F9),
      onSecondary: lightTextPrimary,
      surface: lightSurface,
      onSurface: lightTextPrimary,
      error: Color(0xFFEF4444),
      onError: Color(0xFFFFFFFF),
    ),
    textTheme: GoogleFonts.notoSansKrTextTheme(
      ThemeData.light().textTheme,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: lightTextPrimary,
    ),
  );

  // ── Reusable glass decoration ──
  static BoxDecoration glassDecoration({
    double borderRadius = 24,
    Color? backgroundColor,
    double borderOpacity = 0.1,
    Brightness brightness = Brightness.dark,
  }) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      color: backgroundColor ??
          (isDark ? glassBg : lightGlassBg),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: borderOpacity)
            : Colors.black.withValues(alpha: borderOpacity),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? const Color(0x5C000000)
              : const Color(0x1A000000),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
