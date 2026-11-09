import 'package:flutter/material.dart';
import 'brand.dart';

class AppPalette {
  final Color bg, card, border, text, muted, tint;
  const AppPalette(
      {required this.bg,
      required this.card,
      required this.border,
      required this.text,
      required this.muted,
      required this.tint});

  static const light = AppPalette(
      bg: Brand.lightBg,
      card: Brand.lightCard,
      border: Color(0x14000000),
      text: Color(0xFF14161A),
      muted: Color(0xFF6B7280),
      tint: Brand.lightTint);

  static const dark = AppPalette(
      bg: Brand.darkBg,
      card: Brand.darkCard,
      border: Color(0x1FFFFFFF),
      text: Colors.white,
      muted: Color(0xFF9CA3AF),
      tint: Brand.darkTint);
}

extension PaletteX on BuildContext {
  AppPalette get pal =>
      Theme.of(this).brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
}

ThemeData buildTheme(Brightness b) {
  final p = b == Brightness.dark ? AppPalette.dark : AppPalette.light;
  final base = ThemeData(brightness: b);
  final scheme = ColorScheme.fromSeed(seedColor: Brand.primary, brightness: b)
      .copyWith(primary: Brand.primary, surface: p.card, onSurface: p.text);
  OutlineInputBorder ob(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: c, width: w));
  return ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.bg,
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    appBarTheme: AppBarTheme(
      backgroundColor: p.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: p.text,
      titleTextStyle: TextStyle(color: p.text, fontSize: 18, fontWeight: FontWeight.w800),
    ),
    cardTheme: CardThemeData(
      color: p.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), side: BorderSide(color: p.border)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.card,
      labelStyle: TextStyle(color: p.muted),
      hintStyle: TextStyle(color: p.muted),
      border: ob(p.border),
      enabledBorder: ob(p.border),
      focusedBorder: ob(Brand.primary, 1.5),
      errorBorder: ob(Colors.redAccent),
      focusedErrorBorder: ob(Colors.redAccent, 1.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Brand.primary,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Brand.primary,
        side: const BorderSide(color: Brand.primary, width: 1.5),
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.card,
      selectedColor: Brand.primary.withOpacity(0.16),
      side: BorderSide(color: p.border),
      labelStyle: TextStyle(color: p.text, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Brand.primary.withOpacity(0.16),
      labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.text)),
    ),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: p.card, surfaceTintColor: Colors.transparent),
    dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    popupMenuTheme: PopupMenuThemeData(
        color: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: b == Brightness.dark ? const Color(0xFF2A2A30) : const Color(0xFF1F2024),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    sliderTheme: SliderThemeData(
        activeTrackColor: Brand.primary,
        thumbColor: Brand.primary,
        inactiveTrackColor: p.border,
        overlayColor: Brand.primary.withOpacity(0.15)),
    dividerColor: p.border,
    switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? Colors.white : null),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? Brand.primary : null)),
  );
}
