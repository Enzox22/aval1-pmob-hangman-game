import 'package:flutter/material.dart';

const Color _seedColor = Color(0xFF2E5E8C);

ThemeData buildAppTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.surfaceContainer,
    ),
  );
}

/// Cor usada para acertos e vitória.
Color successColorOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

/// Cor de texto legível sobre [successColorOf].
Color onSuccessColorOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
