import 'package:flutter/material.dart';

/// Paleta de PokeApp. Valores migrados de `res/values/colors.xml`
/// y `res/values-night/colors.xml` del proyecto Android original.
class DsColors {
  DsColors._();

  // --- BRAND ---
  static const Color primary = Color(0xFF006CDC);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color orange = Color(0xFFF07929);
  static const Color yellow = Color(0xFFF2B72A);
  static const Color purpleBlue = Color(0xFF5060BA);

  // --- SOCIAL ---
  static const Color facebook = Color(0xFF3B5998);
  static const Color google = Color(0xFFDB4437);

  // --- NEUTRALS ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF6F7FC);
  static const Color grey3 = Color(0xFFF7F7F7);
  static const Color grey5 = Color(0xFFF2F2F2);
  static const Color grey10 = Color(0xFFE6E6E6);
  static const Color grey20 = Color(0xFFCCCCCC);
  static const Color grey40 = Color(0xFF999999);
  static const Color grey60 = Color(0xFF666666);
  static const Color grey80 = Color(0xFF37474F);
  static const Color grey90 = Color(0xFF263238);
  static const Color transparent = Color(0x00000000);
  static const Color blackTransparent = Color(0xCC000000);

  // --- DARK ---
  static const Color darkBackground = Color(0xFF212125);
  static const Color darkSurface = Color(0xFF2C2D31);
  static const Color darkCard = Color(0xFF323334);

  // --- SEMANTIC ---
  static const Color success = Color(0xFF009688);
  static const Color error = Color(0xFFF44336);

  // --- POKÉMON TYPES ---
  static const Map<String, Color> pokemonTypes = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFF7D02C),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  static Color pokemonType(String type) => pokemonTypes[type] ?? grey40;
}
