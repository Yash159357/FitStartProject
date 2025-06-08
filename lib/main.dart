import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/colors.dart';
import 'package:fitstart_project/view/screens/splash_screen.dart';

void main() {
  runApp(const FitStartApp());
}

class FitStartApp extends StatelessWidget {
  const FitStartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitStart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: FitStartColors.green,
        scaffoldBackgroundColor: FitStartColors.darkGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FitStartColors.green,
          brightness: Brightness.dark,
          surface: FitStartColors.darkGrey,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: FitStartColors.darkGrey,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}