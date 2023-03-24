import 'package:flutter/material.dart';
import 'package:pitel_ui_kit/styles/app_colors.dart';
import 'package:pitel_ui_kit/styles/app_text_styles.dart';

class AppThemes {
  static String fontFamily = 'Quicksand';

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      primaryColor: AppColors.getMaterialColorFromColor(AppColors.primary),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.black,
      ),
      backgroundColor: AppColors.black,
      scaffoldBackgroundColor: AppColors.black,
      // textTheme: TextThemes.darkTextTheme,
      // primaryTextTheme: TextThemes.primaryTextTheme,
      appBarTheme: AppBarTheme(
        // titleTextStyle: TextThemes.darkTextTheme.headline6,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: AppColors.black,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: AppColors.getMaterialColorFromColor(AppColors.primary),
      textTheme: AppTextTheme.textTheme(AppColors()),
      // primaryTextTheme: TextThemes.primaryTextTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        // titleTextStyle: TextThemes.lightTextTheme.headline6,
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
    );
  }
}

class AppTextTheme {
  static FontWeight get regular => FontWeight.w400;

  static FontWeight get medium => FontWeight.w500;

  static FontWeight get semiBold => FontWeight.w600;

  static FontWeight get bold => FontWeight.w700;

  static TextTheme textTheme(AppColors iGuruColors) {
    return TextTheme(
      displayLarge: _textStyle30.copyWith(
        color: AppColors.secondary1,
        fontWeight: bold,
      ),
      displayMedium: _textStyle20.copyWith(
        color: AppColors.secondary1,
        fontWeight: bold,
      ),
      titleMedium: _textStyle18.copyWith(
        color: AppColors.secondary1,
        fontWeight: semiBold,
      ),
      titleSmall: _textStyle16.copyWith(
        color: AppColors.secondary1,
        fontWeight: semiBold,
      ),
      bodyLarge: _textStyle14.copyWith(
        color: AppColors.secondary1,
        fontWeight: regular,
      ),
      bodyMedium: _textStyle12.copyWith(
        color: AppColors.secondary1,
        fontWeight: regular,
      ),
      bodySmall: _textStyle11.copyWith(
        color: AppColors.secondary1,
        fontWeight: regular,
      ),
      labelSmall: _textStyle10.copyWith(
        color: AppColors.secondary1,
        fontWeight: regular,
        letterSpacing: 0,
      ),
    );
  }

  static const TextStyle _textStyle30 = TextStyle(
    height: 4 / 3,
    fontSize: 30,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle20 = TextStyle(
    height: 4 / 3,
    fontSize: 20,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle18 = TextStyle(
    height: 4 / 3,
    fontSize: 18,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle16 = TextStyle(
    height: 4 / 3,
    fontSize: 16,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle14 = TextStyle(
    height: 4 / 3,
    fontSize: 14,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle12 = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle11 = TextStyle(
    height: 4 / 3,
    fontSize: 11,
    letterSpacing: 0,
  );

  static const TextStyle _textStyle10 = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    letterSpacing: 0,
  );

  static const TextStyle T34B = TextStyle(
    height: 4 / 3,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T26B = TextStyle(
    height: 1.17,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static const TextStyle T24R = TextStyle(
    height: 1.17,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static const TextStyle T22B = TextStyle(
    height: 4 / 3,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    // fontFamily: 'SFUIDisplay',
  );

  static const TextStyle T20B = TextStyle(
    height: 4 / 3,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    // fontFamily: 'SFUIDisplay',
  );

  static const TextStyle T18B = TextStyle(
    height: 4 / 3,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T18R = TextStyle(
    height: 4 / 3,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  static const TextStyle T16B = TextStyle(
    height: 4 / 3,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T16M = TextStyle(
    height: 4 / 3,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle T16R = TextStyle(
    height: 4 / 3,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle T16S = TextStyle(
    height: 4 / 3,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle T14B = TextStyle(
    height: 4 / 3,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle T14M = TextStyle(
    height: 4 / 3,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle T14R = TextStyle(
    height: 4 / 3,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle T14R_strike = TextStyle(
    height: 4 / 3,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.lineThrough,
    letterSpacing: 0,
  );

  static const TextStyle T13B = TextStyle(
    height: 4 / 3,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T13R = TextStyle(
    height: 4 / 3,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle T12B = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T12S = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle T12M = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle T12R = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );
  static const TextStyle T12R_strike = TextStyle(
    height: 4 / 3,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.lineThrough,
    letterSpacing: 0,
  );

  static const TextStyle T11M = TextStyle(
    height: 4 / 3,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle T11R = TextStyle(
    height: 4 / 3,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  static const TextStyle T11B = TextStyle(
    height: 4 / 3,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T11S = TextStyle(
    height: 4 / 3,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle T10B = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T10M = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle T10R = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  static const TextStyle T10S = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  static const TextStyle T10R_strike = TextStyle(
    height: 4 / 3,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.lineThrough,
    letterSpacing: 0,
  );

  static const TextStyle T9R = TextStyle(
    height: 4 / 3,
    fontSize: 9,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  static const TextStyle T7R = TextStyle(
    height: 4 / 3,
    fontSize: 7,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );

  static const TextStyle T29B = TextStyle(
    height: 1.1,
    fontSize: 29,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const TextStyle T22B7 = TextStyle(
    height: 4 / 3,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    //fontFamily: 'SFUIDisplay',
  );
}

//! OLD CODE
// class TextThemes {
//   static TextTheme get textTheme {
//     return TextTheme(
//       bodyLarge: AppTextStyles.bodyLg,
//       bodyMedium: AppTextStyles.body,
//       titleLarge: AppTextStyles.subtitleLg,
//       titleMedium: AppTextStyles.subtitle,
//       titleSmall: AppTextStyles.subtitleSm,
//       displayLarge: AppTextStyles.h1,
//       displayMedium: AppTextStyles.h2,
//       displaySmall: AppTextStyles.h3,
//       headlineMedium: AppTextStyles.h4,
//       headlineSmall: AppTextStyles.h5,
//     );
//   }

//   static TextTheme get darkTextTheme {
//     return TextTheme(
//       bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.white),
//       bodyMedium: AppTextStyles.body.copyWith(color: AppColors.white),
//       titleLarge: AppTextStyles.subtitleLg.copyWith(color: AppColors.white),
//       titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.white),
//       titleSmall: AppTextStyles.subtitleSm.copyWith(color: AppColors.white),
//       displayLarge: AppTextStyles.h1.copyWith(color: AppColors.white),
//       displayMedium: AppTextStyles.h2.copyWith(color: AppColors.white),
//       displaySmall: AppTextStyles.h3.copyWith(color: AppColors.white),
//       headlineMedium: AppTextStyles.h4.copyWith(color: AppColors.white),
//       headlineSmall: AppTextStyles.h5.copyWith(color: AppColors.white),
//     );
//   }

//   static TextTheme get lightTextTheme {
//     return TextTheme(
//       bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.black),
//       bodyMedium: AppTextStyles.body.copyWith(color: AppColors.black),
//       titleLarge: AppTextStyles.subtitleLg.copyWith(color: AppColors.black),
//       titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.black),
//       titleSmall: AppTextStyles.subtitleSm.copyWith(color: AppColors.black),
//       displayLarge: AppTextStyles.h1.copyWith(color: AppColors.black),
//       displayMedium: AppTextStyles.h2.copyWith(color: AppColors.black),
//       displaySmall: AppTextStyles.h3.copyWith(color: AppColors.black),
//       headlineMedium: AppTextStyles.h4.copyWith(color: AppColors.black),
//       headlineSmall: AppTextStyles.h5.copyWith(color: AppColors.black),
//     );
//   }

//   static TextTheme get primaryTextTheme {
//     return TextTheme(
//       bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.white),
//       bodyMedium: AppTextStyles.body.copyWith(color: AppColors.white),
//       titleLarge: AppTextStyles.subtitleLg.copyWith(color: AppColors.white),
//       titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.white),
//       titleSmall: AppTextStyles.subtitleSm.copyWith(color: AppColors.white),
//       displayLarge: AppTextStyles.h1.copyWith(color: AppColors.white),
//       displayMedium: AppTextStyles.h2.copyWith(color: AppColors.white),
//       displaySmall: AppTextStyles.h3.copyWith(color: AppColors.white),
//       headlineMedium: AppTextStyles.h4.copyWith(color: AppColors.white),
//       headlineSmall: AppTextStyles.h5.copyWith(color: AppColors.white),
//     );
//   }
// }
