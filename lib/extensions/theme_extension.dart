import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension ColorExtension on Color {
  // Using alpha blends is a simple way to make a lighter shade of an existing
// color. Use the source color as background, and overlay it with white and
// vary its alpha to produce a lighter shade of the source color.
  Color get lighter => Color.alphaBlend(Colors.white.withAlpha(0x66), this);

// To make a darker shade, do the same but use a black overlay and vary its
// alpha to produce a darker shade of the source color.
  Color get darker => Color.alphaBlend(Colors.black.withAlpha(0x66), this);

  Color linearThemeModeColor(BuildContext context) =>
      context.isDarkMode ? darker : lighter;

  Color contraryThemeModeColor(BuildContext context) =>
      context.isDarkMode ? lighter : darker;

  String toRGBString(double opacity) {
    return 'rgba($red, $green, $blue, $opacity)';
  }
}
