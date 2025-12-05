import 'package:flutter/material.dart';
part 'theme_extension.dart';

final _textTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Satoshi',
  ),
  displayMedium: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 32.0,
    fontFamily: 'Satoshi',
  ),
  titleLarge: TextStyle(fontSize: 28.0, fontFamily: 'Satoshi'),
  titleMedium: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Satoshi',
  ),
  titleSmall: TextStyle(fontSize: 18.0, fontFamily: 'Satoshi'),
  bodyLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Satoshi',
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Satoshi',
  ),
  bodySmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Satoshi',
  ),
).apply(bodyColor: const Color(0xFF1D1D1D));

class CustomTheme {
  static ThemeData lightThemeData() {
    final textThemeLight = _textTheme.apply(
      displayColor: const Color(0xFF0C0F16), // Midnight Graphite
      bodyColor: const Color(0xFF0C0F16), // Midnight Graphite
    );
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Pear White
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: textThemeLight.bodyLarge,
        backgroundColor: const Color(0xFFFAFAFA), // Pear White
        foregroundColor: const Color(0xFF0C0F16), // Midnight Graphite
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD7B56D), // Soft Gold
        secondary: Color(0xFFB5FFDA), // Neo Mint
        tertiary: Color(0xFFD7B56D), // Soft Gold
        surface: Color(0xFFFAFAFA), // Pear White
        onSurface: Color(0xFF0C0F16), // Midnight Graphite
        surfaceContainerHighest: Color(0xFFC9CCD5), // Mist Silver
        onSurfaceVariant: Color(0xFF6B7280), // Muted text
        error: Color(0xFFDC2626),
        onError: Color(0xFFFFFFFF),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD7B56D), // Soft Gold
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: textThemeLight.bodySmall?.copyWith(
          color: const Color(0xFFC9CCD5), // Mist Silver
        ),
        fillColor: const Color(0xFFFAFAFA), // Pear White
        filled: true,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFC9CCD5), // Mist Silver
        space: 0,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFC9CCD5), // Mist Silver
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFC9CCD5), // Mist Silver
            ),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: const Color(0xFFD7B56D), // Soft Gold
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textThemeLight.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: const Color(0xFF0C0F16), // Midnight Graphite
        ),
        unselectedLabelStyle: textThemeLight.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: const Color(0xFFC9CCD5), // Mist Silver
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: Color(0xFFFAFAFA), // Pear White
        backgroundColor: Color(0xFFFAFAFA), // Pear White
      ),
      textTheme: textThemeLight,
      extensions: [
        const CustomThemeExtension(
          highlightColor: Color(0xFFB5FFDA), // Neo Mint
        ),
      ],
    );
  }

  static ThemeData darkThemeData() {
    final textThemeDark = _textTheme.apply(
      displayColor: const Color(0xFFFAFAFA), // Pear White
      bodyColor: const Color(0xFFFAFAFA), // Pear White
    );
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF0C0F16), // Midnight Graphite
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: textThemeDark.bodyLarge,
        backgroundColor: const Color(0xFF0C0F16), // Midnight Graphite
        foregroundColor: const Color(0xFFFAFAFA), // Pear White
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD7B56D), // Soft Gold
        secondary: Color(0xFFB5FFDA), // Neo Mint
        tertiary: Color(0xFFD7B56D), // Soft Gold
        surface: Color(0xFF1A1F24), // Dark surface
        onSurface: Color(0xFFFAFAFA), // Pear White
        surfaceContainerHighest: Color(0xFF2A2F36), // Lighter dark
        onSurfaceVariant: Color(0xFFC9CCD5), // Mist Silver
        error: Color(0xFFEF4444),
        onError: Color(0xFFFFFFFF),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD7B56D), // Soft Gold
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: textThemeDark.bodyMedium?.copyWith(
          color: const Color(0xFFC9CCD5), // Mist Silver
        ),
        fillColor: const Color(0xFF1A1F24), // Dark surface
        filled: true,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFC9CCD5), // Mist Silver
        space: 0,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFC9CCD5), // Mist Silver
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFC9CCD5), // Mist Silver
            ),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: const Color(0xFFD7B56D), // Soft Gold
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textThemeDark.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: const Color(0xFFFAFAFA), // Pear White
        ),
        unselectedLabelStyle: textThemeDark.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: const Color(0xFFC9CCD5), // Mist Silver
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: Color(0xFF0C0F16), // Midnight Graphite
        backgroundColor: Color(0xFF1A1F24), // Dark surface
      ),
      textTheme: textThemeDark,
      extensions: [
        const CustomThemeExtension(
          highlightColor: Color(0xFFB5FFDA), // Neo Mint
        ),
      ],
    );
  }
}
