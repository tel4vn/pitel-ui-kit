import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff009C36);
  static const Color secondary = Color(0xff009C36);
  static const Color black = Color(0xff141414);
  static const Color white = Color(0xffffffff);
  static const Color primary1 = Color(0xff131521);
  static const Color primary2 = Color(0xffff9800);
  static Color white20 = const Color(0xffffffff).withOpacity(0.2);
  static Color white6 = const Color(0xffffffff).withOpacity(0.06);
  static Color white4 = const Color(0xffffffff).withOpacity(0.04);
  static Color white50 = const Color(0xffffffff).withOpacity(0.5);
  static const Color error = Color(0xffe85c4a);
  static const Color transparent = Color(0x00000000);
  static const Color secondary1 = Color(0xff1d2031);
  static const Color secondary2 = Color(0xff1c1e2a);
  static const Color secondary3 = Color(0xff21232e);
  static const Color secondary4 = Color(0xff2b2c37);
  static const Color secondary5 = Color(0xff7a7b82);
  static const Color secondary6 = Color(0xffa6a7ab);
  static const Color secondary7 = Color(0xff3f414c);

  static const int _neutralValue = 0xFF101010;

  static MaterialColor get neutral => const MaterialColor(
        _neutralValue,
        <int, Color>{
          100: Color(0xFFFFFFFF),
          101: Color(0xFF000000),
          102: Color(0xFF222222),
          103: Color(0xFF130F26),
          104: Color(0xFFF9F9F9),
          105: Color(0xFF010101),
          106: Color(0xFFFFEF00),
          107: Color(0xFF181818),
          108: Color(0xFFF5C80A),
          109: Color(0xFFFACF0A),
          110: Color(0xFFF6CF46),
          111: Color(0xFFEFEFEF),
          112: Color(0xFF3A3A3A),
          200: Color(0xFFF2F2F2),
          300: Color(0xFFE9E9E9),
          310: Color(0xFFD9D9D9),
          400: Color(0xFFDCDCDC),
          500: Color(0xFF9F9F9D),
          600: Color(0xFF7C7C79),
          700: Color(0xFF454442),
          800: Color(0xFF222220),
          900: Color(_neutralValue),
          901: Color(0xFF505050),
          902: Color(0xFF606170),
          903: Color(0xFF20212C),
        },
      );

  static MaterialColor get green => const MaterialColor(
        _neutralValue,
        <int, Color>{
          100: Color(0xFF8AF8A9),
        },
      );

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color, //Primary value
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}
