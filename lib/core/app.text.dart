import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle config(double size,
          {Color? color = Colors.black, FontWeight? fontWeight}) =>
      GoogleFonts.poppins(
          color: color, height: 1.4, fontSize: size, fontWeight: fontWeight);

  static TextStyle textShadow(TextStyle style, {List<Shadow>? shadows}) =>
      GoogleFonts.poppins(
          color: style.color,
          height: 1.4,
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          shadows: shadows);

  static TextStyle extraLight(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w200);

  static TextStyle light(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w300);

  static TextStyle regular(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w400);

  static TextStyle medium(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w500);

  static TextStyle semiBold(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w600);

  static TextStyle bold(double size,
          {Color? color = Colors.black, decoration}) =>
      config(size, color: color, fontWeight: FontWeight.w700);

  static TextStyle extraBold(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w800);

  static TextStyle black(double size, {Color? color = Colors.black}) =>
      config(size, color: color, fontWeight: FontWeight.w900);
}
