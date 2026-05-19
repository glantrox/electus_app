import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color coreBlack;
  final Color elevatedSurface;
  final Color glassBackground;

  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  const CustomColors({
    required this.coreBlack,
    required this.elevatedSurface,
    required this.glassBackground,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
  });

  @override
  CustomColors copyWith({
    Color? coreBlack,
    Color? elevatedSurface,
    Color? glassBackground,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
  }) {
    return CustomColors(
      coreBlack: coreBlack ?? this.coreBlack,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      glassBackground: glassBackground ?? this.glassBackground,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      coreBlack: Color.lerp(coreBlack, other.coreBlack, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant: Color.lerp(
        onPrimaryFixedVariant,
        other.onPrimaryFixedVariant,
        t,
      )!,
    );
  }
}

class AppTheme {
  static final ColorScheme darkColorScheme = const ColorScheme.dark(
    surface: Color(0xFF10141A),
    surfaceDim: Color(0xFF10141A),
    surfaceBright: Color(0xFF353940),
    surfaceContainerLowest: Color(0xFF0A0E14),
    surfaceContainerLow: Color(0xFF181C22),
    surfaceContainer: Color(0xFF1C2026),
    surfaceContainerHigh: Color(0xFF262A31),
    surfaceContainerHighest: Color(0xFF31353C),
    onSurface: Color(0xFFDFE2EB),
    onSurfaceVariant: Color(0xFFB9CACB),
    inverseSurface: Color(0xFFDFE2EB),
    outline: Color(0xFF849495),
    outlineVariant: Color(0xFF3A494B),
    surfaceTint: Color(0xFF00DBE7),
    primary: Color(0xFFE1FDFF),
    onPrimary: Color(0xFF00363A),
    primaryContainer: Color(0xFF00F2FF),
    onPrimaryContainer: Color(0xFF006A71),
    inversePrimary: Color(0xFF00696F),
    secondary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF1F3700),
    secondaryContainer: Color(0xFFA0FB00),
    onSecondaryContainer: Color(0xFF457000),
    tertiary: Color(0xFFFEF5FF),
    onTertiary: Color(0xFF480081),
    tertiaryContainer: Color(0xFFEAD2FF),
    onTertiaryContainer: Color(0xFF8624DE),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    // Fallbacks since Flutter < 3.22 backgrounds are deprecated but still needed sometimes
    // ignore: deprecated_member_use
    background: Color(0xFF10141A),
    // ignore: deprecated_member_use
    onBackground: Color(0xFFDFE2EB),
  );

  static final ColorScheme lightColorScheme = const ColorScheme.light(
    surface: Color(0xFFF8F9FF),
    surfaceDim: Color(0xFFEDADAD), // Or mapping logically
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF4F6FB),
    surfaceContainer: Color(0xFFF0F4F8),
    surfaceContainerHigh: Color(0xFFE2E8F0),
    surfaceContainerHighest: Color(0xFFCBD5E1),
    onSurface: Color(0xFF10141A),
    onSurfaceVariant: Color(0xFF475569),
    inverseSurface: Color(0xFF10141A),
    outline: Color(0xFF94A3B8),
    outlineVariant: Color(0xFFCBD5E1),
    surfaceTint: Color(0xFF006A71),
    primary: Color(0xFF006A71),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF74F5FF),
    onPrimaryContainer: Color(0xFF002022),
    inversePrimary: Color(0xFFE1FDFF),
    secondary: Color(0xFF457000),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFA0FB00),
    onSecondaryContainer: Color(0xFF1F3700),
    tertiary: Color(0xFF8624DE),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEAD2FF),
    onTertiaryContainer: Color(0xFF480081),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    // ignore: deprecated_member_use
    background: Color(0xFFF8F9FF),
    // ignore: deprecated_member_use
    onBackground: Color(0xFF10141A),
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,
      extensions: const [
        CustomColors(
          coreBlack: Color(0xFF000000),
          elevatedSurface: Color(0xFF0D1117),
          glassBackground: Color(0xB30D1117),
          primaryFixed: Color(0xFF74F5FF),
          primaryFixedDim: Color(0xFF00DBE7),
          onPrimaryFixed: Color(0xFF002022),
          onPrimaryFixedVariant: Color(0xFF004F54),
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.surface,
      extensions: const [
        CustomColors(
          coreBlack: Color(0xFFFFFFFF),
          elevatedSurface: Color(0xFFF0F4F8),
          glassBackground: Color(0xB3FFFFFF),
          primaryFixed: Color(0xFF74F5FF),
          primaryFixedDim: Color(0xFF00DBE7),
          onPrimaryFixed: Color(0xFF002022),
          onPrimaryFixedVariant: Color(0xFF004F54),
        ),
      ],
    );
  }
}

extension ThemeContextOnColor on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
}
