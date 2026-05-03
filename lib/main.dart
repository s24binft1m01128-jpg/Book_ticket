import 'package:bookticket/router.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
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
    ).copyWith(
      surfaceContainerHighest: Styles.surfaceMuted,
      outline: Styles.lineColor,
    );

    final textTheme = TextTheme(
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

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    );

    return MaterialApp.router(
      title: 'SkyPass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Styles.bgcolor,
        primaryColor: Styles.primarycolor,
        textTheme: textTheme,
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Styles.bgcolor,
          foregroundColor: Styles.textcolor,
          titleTextStyle: Styles.headlineStyle3,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Styles.surfaceColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Styles.radius),
          ),
          shadowColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: Styles.headlineStyle3.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Styles.primarycolor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: Styles.headlineStyle3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Styles.surfaceColor,
          hintStyle: Styles.headlineStyle4,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Styles.primarycolor,
              width: 1.5,
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Styles.lineColor,
          thickness: 1,
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          indicatorColor: Styles.primarycolor.withValues(alpha: 0.14),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return Styles.headlineStyle4.copyWith(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? Styles.primarycolor : Styles.mutedTextColor,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? Styles.primarycolor : Styles.mutedTextColor,
              size: 24,
            );
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Styles.textcolor,
          contentTextStyle: Styles.textStyle.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Styles.smallRadius),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routerConfig: router,
    );
  }
}
