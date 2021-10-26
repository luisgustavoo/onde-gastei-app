import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'OndeGastei';

  static ThemeData get theme => ThemeData(
        primaryColorBrightness: Brightness.light,
        primaryColor: const Color(0xFF32B768),
        primaryColorDark: const Color(0xff278F51),
        primaryColorLight: const Color(0xffDAF2E4),
        textTheme: TextTheme(
          bodyText2: GoogleFonts.jost(
            color: const Color(0xFF585666),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF32B768),
        ),
      );
}
