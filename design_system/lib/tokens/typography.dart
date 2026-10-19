import 'package:flutter/material.dart';

/// Sistema tipográfico (Roboto, migrado de `res/font`).
class DsTypography {
  DsTypography._();

  static const String fontFamily = 'Roboto';
  static const String package = 'design_system';

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    package: package,
  );

  static TextStyle get h1 => _base.copyWith(fontSize: 28, fontWeight: bold);
  static TextStyle get h2 => _base.copyWith(fontSize: 22, fontWeight: bold);
  static TextStyle get h3 => _base.copyWith(fontSize: 18, fontWeight: bold);
  static TextStyle get bodyBold =>
      _base.copyWith(fontSize: 16, fontWeight: bold);
  static TextStyle get bodyRegular =>
      _base.copyWith(fontSize: 16, fontWeight: regular);
  static TextStyle get caption =>
      _base.copyWith(fontSize: 13, fontWeight: regular);
  static TextStyle get captionBold =>
      _base.copyWith(fontSize: 13, fontWeight: bold);
  static TextStyle get small => _base.copyWith(fontSize: 11, fontWeight: bold);

  static TextStyle fontBoldSize(double size) =>
      _base.copyWith(fontSize: size, fontWeight: bold);

  static TextStyle fontRegularSize(double size) =>
      _base.copyWith(fontSize: size, fontWeight: regular);
}
