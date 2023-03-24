import 'package:flutter/material.dart';

class Palette {
  /// ! Color
  /// ! Remove
  static const Color primaryColor = Color(0xFFF6CF46);
  static const Color secondaryColor = Color(0xFF181818);
  static const Color positiveColor = Color(0xFF00CA71);
  static const Color lightPositiveColor = Color(0xFF92C961);
  static const Color darkRedColor = Color(0xFFD60000);
  static const Color redColorF3 = Color(0xFFFF3030);
  static const Color normalContentColor = Color(0xFF181818);
  static const Color darkHighlightBlueColor = Color(0xFF006989);
  static const Color backgroundColor = Colors.white;
  static const Color disableColor = Color(0xFFAAAAAA);
  static const Color selectingBackgroundColor = Color(0xFFBFD7FF);
  static const Color grayColor = Color(0xFF505050);
  static const Color grayColor74 = Color(0xFF747474);
  static const Color whiteColorF1 = Color(0xFFF1F2F3);
  static const Color whiteColorF2 = Color(0xFFF2F3F5);
  static const Color grayColor46 = Color(0xFF464646);
  // ! Remove end-----------------
  // * Background
  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color bgDraken0 = Color(0xFFF9F9F9);
  static const Color bgDraken100 = Color(0xFFF2F3F5);

  // * Greyscale - prefix gs
  static const Color gsTextPrimary = Color(0xFF181818);
  static const Color gsTextSecondary = Color(0xFF5C5C5C);
  static const Color gsTextTertiary = Color(0xFF747474);
  static const Color gsIcons = Color(0xFF7C7B7B);
  static const Color gsStroke = Color(0xFFD7D7D7);
  static const Color gsDivider = Color(0xFFEDEDED);
  static const Color gsDisabledText = Color(0xFF8A8A8A);
  static const Color gsDisableBg = Color(0xFFEFEFEF);
  static const Color gsTextOnColorPhashes = Color(0xFF181818);

  static const Color gsTextPrimaryDark = Color(0xFFD9D9D9);
  static const Color gsTextSecondaryDark = Color(0xFF9D9D9D);
  static const Color gsTextTertiaryDark = Color(0xFF5C5C5C);
  static const Color gsIconsDark = Color(0xFF6C6C6C);
  static const Color gsStrokeDark = Color(0xFF3A3A3A);
  static const Color gsDividerDark = Color(0xFF323232);
  static const Color gsDisabledTextDark = Color(0xFF8B8B8B);
  static const Color gsDisableBgDark = Color(0xFF4A4A4A);
  static const Color gsTextOnColorPhashesDark = Color(0xFF181818);

  // * Accent 1
  static const Color accent1Primary = Color(0xFF010101);
  static const Color accent1Secondary = Color(0xFF464646);
  static const Color accent1Tertiary = Color(0xFF9A9A9A);
  static const Color accent1Quaternary = Color(0xFFE3E3E3);
  // * Accent 2
  static const Color accent2Hover = Color(0xFFFFE600);
  static const Color accent2Click = Color(0xFFF6CF46);
  static const Color accent2Primary = Color(0xFFFFEF00);
  static const Color accent2Secondary = Color(0xFFFFF342);
  static const Color accent2Tertiary = Color(0xFFFFF99A);
  static const Color accent2Quaternary = Color(0xFFFEFFE5);
  // * Common status colors
  // Error
  static const Color commonStatusErrorClickColor = Color(0xFFE53535);
  static const Color commonStatusErrorColor = Color(0xFFFF3B3B);
  static const Color commonStatusErrorHoverColor = Color(0xFFFF5C5C);
  static const Color commonStatusErrorTertiaryColor = Color(0xFFFFF2F2);
  // Success
  static const Color successfulClickColor = Color(0xFF05A660);
  static const Color successfulColor = Color(0xFF06C270);
  static const Color successfulHoverColor = Color(0xFF39D98A);
  static const Color successfulSecondaryColor = Color(0xFF57EBA1);

  // Payment Background
  static const Color attentionTertiaryColor = Color(0xFFFFF8E5);
  static const Color successfulTertiaryColor = Color(0xFFE3FFF1);
  static const Color errorTertiaryColor = Color(0xFFFFF2F2);
  static const Color attentionColor = Color(0xFFFF8800);

  // Processing
  static const Color processingClickColor = Color(0xFF004FC4);
  static const Color processingColor = Color(0xFF0063F7);
  static const Color processingHoverColor = Color(0xFF5B8DEF);
  static const Color processingSecondaryColor = Color(0xFF9DBFF9);
  static const Color processingTertiaryColor = Color(0xFFE5F0FF);
  static const Color hyperlinkColor = Color(0xFF2D5BFF);

  /// ! Shadow
  ///
  static List<BoxShadow> boxShadow02 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> boxShadow03 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> boxShadow04 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(0),
      spreadRadius: 0,
      blurRadius: 16,
      offset: const Offset(0, 0.5),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 16,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> boxShadow05 = [
    BoxShadow(
      color: const Color(0xFF2C2121).withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: const Color(0xFF2C2121).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> boxShadow06 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(1),
      spreadRadius: 0,
      blurRadius: 4,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(1),
      spreadRadius: 5,
      blurRadius: 1,
      offset: Offset(0, 10),
    ),
  ];
  static List<BoxShadow> boxShadow07 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 0.5),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(0.08),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> boxShadow08 = [
    BoxShadow(
      color: const Color(0xFF606170).withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF28293D).withOpacity(0.04),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> textShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withOpacity(0.25),
      spreadRadius: 0,
      blurRadius: 0,
      offset: const Offset(1, 1),
    ),
  ];

  /// ! Font size
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight mediumBold = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;

  static const double textSize26 = 26.0;
  static const double textSize22 = 22.0;
  static const double textSize20 = 20.0;
  static const double textSize18 = 18.0;
  static const double textSize16 = 16.0;
  static const double textSize15 = 15.0;
  static const double textSize14 = 14.0;

  static const double textLineHeight1_15 = 1.15;
  static const double textLineHeight1_18 = 1.18;
  static const double textLineHeight1_20 = 1.20;
  static const double textLineHeight1_22 = 1.22;
  static const double textLineHeight1_25 = 1.375;
  static const double textLineHeight1_27 = 1.27;
  static const double textLineHeight1_29 = 1.29;

  static const double largeTextSize34 = 34.0;
  static const double largeTextSize29 = 29.0;
  static const double largeTextSize26 = 26.0;
  static const double largeTextSize24 = 24.0;
  static const double largeTextSize21 = 21.0;
  static const double largeTextSize20 = 20.0;
  static const double largeTextSize19 = 19.0;

  static const double largeTextLineHeight1_06 = 1.06;
  static const double largeTextLineHeight1_10 = 1.10;
  static const double largeTextLineHeight1_15 = 1.15;
  static const double largeTextLineHeight1_17 = 1.17;
  static const double largeTextLineHeight1_19 = 1.19;
  static const double largeTextLineHeight1_20 = 1.20;
  static const double largeTextLineHeight1_21 = 1.21;

  static const double defaultPadding = 16.0;
  static const double defaultPaddingText = 14.0;
}

class PaletteDarkMode {
  // * Background
  static const Color bgLight = Color(0xFF272937);
  static const Color bgDraken0 = Color(0xFF20212C);
  static const Color bgDraken100 = Color(0xFF16161E);
}
