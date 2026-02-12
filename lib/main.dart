import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/screens/splash_screen.dart'; // Keep Splash as entry
// Login reference is inside Splash or we can update Splash to import the new LoginScreen AdminApp());
void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // Default standard font, can be changed later
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(), // Use Zoom/Fade for web/desktop feel
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
