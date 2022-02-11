import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const accessToken = 'access_token_key';
  static const refreshToken = 'refresh_token_key';

  static const int defaultIconCode = 0xe332;
  static const int defaultColorCode = 0xFF9E9E9E;

  static const Color primaryColor = Color(0xFF32B768);

  static const primaryColorDark = Color(0xff278F51);

  static const primaryColorLight = Color(0xffDAF2E4);

  static const Color hintStyleColor = Color(0xFFC0C2D1);

  static const Color iconThemeColor = Color(0xFF585666);

  static const Color titleTextStyleColor = Color(0xFF585666);

  static const Color subtitle1Color = Color(0xFF585666);

  static const bodyText2Color = Color(0xFF585666);

  static const Color fillColor = Color(0xFFEFEFEF);

  static const labelStyleColor = Color(0xFFC0C2D1);

  static MaterialColor get primarySwatch => MaterialColor(
        0xFF32B768,
        <int, Color>{
          50: const Color(0xFF32B768).withAlpha(50),
          100: const Color(0xFF32B768).withAlpha(100),
          200: const Color(0xFF32B768).withAlpha(200),
          300: const Color(0xFF32B768).withAlpha(300),
          400: const Color(0xFF32B768).withAlpha(400),
          500: const Color(0xFF32B768).withAlpha(500),
          600: const Color(0xFF32B768).withAlpha(600),
          700: const Color(0xFF32B768).withAlpha(700),
          800: const Color(0xFF32B768).withAlpha(800),
          900: const Color(0xFF32B768).withAlpha(900),
        },
      );
}
