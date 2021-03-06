import 'dart:ui';
import 'package:TaxiApp/style/themeData.dart';
import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static Color primaryColor = namelaTheme.primaryColor;
  static Color onPrimary = namelaTheme.colorScheme.onPrimary;

  static const Color gradientStart = const Color(0xFF212121);
  static const Color gradientEnd = const Color(0xFF616161);
  static const Color accentColor = Color(0xFFFFC107);

  static const primaryGradient = const LinearGradient(
    colors: const [gradientStart, gradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
