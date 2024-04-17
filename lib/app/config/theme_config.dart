import 'package:flutter/material.dart';
import 'package:red_ela/app/config/color_config.dart';

class ThemeConfig {
  ThemeData get light {
    final fontFamily = "Montserrat";

    return ThemeData(
      primaryColor: ColorConfig.primary,
      splashColor: Colors.transparent,
      fontFamily: fontFamily,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConfig.primary,
        selectedItemColor: Colors.purple,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          maximumSize: const Size.fromHeight(54),
          backgroundColor: ColorConfig.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.blueGrey[50],
      primarySwatch: ColorConfig.from(ColorConfig.secondary),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: ColorConfig.from(ColorConfig.secondary),
        accentColor: const Color.fromARGB(255, 205, 62, 22),
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          letterSpacing: 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorConfig.primaryBackground,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorConfig.primaryBackground,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConfig.alternate,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConfig.alternate,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
