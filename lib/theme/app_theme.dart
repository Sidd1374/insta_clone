import 'package:flutter/material.dart';

/// Centralized color tokens used by light and dark themes.
class InstaColors {
  const InstaColors._();

  static const blue = Color(0xFF0095F6);
  static const red = Color(0xFFED4956);

  static const lightBackground = Color(0xFFFFFFFF);
  static const lightPrimaryText = Color(0xFF000000);
  static const lightSecondaryText = Color(0xFF8E8E8E);
  static const lightDivider = Color(0xFFDBDBDB);

  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF121212);
  static const darkPrimaryText = Color(0xFFFFFFFF);
  static const darkSecondaryText = Color(0xFFA8A8A8);
  static const darkDivider = Color(0xFF262626);

  static const storySeenRing = Color(0xFFDBDFE4);
  static const storyCloseFriendRing = Color(0xFF00DA00);
  static const storyPremiumRing = Color(0xFF7638FA);
  static const storyOwnAddButton = Color.fromARGB(255, 0, 0, 0);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: InstaColors.blue,
      error: InstaColors.red,
      surface: InstaColors.lightBackground,
      onSurface: InstaColors.lightPrimaryText,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: InstaColors.lightBackground,
      colorScheme: colorScheme,
      dividerColor: InstaColors.lightDivider,
      primaryColor: InstaColors.lightPrimaryText,
      appBarTheme: const AppBarTheme(
        backgroundColor: InstaColors.lightBackground,
        foregroundColor: InstaColors.lightPrimaryText,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: InstaColors.lightPrimaryText),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: InstaColors.lightBackground,
        selectedItemColor: InstaColors.lightPrimaryText,
        unselectedItemColor: InstaColors.lightSecondaryText,
        selectedIconTheme: IconThemeData(color: InstaColors.lightPrimaryText),
        unselectedIconTheme: IconThemeData(
          color: InstaColors.lightSecondaryText,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: InstaColors.lightPrimaryText),
        bodyMedium: TextStyle(color: InstaColors.lightSecondaryText),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: InstaColors.blue,
      error: InstaColors.red,
      surface: InstaColors.darkSurface,
      onSurface: InstaColors.darkPrimaryText,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: InstaColors.darkBackground,
      colorScheme: colorScheme,
      dividerColor: InstaColors.darkDivider,
      primaryColor: InstaColors.darkPrimaryText,
      appBarTheme: const AppBarTheme(
        backgroundColor: InstaColors.darkBackground,
        foregroundColor: InstaColors.darkPrimaryText,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: InstaColors.darkPrimaryText),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: InstaColors.darkBackground,
        selectedItemColor: InstaColors.darkPrimaryText,
        unselectedItemColor: InstaColors.darkSecondaryText,
        selectedIconTheme: IconThemeData(color: InstaColors.darkPrimaryText),
        unselectedIconTheme: IconThemeData(
          color: InstaColors.darkSecondaryText,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: InstaColors.darkPrimaryText),
        bodyMedium: TextStyle(color: InstaColors.darkSecondaryText),
      ),
    );
  }
}

class AppThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme([Brightness? platformBrightness]) {
    if (_themeMode == ThemeMode.system) {
      final effectiveBrightness = platformBrightness ?? Brightness.light;
      _themeMode = effectiveBrightness == Brightness.dark
          ? ThemeMode.light
          : ThemeMode.dark;
      notifyListeners();
      return;
    }

    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  void resetToSystemTheme() {
    setThemeMode(ThemeMode.system);
  }
}

/// Inherited access point so any screen can read/change theme mode.
class ThemeControllerScope extends InheritedNotifier<AppThemeController> {
  const ThemeControllerScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    assert(scope != null, 'ThemeControllerScope not found in widget tree.');
    return scope!.notifier!;
  }
}
