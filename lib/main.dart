import 'package:flutter/material.dart';
import 'container_frame.dart';
import 'theme/app_theme.dart';

void main() {
  final themeController = AppThemeController();
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeController});

  final AppThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Insta_clone',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: ThemeControllerScope(
            controller: themeController,
            child: const ContainerFrame(),
          ),
        );
      },
    );
  }
}
