import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff455a65),
      surfaceTint: Color(0xff4c616c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5d737e),
      onPrimaryContainer: Color(0xffe9f7ff),
      secondary: Color(0xff624853),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7c606b),
      onSecondaryContainer: Color(0xffffdfea),
      tertiary: Color(0xff605f52),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff7f3e3),
      onTertiaryContainer: Color(0xff716f62),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf9f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff42474b),
      outline: Color(0xff73787b),
      outlineVariant: Color(0xffc2c7cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb3cad6),
      primaryFixed: Color(0xffcfe6f3),
      onPrimaryFixed: Color(0xff061e27),
      primaryFixedDim: Color(0xffb3cad6),
      onPrimaryFixedVariant: Color(0xff344a54),
      secondaryFixed: Color(0xfffdd9e6),
      onSecondaryFixed: Color(0xff2a151e),
      secondaryFixedDim: Color(0xffe0bdca),
      onSecondaryFixedVariant: Color(0xff59404a),
      tertiaryFixed: Color(0xffe6e3d3),
      onTertiaryFixed: Color(0xff1d1c12),
      tertiaryFixedDim: Color(0xffcac7b8),
      onTertiaryFixedVariant: Color(0xff48473c),
      surfaceDim: Color(0xffdcd9d9),
      surfaceBright: Color(0xfffcf9f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xfff0edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff233943),
      surfaceTint: Color(0xff4c616c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5a707b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff472f39),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7c606b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff38372c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6f6d61),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf9f8),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff32373a),
      outline: Color(0xff4e5356),
      outlineVariant: Color(0xff696e71),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb3cad6),
      primaryFixed: Color(0xff5a707b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff425862),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff826570),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff684d58),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6f6d61),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff575549),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc8c6c5),
      surfaceBright: Color(0xfffcf9f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xffebe7e7),
      surfaceContainerHigh: Color(0xffdfdcdc),
      surfaceContainerHighest: Color(0xffd4d1d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff192f38),
      surfaceTint: Color(0xff4c616c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff374c56),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c262f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5b424c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2d2c22),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4b4a3e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf9f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff282d30),
      outlineVariant: Color(0xff454a4d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb3cad6),
      primaryFixed: Color(0xff374c56),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff20353f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5b424c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff432c36),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4b4a3e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff343328),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b8),
      surfaceBright: Color(0xfffcf9f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f0ef),
      surfaceContainer: Color(0xffe5e2e1),
      surfaceContainerHigh: Color(0xffd7d4d3),
      surfaceContainerHighest: Color(0xffc8c6c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb3cad6),
      surfaceTint: Color(0xffb3cad6),
      onPrimary: Color(0xff1d333d),
      primaryContainer: Color(0xff5d737e),
      onPrimaryContainer: Color(0xffe9f7ff),
      secondary: Color(0xffe0bdca),
      onSecondary: Color(0xff412a33),
      secondaryContainer: Color(0xff7c606b),
      onSecondaryContainer: Color(0xffffdfea),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff323126),
      tertiaryContainer: Color(0xffe6e3d3),
      onTertiaryContainer: Color(0xff666558),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc2c7cb),
      outline: Color(0xff8c9195),
      outlineVariant: Color(0xff42474b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff4c616c),
      primaryFixed: Color(0xffcfe6f3),
      onPrimaryFixed: Color(0xff061e27),
      primaryFixedDim: Color(0xffb3cad6),
      onPrimaryFixedVariant: Color(0xff344a54),
      secondaryFixed: Color(0xfffdd9e6),
      onSecondaryFixed: Color(0xff2a151e),
      secondaryFixedDim: Color(0xffe0bdca),
      onSecondaryFixedVariant: Color(0xff59404a),
      tertiaryFixed: Color(0xffe6e3d3),
      onTertiaryFixed: Color(0xff1d1c12),
      tertiaryFixedDim: Color(0xffcac7b8),
      onTertiaryFixedVariant: Color(0xff48473c),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353534),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc9e0ec),
      surfaceTint: Color(0xffb3cad6),
      onPrimary: Color(0xff122832),
      primaryContainer: Color(0xff7e94a0),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff7d3e0),
      onSecondary: Color(0xff351f29),
      secondaryContainer: Color(0xffa78894),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff323126),
      tertiaryContainer: Color(0xffe6e3d3),
      onTertiaryContainer: Color(0xff4a483d),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8dde0),
      outline: Color(0xffaeb3b6),
      outlineVariant: Color(0xff8c9194),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff354b55),
      primaryFixed: Color(0xffcfe6f3),
      onPrimaryFixed: Color(0xff00131c),
      primaryFixedDim: Color(0xffb3cad6),
      onPrimaryFixedVariant: Color(0xff233943),
      secondaryFixed: Color(0xfffdd9e6),
      onSecondaryFixed: Color(0xff1e0b14),
      secondaryFixedDim: Color(0xffe0bdca),
      onSecondaryFixedVariant: Color(0xff472f39),
      tertiaryFixed: Color(0xffe6e3d3),
      onTertiaryFixed: Color(0xff121209),
      tertiaryFixedDim: Color(0xffcac7b8),
      onTertiaryFixedVariant: Color(0xff38372c),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff454444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1e1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff333232),
      surfaceContainerHighest: Color(0xff3e3d3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdef3ff),
      surfaceTint: Color(0xffb3cad6),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffafc6d2),
      onPrimaryContainer: Color(0xff000d14),
      secondary: Color(0xffffebf1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffdcbac6),
      onSecondaryContainer: Color(0xff17060e),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe6e3d3),
      onTertiaryContainer: Color(0xff2b2a20),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecf1f4),
      outlineVariant: Color(0xffbec3c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff354b55),
      primaryFixed: Color(0xffcfe6f3),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb3cad6),
      onPrimaryFixedVariant: Color(0xff00131c),
      secondaryFixed: Color(0xfffdd9e6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe0bdca),
      onSecondaryFixedVariant: Color(0xff1e0b14),
      tertiaryFixed: Color(0xffe6e3d3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcac7b8),
      onTertiaryFixedVariant: Color(0xff121209),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff515050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f1f),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3b),
      surfaceContainerHighest: Color(0xff474646),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}