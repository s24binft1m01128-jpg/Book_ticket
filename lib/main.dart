import 'package:bookticket/router.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Styles.primarycolor,
      primary: Styles.primarycolor,
      secondary: Styles.secondaryColor,
      surface: Styles.surfaceColor,
      brightness: Brightness.light,
    );

    const textTheme = TextTheme(
      bodySmall: Styles.textStyle,
      bodyMedium: Styles.textStyle,
      bodyLarge: Styles.textStyle,
      titleSmall: Styles.headlineStyle4,
      titleMedium: Styles.headlineStyle3,
      titleLarge: Styles.headlineStyle2,
      headlineSmall: Styles.headlineStyle2,
      headlineMedium: Styles.headlineStyle1,
      headlineLarge: Styles.headlineStyle1,
    );

    return MaterialApp.router(
      title: 'SkyPass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Styles.bgcolor,
        primaryColor: Styles.primarycolor,
        fontFamily: 'Roboto',
        textTheme: textTheme,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Styles.textcolor,
          contentTextStyle: Styles.textStyle.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Styles.smallRadius),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
